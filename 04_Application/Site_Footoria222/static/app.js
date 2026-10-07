/* FOOTORIA - SQL Investigation : logique du site (missions + terminal SQL) */
(() => {
  "use strict";
  const $ = (s) => document.querySelector(s);
  const esc = (v) => String(v).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));

  const el = {
    list: $("#missionList"), sql: $("#sql"), run: $("#run"), clear: $("#clear"), feedback: $("#feedback"),
    table: $("#tableWrap"), count: $("#count"), timer: $("#timer"),
    title: $("#activeTitle"), diff: $("#activeDifficulty"), story: $("#activeStory"), hint: $("#activeHint"),
    topbar: document.querySelector(".topbar"), hamb: document.querySelector(".hamb"),
  };
  const state = { missions: [], activeId: null, done: new Set(), startedAt: null, ticker: null };

  /* ---------- chronometre ---------- */
  const fmt = (s) => String(Math.floor(s / 60)).padStart(2, "0") + ":" + String(s % 60).padStart(2, "0");
  function startTimer() {
    if (state.startedAt) return;
    state.startedAt = Date.now();
    state.ticker = setInterval(() => {
      el.timer.textContent = fmt(Math.floor((Date.now() - state.startedAt) / 1000));
    }, 500);
  }
  function stopTimer() { clearInterval(state.ticker); state.ticker = null; }

  /* ---------- missions ---------- */
  async function loadMissions() {
    try {
      const r = await fetch("/api/missions");
      state.missions = await r.json();
      renderMissions();
      if (state.missions.length) selectMission(state.missions[0].id);
    } catch (e) {
      el.list.innerHTML = '<div class="empty">Impossible de charger les missions. Le serveur est-il lancé ?</div>';
    }
  }

  function renderMissions() {
    el.list.innerHTML = state.missions.map((m, i) => `
      <button type="button" class="mission-card" data-id="${m.id}">
        <span class="num">${String(i + 1).padStart(2, "0")}</span>
        <div class="tag">DOSSIER ${String(i + 1).padStart(2, "0")} · ${esc(m.difficulty)}</div>
        <h3>${esc(m.title)}</h3>
        <p>${esc(m.story)}</p>
        <div class="state">À RÉSOUDRE</div>
      </button>`).join("");
    el.list.querySelectorAll(".mission-card").forEach((card) =>
      card.addEventListener("click", () => {
        selectMission(Number(card.dataset.id));
        $("#terminal").scrollIntoView({ behavior: "smooth" });
      }));
  }

  function selectMission(id) {
    const m = state.missions.find((x) => x.id === id);
    if (!m) return;
    state.activeId = id;
    el.title.textContent = m.title;
    el.diff.textContent = m.difficulty;
    el.story.textContent = m.story;
    el.hint.textContent = m.hint;
    el.list.querySelectorAll(".mission-card").forEach((c) => c.classList.toggle("active", Number(c.dataset.id) === id));
    showFeedback(null);
  }

  function markDone(id) {
    state.done.add(id);
    const card = el.list.querySelector(`.mission-card[data-id="${id}"]`);
    if (card) {
      card.classList.add("done");
      card.querySelector(".state").textContent = "✔ TRACE CONFIRMÉE";
    }
  }

  /* ---------- affichage ---------- */
  function showFeedback(fb, extraHtml) {
    if (!fb) { el.feedback.className = "feedback hidden"; el.feedback.innerHTML = ""; return; }
    el.feedback.className = "feedback " + (fb.ok ? "ok" : "ko");
    el.feedback.innerHTML = esc(fb.message) + (extraHtml || "");
  }

  function renderTable(columns, rows) {
    if (!columns || !columns.length) { el.table.innerHTML = '<div class="empty">Aucune colonne retournée.</div>'; return; }
    if (!rows.length) { el.table.innerHTML = '<div class="empty">Aucune ligne.</div>'; return; }
    const head = "<tr>" + columns.map((c) => `<th>${esc(c)}</th>`).join("") + "</tr>";
    const body = rows.map((r) =>
      "<tr>" + columns.map((c) => {
        const v = r[c];
        return `<td>${v === null || v === undefined ? "NULL" : esc(v)}</td>`;
      }).join("") + "</tr>").join("");
    el.table.innerHTML = `<table><thead>${head}</thead><tbody>${body}</tbody></table>`;
  }

  /* ---------- execution ---------- */
  async function runQuery() {
    const sql = el.sql.value.trim();
    startTimer();
    if (!sql) { showFeedback({ ok: false, message: "Écris une requête SQL avant de l'exécuter." }); return; }
    el.run.disabled = true;
    const label = el.run.textContent;
    el.run.textContent = "EXÉCUTION…";
    try {
      const r = await fetch("/api/sql", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sql, mission_id: state.activeId }),
      });
      const data = await r.json().catch(() => ({}));
      if (!r.ok || data.error) {
        showFeedback({ ok: false, message: data.error || "Erreur inattendue du serveur." });
        return;
      }
      renderTable(data.columns, data.rows);
      el.count.textContent = `${data.row_count}${data.truncated ? "+" : ""} ligne${data.row_count > 1 ? "s" : ""}`;

      const fb = data.feedback || { ok: false, message: "" };
      let extra = "";
      if (fb.ok) {
        markDone(state.activeId);
        const idx = state.missions.findIndex((m) => m.id === state.activeId);
        const next = state.missions[idx + 1];
        if (state.done.size === state.missions.length) {
          stopTimer();
          fb.message += ` ENQUÊTE TERMINÉE en ${el.timer.textContent} !`;
        } else if (next) {
          extra = `<button type="button" class="next" data-next="${next.id}">MISSION SUIVANTE →</button>`;
        }
      }
      showFeedback(fb, extra);
      const nb = el.feedback.querySelector(".next");
      if (nb) nb.addEventListener("click", () => { selectMission(Number(nb.dataset.next)); el.sql.focus(); });
    } catch (e) {
      showFeedback({ ok: false, message: "Le serveur ne répond pas. Vérifie que app.py est lancé." });
    } finally {
      el.run.disabled = false;
      el.run.textContent = label;
    }
  }

  /* ---------- evenements ---------- */
  el.run.addEventListener("click", runQuery);
  el.clear.addEventListener("click", () => {
    el.sql.value = "";
    el.table.innerHTML = '<div class="empty">Aucune requête exécutée.</div>';
    el.count.textContent = "0 ligne";
    showFeedback(null);
    el.sql.focus();
  });
  el.sql.addEventListener("input", startTimer, { once: true });
  el.sql.addEventListener("keydown", (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === "Enter") { e.preventDefault(); runQuery(); }
  });
  if (el.hamb) el.hamb.addEventListener("click", () => el.topbar.classList.toggle("open"));

  loadMissions();
})();
