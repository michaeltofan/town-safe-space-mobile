/**
 * Focused Owner Full-Journey V1 checks (standalone prototype).
 * Run: node prototype/owner-journey-v1/owner_journey_test.cjs
 * Requires: playwright + local static server of this directory.
 */
const { spawn } = require("child_process");
const { chromium } = require("playwright");
const path = require("path");
const http = require("http");
const fs = require("fs");

const ROOT = __dirname;
const PORT = 8791;
const BASE = `http://127.0.0.1:${PORT}`;

function contentType(file) {
  if (file.endsWith(".html")) return "text/html; charset=utf-8";
  if (file.endsWith(".css")) return "text/css; charset=utf-8";
  if (file.endsWith(".js")) return "text/javascript; charset=utf-8";
  if (file.endsWith(".png")) return "image/png";
  if (file.endsWith(".jpg")) return "image/jpeg";
  return "application/octet-stream";
}

function startServer() {
  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      const url = new URL(req.url, BASE);
      let rel = decodeURIComponent(url.pathname);
      if (rel === "/") rel = "/index.html";
      const file = path.join(ROOT, rel);
      if (!file.startsWith(ROOT) || !fs.existsSync(file) || fs.statSync(file).isDirectory()) {
        res.writeHead(404);
        res.end("not found");
        return;
      }
      res.writeHead(200, { "Content-Type": contentType(file) });
      fs.createReadStream(file).pipe(res);
    });
    server.listen(PORT, "127.0.0.1", () => resolve(server));
  });
}

function assert(cond, msg) {
  if (!cond) throw new Error(msg);
}

async function run() {
  const server = await startServer();
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 390, height: 844 } });
  let passed = 0;

  try {
    await page.goto(BASE + "/", { waitUntil: "networkidle" });
    assert(await page.locator('[data-screen="welcome"]').count() === 1, "starts at Welcome");
    assert(await page.getByRole("button", { name: "Welcome" }).count() === 1, "Welcome button");
    passed++;

    await page.getByRole("button", { name: "Learn more" }).click();
    assert(await page.getByText("What is TOWN?").count() === 1, "Learn more opens");
    await page.getByRole("button", { name: "Close" }).click();
    passed++;

    await page.getByRole("button", { name: "Welcome" }).click();
    assert(await page.locator('[data-screen="country"]').count() === 1, "country screen");
    await page.getByRole("button", { name: "Italy" }).click();
    await page.getByRole("button", { name: "Continue" }).click();
    passed++;

    assert(await page.locator('[data-screen="city"]').count() === 1, "city screen");
    await page.getByRole("button", { name: /Milano/ }).click();
    assert(await page.getByText("Seleziona la tua città").count() === 1, "official language switch");
    await page.getByRole("button", { name: "Continua" }).click();
    passed++;

    assert(await page.locator('[data-screen="location"]').count() === 1, "location screen");
    assert(await page.getByText("Conferma la tua posizione").count() === 1, "location title");
    await page.getByRole("button", { name: "Verifica posizione" }).click();
    await page.waitForSelector('[data-role="location-result-title"]', { timeout: 5000 });
    assert(await page.getByText("Posizione verificata").count() === 1, "success result");
    passed++;

    // Stub assign so we can assert destination without leaving.
    await page.evaluate(() => {
      window.__assigned = null;
      window.__TOWN_OWNER_JOURNEY_TEST_HOOK__ = (url) => {
        window.__assigned = url;
      };
    });
    await page.getByRole("button", { name: "Continue to TOWN" }).click();
    const assigned = await page.evaluate(() => window.__assigned);
    assert(
      assigned === "/town-safe-space-mobile/experience-v1/",
      "Continue to TOWN targets experience-v1: " + assigned
    );
    passed++;

    console.log(`OWNER_JOURNEY_TESTS_PASSED=${passed}`);
  } finally {
    await browser.close();
    server.close();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
