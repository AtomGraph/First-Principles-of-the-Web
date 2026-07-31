/* Screenshot-strip pipeline for "First Principles of the Web", Ch 3.
 * Stages: 0 full page · 1 style stripped · 2 arrangement stripped (canon-style fact list) · 3 selection exposed (two windows).
 * Usage: node strips.cjs guardian | grafana | composite
 */
const { chromium } = require('playwright');
const fs = require('fs');
const OUT = __dirname;

const VIEWPORT = { width: 1280, height: 1600 };

async function newPage(browser) {
    const ctx = await browser.newContext({ viewport: VIEWPORT, deviceScaleFactor: 2 });
    return ctx.newPage();
}

async function dismissConsent(page) {
    // Guardian uses a Sourcepoint consent iframe; find any accept-ish button in any frame.
    for (let attempt = 0; attempt < 3; attempt++) {
        await page.waitForTimeout(2000);
        for (const frame of page.frames()) {
            try {
                const btn = frame.locator('button', { hasText: /accept|agree|happy|consent/i }).first();
                if (await btn.isVisible({ timeout: 500 })) {
                    await btn.click({ timeout: 2000 });
                    console.log('consent dismissed via frame:', frame.url().slice(0, 80));
                    await page.waitForTimeout(1500);
                    return;
                }
            } catch (e) { /* frame gone or no button — keep looking */ }
        }
    }
    console.log('no consent banner found (fine)');
}

async function removeAds(page) {
    // third-party ad slots are separate documents with their own CSS; they are not the page's content
    await page.evaluate(() => {
        document.querySelectorAll('.ad-slot, [id^="dfp-ad"], [class*="ad-slot"], iframe[id*="google_ads"], [data-link-name="ad slot"]').forEach(e => {
            (e.closest('[class*="ad-slot-container"]') || e).remove();
        });
    });
}

async function settleImages(page) {
    // trigger lazy loading, then return to top
    await page.evaluate(async () => {
        for (let y = 0; y < document.body.scrollHeight && y < 4000; y += 400) {
            window.scrollTo(0, y);
            await new Promise(r => setTimeout(r, 120));
        }
        window.scrollTo(0, 0);
    });
    await page.waitForTimeout(1500);
}

async function stripStyle(page) {
    await page.evaluate(() => {
        const zap = (root) => {
            root.querySelectorAll('link[rel~="stylesheet"], style').forEach(e => e.remove());
            root.querySelectorAll('[style]').forEach(e => e.removeAttribute('style'));
            if (root.adoptedStyleSheets) try { root.adoptedStyleSheets = []; } catch (e) {}
            root.querySelectorAll('*').forEach(e => { if (e.shadowRoot) zap(e.shadowRoot); });
        };
        zap(document);
        // dimension-less SVGs default to 100% width without CSS; give them icon-sized intrinsic geometry
        document.querySelectorAll('svg').forEach(s => {
            const w = s.getAttribute('width');
            if (!w || /%/.test(w)) { s.setAttribute('width', '16'); s.setAttribute('height', '16'); }
        });
    });
    await page.waitForTimeout(500);
}

/* ---------- Guardian ---------- */

async function guardianFacts(page) {
    // Entity = article URL (Guardian article paths contain the year); attributes: headline, section.
    return page.evaluate(() => {
        const seen = new Map();
        document.querySelectorAll('a[href*="/2026/"], a[href*="/2025/"]').forEach(a => {
            const href = a.href.split('#')[0].split('?')[0];
            // innerText (not textContent): respects layout spacing, excludes visually-hidden spans
            const text = (a.innerText || '').replace(/\s+/g, ' ').trim();
            if (!text || text.length < 15) return;
            if (/^\d+\s*comments?$/i.test(text) || /^(video|gallery|podcast)\b.{0,10}$/i.test(text)) return;
            const prev = seen.get(href);
            // several anchors share one article URL (headline, image, comment count); keep the shortest clean text
            if (!prev || text.length < prev.headline.length) {
                const section = new URL(href).pathname.split('/')[1] || '';
                seen.set(href, { uri: href, headline: text, section });
            }
        });
        return [...seen.values()].sort((x, y) => x.uri.localeCompare(y.uri));
    });
}

function factBlocks(facts, limit) {
    return facts.slice(0, limit).map(f =>
        `<div class="e"><b>&lt;${f.uri}&gt;</b><br/>&nbsp;&nbsp;headline&nbsp;&nbsp;"${f.headline.replace(/"/g, '&quot;')}"<br/>&nbsp;&nbsp;section&nbsp;&nbsp;&nbsp;"${f.section}"</div>`
    ).join('\n');
}

const CANON_STYLE = `<style>body{font-family:monospace;font-size:13px;margin:24px}h1{font-size:15px;font-weight:bold;margin:0 0 4px 0}p.note{font-size:12px;margin:0 0 16px 0}div.e{margin:0 0 10px 0}div.col{vertical-align:top;display:inline-block;width:47%;margin-right:2%}</style>`;
// canon look: monospace, one block per entity, sorted, no nesting — style is used only to make the *absence of arrangement* legible

async function guardian(browser) {
    const page = await newPage(browser);
    console.log('loading Guardian…');
    await page.goto('https://www.theguardian.com/international', { waitUntil: 'domcontentloaded', timeout: 60000 });
    await dismissConsent(page);
    await settleImages(page);
    await removeAds(page);

    await page.screenshot({ path: `${OUT}/guardian-0-full.png` });
    console.log('stage 0 done');

    const factsFront = await guardianFacts(page);
    console.log('front-page facts:', factsFront.length);

    await stripStyle(page);
    await page.screenshot({ path: `${OUT}/guardian-1-nostyle.png` });
    console.log('stage 1 done');

    // second window over the same pool, for stage 3
    await page.goto('https://www.theguardian.com/world', { waitUntil: 'domcontentloaded', timeout: 60000 });
    await dismissConsent(page);
    const factsWorld = await guardianFacts(page);
    console.log('world-section facts:', factsWorld.length);

    // stage 2: arrangement stripped — flat sorted fact list
    await page.setContent(`<!doctype html><html><head>${CANON_STYLE}</head><body>
<h1>theguardian.com — arrangement stripped</h1>
<p class="note">one block per entity · sorted · no nesting (${factsFront.length} entities, first 18 shown)</p>
${factBlocks(factsFront, 18)}</body></html>`);
    await page.screenshot({ path: `${OUT}/guardian-2-canon.png` });
    console.log('stage 2 done');

    // stage 3: selection exposed — two windows over the same pool
    const overlap = factsFront.filter(f => factsWorld.some(w => w.uri === f.uri)).length;
    await page.setContent(`<!doctype html><html><head>${CANON_STYLE}</head><body>
<h1>theguardian.com — selection exposed</h1>
<p class="note">two selections, one pool · overlap: ${overlap} entities appear in both windows</p>
<div class="col"><h1>window 1: /international</h1>${factBlocks(factsFront, 9)}</div>
<div class="col"><h1>window 2: /world</h1>${factBlocks(factsWorld, 9)}</div>
</body></html>`);
    await page.screenshot({ path: `${OUT}/guardian-3-windows.png` });
    console.log('stage 3 done');
    await page.close();
}

/* ---------- Grafana ---------- */

async function grafanaFacts(page) {
    // Entity = panel (real panel ids); attributes from innerText: first line is the title, short following lines are values.
    // Panels are virtualized — scroll through the dashboard and accumulate.
    const collected = new Map();
    const harvest = async () => {
        const batch = await page.evaluate(() =>
            [...document.querySelectorAll('[data-viz-panel-key]')].map(p => ({
                key: p.getAttribute('data-viz-panel-key'),
                lines: p.innerText.split('\n').map(s => s.trim()).filter(Boolean)
            })));
        batch.forEach(b => {
            if (!collected.has(b.key) || b.lines.length > collected.get(b.key).lines.length) collected.set(b.key, b);
        });
    };
    await page.mouse.move(800, 800);
    await harvest();
    for (let i = 0; i < 6; i++) { await page.mouse.wheel(0, 1200); await page.waitForTimeout(1500); await harvest(); }
    await page.mouse.wheel(0, -20000);
    await page.waitForTimeout(1500);
    return [...collected.values()]
        .map(({ key, lines }) => ({ id: key, title: lines[0] || key, values: lines.slice(1).filter(l => l.length <= 40).slice(0, 3) }))
        .sort((a, b) => a.id.localeCompare(b.id));
}

function grafanaBlocks(facts, base) {
    return facts.filter(f => f.title).slice(0, 14).map(f =>
        `<div class="e"><b>&lt;${base}#${f.id}&gt;</b><br/>&nbsp;&nbsp;title&nbsp;&nbsp;"${f.title.replace(/"/g, '&quot;')}"${f.values.length ? `<br/>&nbsp;&nbsp;value&nbsp;&nbsp;"${f.values.map(v => v.replace(/"/g, '&quot;')).join('", "')}"` : ''}</div>`
    ).join('\n');
}

async function grafana(browser) {
    const page = await newPage(browser);
    const base = 'https://play.grafana.org/d/avzwehmz/demo-wind-farm';
    console.log('loading Grafana…');
    await page.goto(`${base}?orgId=1&from=now-6h&to=now`, { waitUntil: 'load', timeout: 90000 });
    await page.waitForTimeout(12000); // let panels render

    await page.screenshot({ path: `${OUT}/grafana-0-full.png` });
    console.log('stage 0 done, url:', page.url().slice(0, 100));

    const facts6h = await grafanaFacts(page);
    console.log('panels found:', facts6h.length, JSON.stringify(facts6h.slice(0, 3)));

    await stripStyle(page);
    await page.screenshot({ path: `${OUT}/grafana-1-nostyle.png` });
    console.log('stage 1 done');

    // second window: same dashboard, different time range — the selection travels in the URL
    await page.goto(`${base}?orgId=1&from=now-7d&to=now`, { waitUntil: 'load', timeout: 90000 });
    await page.waitForTimeout(12000);
    const facts7d = await grafanaFacts(page);
    console.log('panels (7d):', facts7d.length);

    await page.setContent(`<!doctype html><html><head>${CANON_STYLE}</head><body>
<h1>play.grafana.org — arrangement stripped</h1>
<p class="note">one block per entity · sorted · no nesting (${facts6h.length} entities)</p>
${grafanaBlocks(facts6h, base)}</body></html>`);
    await page.screenshot({ path: `${OUT}/grafana-2-canon.png` });
    console.log('stage 2 done');

    await page.setContent(`<!doctype html><html><head>${CANON_STYLE}</head><body>
<h1>play.grafana.org — selection exposed</h1>
<p class="note">two selections, one pool · the selection travels in the URL: ?from=now-6h vs ?from=now-7d</p>
<div class="col"><h1>window 1: from=now-6h</h1>${grafanaBlocks(facts6h, base)}</div>
<div class="col"><h1>window 2: from=now-7d</h1>${grafanaBlocks(facts7d, base)}</div>
</body></html>`);
    await page.screenshot({ path: `${OUT}/grafana-3-windows.png` });
    console.log('stage 3 done');
    await page.close();
}

/* ---------- Composites ---------- */

const STAGES = [
    ['0', 'full', 'the page as shipped'],
    ['1', 'style stripped', 'CSS off — nothing it says has changed'],
    ['2', 'arrangement stripped', 'one block per entity, sorted, no nesting'],
    ['3', 'selection exposed', 'two windows, one pool'],
];

async function composite(browser) {
    const page = await newPage(browser);
    for (const [n, name, note] of STAGES) {
        const suffix = n === '0' ? 'full' : n === '1' ? 'nostyle' : n === '2' ? 'canon' : 'windows';
        const g = `guardian-${n}-${suffix}.png`;
        const f = `grafana-${n}-${suffix}.png`;
        const html = `<!doctype html><html><head><style>
body{margin:0;font-family:Georgia,serif;background:#fff}
h1{font-size:18px;font-weight:normal;margin:14px 18px 2px 18px}
p{font-size:13px;color:#444;margin:0 18px 12px 18px;font-style:italic}
div.row{display:flex;gap:8px;padding:0 8px 8px 8px}
figure{margin:0;flex:1}
img{width:100%;border:1px solid #999;display:block}
figcaption{font-size:12px;text-align:center;padding:4px;color:#333}
</style></head><body>
<h1>Strip ${n}: ${name}</h1><p>${note}</p>
<div class="row">
<figure><img src="${g}"/><figcaption>newspaper front page</figcaption></figure>
<figure><img src="${f}"/><figcaption>analytics dashboard</figcaption></figure>
</div></body></html>`;
        const htmlPath = `${OUT}/_composite-${n}.html`;
        fs.writeFileSync(htmlPath, html);
        await page.goto(`file://${htmlPath}`, { waitUntil: 'load' });
        await page.waitForTimeout(1200);
        await page.locator('body').screenshot({ path: `${OUT}/strip-${n}-${name.replace(/ /g, '-')}.png` });
        fs.unlinkSync(htmlPath);
        console.log(`composite ${n} done`);
    }
    await page.close();
}

(async () => {
    const browser = await chromium.launch({ channel: 'chrome', headless: true });
    const what = process.argv[2] || 'all';
    try {
        if (what === 'guardian' || what === 'all') await guardian(browser);
        if (what === 'grafana' || what === 'all') await grafana(browser);
        if (what === 'composite' || what === 'all') await composite(browser);
    } finally {
        await browser.close();
    }
})().catch(e => { console.error('FAILED:', e.message); process.exit(1); });
