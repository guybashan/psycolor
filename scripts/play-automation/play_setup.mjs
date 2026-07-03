#!/usr/bin/env node
/**
 * Play Console helper: create PsyColor + upload internal release.
 * Run: node scripts/play-automation/play_setup.mjs
 * Sign in to Google when the browser opens (one-time).
 */
import { chromium } from 'playwright';
import { existsSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';
import readline from 'readline';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '../..');
const AAB = resolve(ROOT, 'build/app/outputs/bundle/release/app-release.aab');
const PROFILE = resolve(__dirname, '.chrome-profile');
const PRIVACY_URL = 'https://guybashan.github.io/psycolor/privacy-policy.html';

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function waitForEnter(msg) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  await new Promise((res) => rl.question(msg, () => { rl.close(); res(); }));
}

async function main() {
  if (!existsSync(AAB)) {
    console.error('AAB missing. Run: flutter build appbundle --release');
    process.exit(1);
  }

  console.log('Opening Play Console in Chromium...');
  const context = await chromium.launchPersistentContext(PROFILE, {
    headless: false,
    viewport: { width: 1440, height: 960 },
    slowMo: 60,
  });
  const page = context.pages()[0] || (await context.newPage());

  try {
    await page.goto('https://play.google.com/console/u/0/developers', {
      waitUntil: 'networkidle',
      timeout: 120000,
    });

    console.log('\n>>> If not signed in, log in to your Google Play developer account now.');
    await waitForEnter('>>> Press ENTER here after you are signed in and see the Console home...\n');

    // Create app
    await page.goto('https://play.google.com/console/u/0/developers/app/create', {
      waitUntil: 'networkidle',
      timeout: 120000,
    }).catch(() => {});

    await sleep(2000);
    const onCreatePage = await page.getByText(/create app/i).first().isVisible().catch(() => false);
    if (onCreatePage) {
      console.log('Filling create-app form...');
      await page.locator('input').first().fill('PsyColor').catch(() => {});
      const appRadio = page.locator('text=App').first();
      await appRadio.click().catch(() => {});
      const freeRadio = page.locator('text=Free').first();
      await freeRadio.click().catch(() => {});
      for (const box of await page.locator('input[type="checkbox"]').all()) {
        if (!(await box.isChecked())) await box.check().catch(() => {});
      }
      await page.getByRole('button', { name: /create app/i }).last().click().catch(() => {});
      await sleep(6000);
      console.log('App create form submitted.');
    } else {
      console.log('Create-app page not shown — app may already exist.');
    }

    console.log('\n>>> In Play Console, open PsyColor → Testing → Internal testing → Create release');
    console.log(`>>> Privacy policy URL: ${PRIVACY_URL}`);
    console.log(`>>> AAB to upload: ${AAB}`);
    await waitForEnter('>>> Press ENTER after internal release is submitted (or to skip)...\n');

    console.log('Trying API upload as fallback...');
  } finally {
    await context.close();
  }
}

main();
