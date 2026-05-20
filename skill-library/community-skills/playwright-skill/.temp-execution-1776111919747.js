const { chromium } = require('playwright');
const FRONTEND_URL = 'http://localhost:5555';
const FILE_PATH = '{{USER_HOME}}/Downloads/elementor-nova-página-—-implantes-dentários-1775315620184.json';
const PROMPT = `🔥 BLOCO 1 — HERO\nCTA forte e autoridade em implantes em Campinas.\n\n🔥 BLOCO 2 — VÍDEO\nTexto de capa: Acha que não tem mais solução?\n\n🔥 BLOCO 6 — AUTORIDADE\nReforce a experiência da doutora e a segurança do tratamento.\n\n🔥 BLOCO 10 — CTA FINAL\nFechamento com urgência e WhatsApp.`;
(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1440, height: 1100 } });
  await page.goto(FRONTEND_URL, { waitUntil: 'networkidle' });
  await page.setInputFiles('input[type="file"]', FILE_PATH);
  await page.waitForURL(/localhost:5555\/sess_/i, { timeout: 30000 });

  const before = await page.locator('main').innerText();

  await page.getByRole('button', { name: /generate with ai/i }).click();
  await page.locator('textarea').last().fill(PROMPT);
  await page.getByRole('button', { name: /^generate$/i }).click();
  await page.waitForTimeout(15000);

  const after = await page.locator('main').innerText();
  const changed = before !== after;

  const [download] = await Promise.all([
    page.waitForEvent('download', { timeout: 30000 }),
    page.getByRole('button', { name: /export json/i }).click(),
  ]);
  const savePath = '{{USER_HOME}}/Documents/Code/<PRIVATE_TERM>/ai-builder/frontend/e2e-export-2.json';
  await download.saveAs(savePath);

  console.log(JSON.stringify({ changed, beforeSnippet: before.slice(0,300), afterSnippet: after.slice(0,300), downloadPath: savePath }, null, 2));
  await browser.close();
})();
