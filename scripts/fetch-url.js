#!/usr/bin/env node
const { chromium } = require("playwright");

const url = process.argv[2];
if (!url) {
  console.error("Usage: node fetch-url.js <URL>");
  process.exit(1);
}

(async () => {
  let browser;
  try {
    browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto(url, { waitUntil: "load", timeout: 30000 });
    // Wait for JS-rendered content to appear
    await page.waitForTimeout(3000);
    const text = await page.evaluate(() => document.body.innerText);
    console.log(text);
  } catch (err) {
    console.error(`Failed to fetch ${url}: ${err.message}`);
    process.exit(1);
  } finally {
    if (browser) await browser.close();
  }
})();
