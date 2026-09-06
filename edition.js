const q = (selector, context = document) => context.querySelector(selector);
const qa = (selector, context = document) => [...context.querySelectorAll(selector)];
const apparatus = q("#apparatus");
const popover = q("#lemma-popover");

function focusId(id) {
  const el = q(`#${CSS.escape(id)}`);
  if (!el) return;
  el.scrollIntoView({ behavior: "smooth", block: "center" });
  el.classList.add("active");
  setTimeout(() => el.classList.remove("active"), 1600);
}

document.addEventListener("click", event => {
  const button = event.target.closest("button");
  const action = button?.dataset.action;

  if (action === "translation") {
    const pane = q(".translation");
    pane.hidden = !pane.hidden;
    button.setAttribute("aria-pressed", String(!pane.hidden));
  }

  if (action === "lemmas") {
    const active = document.body.classList.toggle("lemmas");
    button.setAttribute("aria-pressed", String(active));
  }

  if (action === "expand-apparatus") {
    const active = apparatus.classList.toggle("expanded");
    button.setAttribute("aria-expanded", String(active));
  }

  const marker = event.target.closest("[data-app]");
  if (marker) {
    q('[data-tab="critical"]').click();
    focusId(marker.dataset.app);
  }

  const backlink = event.target.closest("[data-reading]");
  if (backlink) focusId(backlink.dataset.reading);

  const link = event.target.closest("[data-target]");
  if (link) {
    event.preventDefault();
    focusId(link.dataset.target);
  }
});

qa('[role="tab"]').forEach(tab => tab.addEventListener("click", () => {
  qa('[role="tab"]').forEach(item =>
    item.setAttribute("aria-selected", String(item === tab)));
  qa('[role="tabpanel"]').forEach(panel =>
    panel.hidden = panel.id !== tab.dataset.tab);
}));

document.addEventListener("pointerover", event => {
  const word = event.target.closest(".lemmas .word");
  if (!word) return;
  popover.textContent = word.dataset.lemma;
  popover.hidden = false;
  popover.style.left = `${event.clientX + 12}px`;
  popover.style.top = `${event.clientY + 12}px`;
});

document.addEventListener("pointerout", event => {
  if (event.target.closest(".word")) popover.hidden = true;
});
