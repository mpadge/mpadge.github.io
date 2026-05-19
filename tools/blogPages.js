import panini   from 'panini';
import through2 from 'through2';
import path     from 'path';
import fs       from 'fs';
import yaml     from 'js-yaml';

export function blogPages(PATHS) {
  const marked = require('marked');

  // Build slug → created map from blog.yml
  function loadDateMap() {
    const raw = fs.readFileSync('src/data/blog.yml', 'utf8');
    const entries = yaml.load(raw);
    const map = {};
    for (const entry of entries) {
      if (entry && entry.link) {
        map[entry.link] = { created: entry.created || '', updated: entry.updated || '', mastodon: entry.mastodon || '' };
      }
    }
    return map;
  }

  function slugify(text) {
    return text.toLowerCase().replace(/[^\w\s-]/g, '').replace(/\s+/g, '-');
  }

  function processFootnotes(mdContent) {
    const definitions = {};
    const referenceOrder = [];

    // Extract [^label]: content definitions (single or multi-line; continuation lines are indented)
    const defRegex = /^\[\^([^\]]+)\]:\s*(.+(?:\n[ \t]+.+)*)$/gm;
    let match;
    while ((match = defRegex.exec(mdContent)) !== null) {
      definitions[match[1]] = match[2].replace(/\n[ \t]+/g, ' ').trim();
    }

    // Remove definition lines (including indented continuation lines) from content
    let content = mdContent.replace(/^\[\^[^\]]+\]:\s*.+(?:\n[ \t]+.+)*\n?/gm, '');

    // Replace [^label] references with numbered markers in order of appearance
    content = content.replace(/\[\^([^\]]+)\]/g, (full, label) => {
      if (!definitions[label]) return full;
      if (!referenceOrder.includes(label)) {
        referenceOrder.push(label);
      }
      const num = referenceOrder.indexOf(label) + 1;
      return `<sup class="sidenote-ref" data-sn="${num}">${num}</sup>`;
    });

    const sidenotesHtml = referenceOrder.map((label, i) => {
      const num = i + 1;
      return `<div class="sidenote" id="sn-${num}"><span class="sidenote-num">${num}.</span> ${definitions[label]}</div>`;
    }).join('\n');

    return { content, sidenotesHtml };
  }

  function buildPage(mdContent, dateStr, updatedStr, mastodonUrl) {
    const { content, sidenotesHtml } = processFootnotes(mdContent);

    const headings = [];
    let nextDropcap = false;
    const renderer = new marked.Renderer();

    renderer.html = function(html) {
      if (/<div class="use-dropcap"><\/div>/.test(html)) {
        nextDropcap = true;
        return '';
      }
      return html;
    };

    renderer.paragraph = function(text) {
      if (nextDropcap) {
        nextDropcap = false;
        const letter = text.charAt(0);
        const upper = letter.toUpperCase();
        if (/[A-Z]/.test(upper)) {
          return `<p><span class="dropcap dropcap-${upper}">${letter}</span>${text.slice(1)}</p>\n`;
        }
      }
      return `<p>${text}</p>\n`;
    };

    renderer.heading = function(text, level) {
      const id = slugify(text);
      headings.push({ id, text });
      return `<section id="${id}" data-magellan-target="${id}"><h${level}>${text}</h${level}></section>\n`;
    };

    renderer.hr = function() {
      return `<div class="blog-divider" aria-hidden="true">` +
        `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 24">` +
        `<g fill="none" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round">` +
        `<path d="M24,12 C20,5 11,5 9,10 C7,15 11,19 17,17 C22,15 23,11 19,9"/>` +
        `<path d="M24,12 C32,4 48,20 56,12 C64,4 80,20 88,12 C96,4 112,20 120,12 C128,4 144,20 152,12 C160,4 176,20 184,12"/>` +
        `<line x1="184" y1="12" x2="193" y2="12"/>` +
        `<polygon points="200,6 207,12 200,18 193,12" fill="currentColor" stroke="none"/>` +
        `<line x1="207" y1="12" x2="216" y2="12"/>` +
        `<path d="M216,12 C224,4 240,20 248,12 C256,4 272,20 280,12 C288,4 304,20 312,12 C320,4 336,20 344,12 C352,4 368,20 376,12"/>` +
        `<path d="M376,12 C380,5 389,5 391,10 C393,15 389,19 383,17 C378,15 377,11 381,9"/>` +
        `</g></svg></div>\n`;
    };

    const rawHtml = marked(content, { renderer }).replace(/\{\{/g, '\\{{');
    const dateLine = [
      dateStr,
      updatedStr ? `<span class="blog-updated">&#x27F6; ${updatedStr} (updated)</span>` : ''
    ].filter(Boolean).join(' ');
    const html = dateLine
      ? rawHtml.replace('</section>', `</section>\n<p class="blog-date">${dateLine}</p>`)
      : rawHtml;

    const navItems = headings.map(h =>
      `<li><a href="#${h.id}" style="color:#111111">${h.text}</a></li>`
    ).join('\n');

    return '{{> header}}\n' +
      '{{> blog_entry_header}}\n' +
      '<div class="cell medium-2 large-2 left">\n' +
      '<nav class="sticky-container" data-sticky-container>\n' +
      '<div class="sticky" data-sticky data-anchor="blog-content" data-sticky-on="medium" data-margin-top="5">\n' +
      '<ul class="vertical menu" data-magellan>\n' +
      navItems + '\n' +
      '</ul>\n</div>\n</nav>\n</div>\n' +
      '<div id="blog-content" class="cell medium-8 large-8">\n' +
      '<div class="sections">\n' +
      html + '\n' +
      '</div>\n</div>\n' +
      '<div id="sidenotes-panel" class="cell medium-2 large-2">\n' +
      sidenotesHtml + '\n' +
      '</div>\n' +
      `<div id="mastodon-comments" data-mastodon-url="${mastodonUrl || ''}"></div>\n` +
      '{{> blog_entry_footer}}\n' +
      '{{> footer}}\n';
  }

  const dateMap = loadDateMap();

  return require('gulp').src('src/pages/blog/*.md', { base: 'src/pages/' })
    .pipe(through2.obj(function(file, enc, cb) {
      if (file.isBuffer()) {
        const slug = path.basename(file.path)
          .replace(/\.md$/, '.html')
          .replace(/^\d{4}-\d{2}-\d{2}-/, '');
        const meta = dateMap[slug] || {};
        const dateStr = meta.created || '';
        const updatedStr = meta.updated || '';
        const mastodonUrl = meta.mastodon || '';
        file.contents = Buffer.from(buildPage(file.contents.toString(enc), dateStr, updatedStr, mastodonUrl));
        file.path = file.path.replace(/\.md$/, '.html')
                              .replace(/([\\/])\d{4}-\d{2}-\d{2}-/, '$1');
      }
      cb(null, file);
    }))
    .pipe(panini({
      root: 'src/pages/',
      layouts: 'src/layouts/',
      partials: 'src/partials/',
      data: 'src/data/',
      helpers: 'src/helpers/'
    }))
    .pipe(require('gulp').dest(PATHS.dist));
}
