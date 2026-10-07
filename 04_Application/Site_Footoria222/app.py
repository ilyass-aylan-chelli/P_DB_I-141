import os, re
from flask import Flask, render_template, request, jsonify
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

app = Flask(__name__)
# ETML : connexion par defaut a SQL Server local (authentification Windows).
# Pour une autre base, definir la variable d'environnement DATABASE_URL.
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "mssql+pyodbc://@localhost/footoria?driver=ODBC+Driver+18+for+SQL+Server"
    "&trusted_connection=yes&TrustServerCertificate=yes",
)
engine = create_engine(DATABASE_URL, pool_pre_ping=True)

# Security model:
# - The browser sends SQL to /api/sql.
# - Only SELECT/WITH statements are accepted.
# - Multiple statements, comments and write/DDL commands are rejected.
# - For production, use a dedicated read-only DB user.
FORBIDDEN = re.compile(
    r"\b(INSERT|UPDATE|DELETE|DROP|ALTER|CREATE|TRUNCATE|REPLACE|MERGE|GRANT|REVOKE|ATTACH|DETACH|PRAGMA|VACUUM|CALL|EXEC|EXECUTE)\b",
    re.I
)

MISSIONS = [
    {
        "id": 1,
        "title": "LA PREMIÈRE TRACE",
        "difficulty": "INITIATION",
        "story": "Les archives ont conservé une liste de joueurs. Retrouve les joueurs dont le nom contient la lettre « a ».",
        "hint": "Utilise SELECT, FROM, puis WHERE avec LIKE.",
        "expected": ["select", "from", "where", "like"],
    },
    {
        "id": 2,
        "title": "LA CONNEXION",
        "difficulty": "MOYEN",
        "story": "Les identifiants seuls ne suffisent plus. Relie les joueurs (Joueurs) et les clubs (Equipe) pour afficher le nom du club de chaque joueur.",
        "hint": "JOIN Joueurs et Equipe sur id_equipe.",
        "expected": ["select", "from", "join"],
    },
]

@app.get("/")
def index():
    return render_template("index.html")

@app.get("/api/missions")
def missions():
    # Do not expose expected keywords to the client.
    return jsonify([{k:v for k,v in m.items() if k != "expected"} for m in MISSIONS])

@app.post("/api/sql")
def run_sql():
    payload = request.get_json(silent=True) or {}
    sql = (payload.get("sql") or "").strip()
    mission_id = payload.get("mission_id")

    if not sql:
        return jsonify({"error": "Écris une requête SQL."}), 400
    if len(sql) > 5000:
        return jsonify({"error": "Requête trop longue (5000 caractères maximum)."}), 400

    # Basic read-only gate. This is intentionally conservative.
    normalized = re.sub(r"\s+", " ", sql).strip()
    if not re.match(r"^(SELECT|WITH)\b", normalized, re.I):
        return jsonify({"error": "Footoria accepte uniquement les requêtes SELECT / WITH."}), 400
    if ";" in normalized.rstrip(";"):
        return jsonify({"error": "Une seule requête est autorisée."}), 400
    if "--" in normalized or "/*" in normalized or "*/" in normalized:
        return jsonify({"error": "Les commentaires SQL ne sont pas autorisés."}), 400
    if FORBIDDEN.search(normalized):
        return jsonify({"error": "Cette instruction SQL est interdite en mode enquête."}), 400

    # Safety timeout is DB-specific; production should also enforce a DB statement timeout.
    try:
        with engine.connect() as conn:
            result = conn.execute(text(normalized.rstrip(";")))
            rows = result.mappings().fetchmany(100)
            columns = list(result.keys())

        feedback = validate_mission(sql, mission_id, columns, rows)
        return jsonify({
            "columns": columns,
            "rows": [dict(r) for r in rows],
            "row_count": len(rows),
            "truncated": len(rows) == 100,
            "feedback": feedback
        })
    except SQLAlchemyError as e:
        return jsonify({"error": f"Erreur SQL : {str(e)}"}), 400

def validate_mission(sql, mission_id, columns, rows):
    try:
        m = next(x for x in MISSIONS if x["id"] == int(mission_id))
    except Exception:
        return {"ok": False, "message": "Mission inconnue."}

    low = sql.lower()
    missing = [kw for kw in m["expected"] if kw not in low]
    if missing:
        return {
            "ok": False,
            "message": "La requête s'exécute, mais il manque encore : " + ", ".join(missing).upper() + "."
        }
    if not rows:
        return {"ok": False, "message": "Requête valide, mais aucun résultat. Essaie un autre filtre."}
    return {
        "ok": True,
        "message": "TRACE CONFIRMÉE. La requête renvoie des résultats. Passe à l'indice suivant."
    }

@app.get("/health")
def health():
    try:
        with engine.connect() as conn: conn.execute(text("SELECT 1"))
        return jsonify({"status":"ok"})
    except Exception: return jsonify({"status":"database_error"}), 503

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=int(os.getenv("PORT","5000")), debug=False)
