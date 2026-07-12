/* TOWN Feed Experience Prototype V1
   EXPERIENCE PROTOTYPE ONLY — NOT FLUTTER PRODUCT — NOT APPROVED UI */

(function () {
  "use strict";

  const feed = document.getElementById("feed");
  const sheet = document.getElementById("sheet");
  if (!feed || !sheet) return;

  let lastFocused = null;

  function lockPageScroll() {
    document.documentElement.style.overflow = "hidden";
    document.body.style.overflow = "hidden";
  }

  function openSheet(trigger) {
    lastFocused = trigger || document.activeElement;
    sheet.hidden = false;
    document.body.classList.add("sheet-open");
    const closeBtn = sheet.querySelector(".sheet-close");
    if (closeBtn) closeBtn.focus();
  }

  function closeSheet() {
    if (sheet.hidden) return;
    sheet.hidden = true;
    document.body.classList.remove("sheet-open");
    if (lastFocused && typeof lastFocused.focus === "function") {
      lastFocused.focus();
    }
  }

  feed.querySelectorAll(".scene").forEach((scene) => {
    const confirmBtn = scene.querySelector('[data-role="confirm"]');
    const openBtn = scene.querySelector('[data-role="open"]');
    const countEl = scene.querySelector('[data-role="count"]');
    let confirmed = false;
    const baseCount = Number(scene.dataset.count || "0");

    if (countEl) countEl.textContent = String(baseCount);

    if (confirmBtn) {
      confirmBtn.addEventListener("click", () => {
        if (confirmed) return;
        confirmed = true;
        const next = baseCount + 1;
        if (countEl) countEl.textContent = String(next);
        confirmBtn.setAttribute("aria-pressed", "true");
        confirmBtn.textContent = "You confirmed this locally";
      });
    }

    if (openBtn) {
      openBtn.addEventListener("click", () => openSheet(openBtn));
    }
  });

  sheet.querySelectorAll('[data-role="sheet-close"]').forEach((el) => {
    el.addEventListener("click", closeSheet);
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeSheet();
  });

  // Keep scene height aligned with the live visual viewport (iPhone Safari).
  function syncViewportHeight() {
    const vv = window.visualViewport;
    const h = vv && vv.height ? vv.height : window.innerHeight;
    document.documentElement.style.setProperty("--scene-h", `${h}px`);
  }

  syncViewportHeight();
  lockPageScroll();
  window.addEventListener("resize", syncViewportHeight);
  window.addEventListener("orientationchange", syncViewportHeight);
  if (window.visualViewport) {
    window.visualViewport.addEventListener("resize", syncViewportHeight);
    window.visualViewport.addEventListener("scroll", syncViewportHeight);
  }

  // Refresh always returns to the first scene.
  feed.scrollTop = 0;
})();
