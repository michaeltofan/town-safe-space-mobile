/* TOWN Owner Full-Journey V1 — PUBLIC TEST ROUTE ONLY
   NOT Flutter product. NOT auth. NOT approved product UI. */

(function () {
  "use strict";

  var EXPERIENCE_URL = "/town-safe-space-mobile/experience-v1/";
  var LEARN_MORE_TITLE = "What is TOWN?";
  var LEARN_MORE_BODY =
    "TOWN is local civic infrastructure for real people, useful information, and community.\n\n" +
    "It helps people access and share relevant information about the city they live in.\n\n" +
    "TOWN is not social media. It has no global feed, no follower race, and no advertising-driven engagement.";

  var state = {
    step: "welcome",
    country: null,
    city: null,
    locationPhase: "idle",
    accuracyMeters: 28,
  };

  var root = document.getElementById("app");
  var timers = [];

  function clearTimers() {
    timers.forEach(function (id) {
      clearTimeout(id);
    });
    timers = [];
  }

  function later(fn, ms) {
    timers.push(setTimeout(fn, ms));
  }

  function syncViewport() {
    var vv = window.visualViewport;
    var h = vv && vv.height ? vv.height : window.innerHeight;
    document.documentElement.style.setProperty("--vh", h + "px");
  }

  function parseHash() {
    var raw = (location.hash || "#welcome").replace(/^#/, "");
    var parts = raw.split("/");
    return {
      step: parts[0] || "welcome",
      country: parts[1] || null,
      city: parts[2] || null,
      locationPhase: parts[3] || "idle",
    };
  }

  function writeHash(replace) {
    var hash = "#" + state.step;
    if (state.country) hash += "/" + encodeURIComponent(state.country);
    if (state.city) hash += "/" + encodeURIComponent(state.city);
    if (state.step === "location") {
      hash += "/" + encodeURIComponent(state.locationPhase);
    }
    if (replace) {
      history.replaceState(null, "", hash);
    } else {
      history.pushState(null, "", hash);
    }
  }

  function applyParsed(parsed) {
    state.step = parsed.step;
    state.country = parsed.country;
    state.city = parsed.city;
    state.locationPhase =
      parsed.step === "location" ? parsed.locationPhase || "idle" : "idle";
    if (state.step === "welcome") {
      state.country = null;
      state.city = null;
      state.locationPhase = "idle";
    }
  }

  function go(step, opts) {
    opts = opts || {};
    clearTimers();
    state.step = step;
    if (step !== "location") state.locationPhase = "idle";
    writeHash(!!opts.replace);
    render();
  }

  function cityCopy() {
    if (!state.city) {
      return {
        title: "Select your city",
        supporting: "Choose your city to continue.",
        notice:
          "TOWN is available only in the official language of the selected country and city.",
        countryLabel: "Country",
        countryName: state.country,
        change: "Change",
        cityLabel: "Select city",
        cityName: state.country === "Germany" ? "Munich" : "Milano",
        locked: "Other cities coming soon",
        continueLabel: "Continue",
      };
    }
    if (state.country === "Italy") {
      return {
        title: "Seleziona la tua città",
        supporting: "Scegli la tua città per continuare.",
        notice:
          "TOWN è disponibile solo nella lingua ufficiale del paese e della città selezionati.",
        countryLabel: "Paese",
        countryName: "Italia",
        change: "Cambia",
        cityLabel: "Seleziona città",
        cityName: "Milano",
        locked: "Altre città in arrivo",
        continueLabel: "Continua",
      };
    }
    return {
      title: "Wähle deine Stadt",
      supporting: "Wähle deine Stadt, um fortzufahren.",
      notice:
        "TOWN ist nur in der Amtssprache des ausgewählten Landes und der ausgewählten Stadt verfügbar.",
      countryLabel: "Land",
      countryName: "Deutschland",
      change: "Ändern",
      cityLabel: "Stadt auswählen",
      cityName: "München",
      locked: "Weitere Städte folgen",
      continueLabel: "Weiter",
    };
  }

  function locationCopy() {
    var cityLabel =
      state.country === "Italy"
        ? "Milano"
        : state.country === "Germany"
          ? "München"
          : state.city;
    if (state.country === "Italy") {
      return {
        title: "Conferma la tua posizione",
        intro:
          "Per mantenere TOWN una comunità reale e locale, verifichiamo che ti trovi a " +
          cityLabel +
          ".",
        cardTitle: "Perché è richiesta la posizione?",
        cardText: "Ci aiuta a mantenere TOWN locale, sicuro e affidabile.",
        points: [
          "Usiamo la tua posizione solo una volta, in primo piano, per questa verifica.",
          "Non memorizziamo né trasmettiamo le tue coordinate.",
          "Non monitoriamo la tua posizione in background.",
        ],
        primaryIdle: "Verifica posizione",
        notNow: "Non ora",
        checking: "Controllo dell’autorizzazione…",
        verifying: "Verifica della posizione in corso…",
        confirmedTitle: "Posizione verificata",
        confirmedBody:
          "La verifica indica che ti trovi a " +
          cityLabel +
          ". Precisione: circa " +
          state.accuracyMeters +
          " m.",
        continueToTown: "Continue to TOWN",
        cityDisplay: cityLabel,
      };
    }
    return {
      title: "Bestätige deinen Standort",
      intro:
        "Damit TOWN eine echte lokale Gemeinschaft bleibt, prüfen wir, ob du dich in " +
        cityLabel +
        " befindest.",
      cardTitle: "Warum wird dein Standort benötigt?",
      cardText: "Damit TOWN lokal, sicher und vertrauenswürdig bleibt.",
      points: [
        "Wir nutzen deinen Standort nur einmalig im Vordergrund für diese Prüfung.",
        "Wir speichern und übermitteln deine Koordinaten nicht.",
        "Wir verfolgen deinen Standort nicht im Hintergrund.",
      ],
      primaryIdle: "Standort prüfen",
      notNow: "Nicht jetzt",
      checking: "Berechtigung wird geprüft…",
      verifying: "Standort wird geprüft…",
      confirmedTitle: "Standort bestätigt",
      confirmedBody:
        "Die Prüfung zeigt, dass du dich in " +
        cityLabel +
        " befindest. Ungefähre Genauigkeit: " +
        state.accuracyMeters +
        " m.",
      continueToTown: "Continue to TOWN",
      cityDisplay: cityLabel,
    };
  }

  function openLearnMore() {
    var existing = document.getElementById("learn-more-sheet");
    if (existing) existing.remove();
    var sheet = document.createElement("div");
    sheet.id = "learn-more-sheet";
    sheet.className = "sheet";
    sheet.setAttribute("role", "dialog");
    sheet.setAttribute("aria-modal", "true");
    sheet.setAttribute("aria-labelledby", "learn-more-title");
    sheet.innerHTML =
      '<div class="sheet-backdrop" data-close="1"></div>' +
      '<div class="sheet-panel">' +
      '<h2 id="learn-more-title">' +
      LEARN_MORE_TITLE +
      "</h2>" +
      "<p>" +
      LEARN_MORE_BODY +
      "</p>" +
      '<button type="button" class="btn btn-primary" data-close="1">Close</button>' +
      "</div>";
    document.body.appendChild(sheet);
    sheet.addEventListener("click", function (event) {
      if (event.target.getAttribute("data-close") === "1") {
        sheet.remove();
      }
    });
  }

  function startOwnerLocationTest() {
    // Isolated prototype/test path: visually walk permission + verifying,
    // then land on the accepted successful location-result state.
    // Does not weaken production Flutter permission rules.
    state.locationPhase = "requestingPermission";
    writeHash(true);
    render();
    later(function () {
      state.locationPhase = "readingAndClassifying";
      writeHash(true);
      render();
      later(function () {
        state.locationPhase = "confirmedGood";
        writeHash(true);
        render();
      }, 900);
    }, 700);
  }

  function continueToExperience() {
    // Same-tab transition into the existing Experience Prototype V1.
    if (typeof window.__TOWN_OWNER_JOURNEY_TEST_HOOK__ === "function") {
      window.__TOWN_OWNER_JOURNEY_TEST_HOOK__(EXPERIENCE_URL);
      return;
    }
    window.location.assign(EXPERIENCE_URL);
  }

  function renderWelcome() {
    return (
      '<section class="screen" data-screen="welcome">' +
      '<div class="col">' +
      '<p class="brand">TOWN</p>' +
      '<p class="tagline">Real communities.\nReal stories.\nNo noise.</p>' +
      '<div class="hero-art"><img src="assets/welcome_screen.png" alt="Calm European street illustration" /></div>' +
      '<p class="fineprint">TOWN accepts accounts only with registration, confirmed location, and an active membership.</p>' +
      '<button type="button" class="btn btn-primary" data-action="start">Welcome</button>' +
      '<button type="button" class="btn btn-secondary" data-action="learn-more">Learn more</button>' +
      '<p class="footer-note">A local civic space for thoughtful neighbourhood stories.</p>' +
      "</div></section>"
    );
  }

  function renderCountry() {
    var italy = state.country === "Italy";
    var germany = state.country === "Germany";
    return (
      '<section class="screen" data-screen="country">' +
      '<div class="col">' +
      '<div class="topbar"><button type="button" class="icon-back" data-action="back" aria-label="Back">‹</button></div>' +
      '<h1 class="title">Where is your TOWN?</h1>' +
      '<p class="support">Select your country to continue.</p>' +
      '<div class="notice"><span class="notice-badge" aria-hidden="true">i</span><p>TOWN is available only in the official language of the selected country and city.</p></div>' +
      '<p class="section-label">Country</p>' +
      '<button type="button" class="choice" data-action="pick-country" data-country="Italy" aria-pressed="' +
      (italy ? "true" : "false") +
      '"><img class="flag" src="assets/italy.png" alt="" /><span class="choice-label">Italy</span><span class="radio" aria-hidden="true"></span></button>' +
      '<button type="button" class="choice" data-action="pick-country" data-country="Germany" aria-pressed="' +
      (germany ? "true" : "false") +
      '"><img class="flag" src="assets/germany.png" alt="" /><span class="choice-label">Germany</span><span class="radio" aria-hidden="true"></span></button>' +
      '<div class="spacer"></div>' +
      '<button type="button" class="btn btn-primary" data-action="to-city"' +
      (state.country ? "" : " disabled") +
      ">Continue</button>" +
      "</div></section>"
    );
  }

  function renderCity() {
    var copy = cityCopy();
    var selected = !!state.city;
    var image =
      state.country === "Germany" ? "assets/munich.png" : "assets/milano.png";
    return (
      '<section class="screen" data-screen="city">' +
      '<div class="col">' +
      '<div class="topbar"><button type="button" class="icon-back" data-action="back" aria-label="Back">‹</button></div>' +
      '<h1 class="title">' +
      copy.title +
      "</h1>" +
      '<p class="support">' +
      copy.supporting +
      "</p>" +
      '<div class="notice"><span class="notice-badge" aria-hidden="true">i</span><p>' +
      copy.notice +
      "</p></div>" +
      '<p class="section-label">' +
      copy.countryLabel +
      "</p>" +
      '<div class="country-row"><div class="country-row-main"><img class="flag" src="assets/' +
      (state.country === "Germany" ? "germany" : "italy") +
      '.png" alt="" /><strong>' +
      copy.countryName +
      '</strong></div><button type="button" class="btn-ghost btn" style="width:auto;min-height:40px;padding:0.4rem 0.9rem" data-action="change-country">' +
      copy.change +
      "</button></div>" +
      '<p class="section-label">' +
      copy.cityLabel +
      "</p>" +
      '<button type="button" class="city-card" data-action="pick-city" aria-pressed="' +
      (selected ? "true" : "false") +
      '"><img src="' +
      image +
      '" alt="" /><div class="city-card-caption">' +
      copy.cityName +
      "</div></button>" +
      '<p class="locked">' +
      copy.locked +
      "</p>" +
      '<div class="spacer"></div>' +
      '<button type="button" class="btn btn-primary" data-action="to-location"' +
      (selected ? "" : " disabled") +
      ">" +
      copy.continueLabel +
      "</button>" +
      "</div></section>"
    );
  }

  function renderLocation() {
    var copy = locationCopy();
    var phase = state.locationPhase;
    var busy =
      phase === "requestingPermission" || phase === "readingAndClassifying";
    var confirmed = phase === "confirmedGood";
    var statusHtml = "";
    if (phase === "requestingPermission") {
      statusHtml = '<p class="busy-line" data-role="busy">' + copy.checking + "</p>";
    } else if (phase === "readingAndClassifying") {
      statusHtml = '<p class="busy-line" data-role="busy">' + copy.verifying + "</p>";
    } else if (confirmed) {
      statusHtml =
        '<div class="status-block" data-role="location-result">' +
        '<p class="status-title is-ok" data-role="location-result-title">' +
        copy.confirmedTitle +
        "</p>" +
        '<p class="status-body" data-role="location-result-body">' +
        copy.confirmedBody +
        "</p></div>";
    }

    var primary =
      confirmed
        ? '<button type="button" class="btn btn-primary" data-action="continue-to-town" data-role="continue-to-town">' +
          copy.continueToTown +
          "</button>"
        : '<button type="button" class="btn btn-primary" data-action="verify-location" data-role="verify-location"' +
          (busy ? " disabled" : "") +
          ">" +
          copy.primaryIdle +
          "</button>";

    return (
      '<section class="screen" data-screen="location">' +
      '<div class="col">' +
      '<div class="topbar"><button type="button" class="icon-back" data-action="back" aria-label="Back"' +
      (busy ? " disabled" : "") +
      ">‹</button></div>" +
      '<h1 class="title">' +
      copy.title +
      "</h1>" +
      '<p class="support">' +
      copy.intro +
      "</p>" +
      '<div class="privacy"><h2>' +
      copy.cardTitle +
      "</h2><p>" +
      copy.cardText +
      "</p><ul><li>" +
      copy.points.join("</li><li>") +
      "</li></ul></div>" +
      statusHtml +
      '<div class="spacer"></div>' +
      primary +
      (confirmed
        ? ""
        : '<button type="button" class="btn btn-secondary" data-action="not-now"' +
          (busy ? " disabled" : "") +
          ">" +
          copy.notNow +
          "</button>") +
      "</div></section>"
    );
  }

  function render() {
    if (!root) return;
    var html = "";
    if (state.step === "welcome") html = renderWelcome();
    else if (state.step === "country") html = renderCountry();
    else if (state.step === "city") html = renderCity();
    else if (state.step === "location") html = renderLocation();
    else {
      state.step = "welcome";
      html = renderWelcome();
    }
    root.innerHTML = html;
  }

  function onClick(event) {
    var target = event.target.closest("[data-action]");
    if (!target) return;
    var action = target.getAttribute("data-action");

    if (action === "start") {
      state.country = null;
      state.city = null;
      go("country");
      return;
    }
    if (action === "learn-more") {
      openLearnMore();
      return;
    }
    if (action === "back") {
      if (state.step === "country") go("welcome");
      else if (state.step === "city") go("country");
      else if (state.step === "location") go("city");
      return;
    }
    if (action === "pick-country") {
      state.country = target.getAttribute("data-country");
      state.city = null;
      writeHash(true);
      render();
      return;
    }
    if (action === "to-city") {
      if (!state.country) return;
      go("city");
      return;
    }
    if (action === "change-country") {
      state.city = null;
      go("country");
      return;
    }
    if (action === "pick-city") {
      state.city = state.country === "Germany" ? "Munich" : "Milano";
      writeHash(true);
      render();
      return;
    }
    if (action === "to-location") {
      if (!state.city) return;
      state.locationPhase = "idle";
      go("location");
      return;
    }
    if (action === "verify-location") {
      startOwnerLocationTest();
      return;
    }
    if (action === "not-now") {
      state.country = null;
      state.city = null;
      go("welcome");
      return;
    }
    if (action === "continue-to-town") {
      continueToExperience();
    }
  }

  function onPopState() {
    clearTimers();
    applyParsed(parseHash());
    render();
  }

  function boot() {
    syncViewport();
    window.addEventListener("resize", syncViewport);
    window.addEventListener("orientationchange", syncViewport);
    if (window.visualViewport) {
      window.visualViewport.addEventListener("resize", syncViewport);
    }
    applyParsed(parseHash());
    if (!location.hash || location.hash === "#") {
      writeHash(true);
    }
    render();
    root.addEventListener("click", onClick);
    window.addEventListener("popstate", onPopState);
    window.addEventListener("hashchange", onPopState);
  }

  boot();
})();
