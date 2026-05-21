import panini              from 'panini';
import through2            from 'through2';
import path                from 'path';
import fs                  from 'fs';
import yaml                from 'js-yaml';
import { INFO_CORNER_SVG,
         SUMMARY_FRAME_SVG,
         CONCLUSION_FRAME_SVG,
         ASTERISM_HTML,
         DIVIDER_HTML,
         PROGRESS_DIAMOND_SVG } from './blogPageDecorations.js';

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
      const defHtml = marked(definitions[label].replace(/\n/g, '  \n')).trim().replace(/^<p>/, '').replace(/<\/p>$/, '');
      return `<div class="sidenote" id="sn-${num}"><span class="sidenote-num">${num}.</span> ${defHtml}</div>`;
    }).join('\n');

    return { content, sidenotesHtml };
  }

  function loadLinkSummaries(mdPath) {
    const rmdPath = mdPath.replace(/\.md$/, '.Rmd');
    if (!fs.existsSync(rmdPath)) return {};
    const raw = fs.readFileSync(rmdPath, 'utf8');
    const match = raw.match(/^---\n([\s\S]*?)\n---/);
    if (!match) return {};
    const fm = yaml.load(match[1]);
    return (fm && fm.links) ? fm.links : {};
  }

  function extractTitle(mdContent) {
    const match = mdContent.match(/^#\s+(.+)$/m);
    return match ? match[1].trim() : '';
  }

  function buildPage(mdContent, dateStr, updatedStr, mastodonUrl, linkSummaries) {
    const { content, sidenotesHtml } = processFootnotes(mdContent);

    const headings = [];
    let nextDropcap = false;
    const renderer = new marked.Renderer();

    renderer.html = function(html) {
      if (html.includes('use-dropcap')) {
        nextDropcap = true;
        return '';
      }
      if (html.includes('info-block')) {
        return html.replace(/(<div[^>]*class="info-block"[^>]*>)/, '$1' + INFO_CORNER_SVG);
      }
      if (html.includes('summary-block')) {
        return html.replace(/(<div[^>]*class="summary-block"[^>]*>)/, '$1' + SUMMARY_FRAME_SVG);
      }
      if (html.includes('conclusion-block')) {
        return html.replace(/(<div[^>]*class="conclusion-block"[^>]*>)/, '$1' + CONCLUSION_FRAME_SVG);
      }
      return html;
    };

    renderer.paragraph = function(text) {
      if (text.trim() === '&ast;' || text.trim() === '*') {
        return ASTERISM_HTML;
      }
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
      headings.push({ id, text, level });
      return `<section id="${id}" data-magellan-target="${id}"><h${level}>${text}</h${level}></section>\n`;
    };

    renderer.hr = function() { return DIVIDER_HTML; };

    renderer.link = function(href, title, text) {
      const external = /^https?:\/\//.test(href);
      const target = external ? ' target="_blank" rel="noopener noreferrer"' : '';
      const raw = (linkSummaries[href] || title || '').trim();
      if (raw) {
        const html = marked(raw.replace(/\n/g, '  \n')).trim().replace(/^<p>/, '').replace(/<\/p>$/, '');
        const attrVal = html
          .replace(/&/g, '&amp;')
          .replace(/"/g, '&quot;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;');
        return `<a href="${href}"${target} data-summary="${attrVal}" class="has-popover">${text}</a>`;
      }
      return `<a href="${href}"${target}>${text}</a>`;
    };

    const rawHtml = marked(content, { renderer }).replace(/\{\{/g, '\\{{');
    const dateLine = [
      dateStr,
      updatedStr ? `<span class="blog-updated">&#x27F6; ${updatedStr} (updated)</span>` : ''
    ].filter(Boolean).join(' ');
    const html = dateLine
      ? rawHtml.replace('</section>', `</section>\n<p class="blog-date">${dateLine}</p>`)
      : rawHtml;

    const navItems = headings.map(h => {
      const indent = h.level === 3 ? '0.5rem' : h.level >= 4 ? '1.0rem' : '0';
      const size = h.level === 3 ? '0.9em' : h.level >= 4 ? '0.8em' : '1em';
      return `<li><a href="#${h.id}" style="color:#111111;font-size:${size};padding-left:${indent}">${h.text}</a></li>`;
    }).join('\n');

    const pageTitle = extractTitle(mdContent);
    const frontMatter = pageTitle ? `---\ntitle: "${pageTitle}"\nsitetitle: mp\n---\n` : '';

    return frontMatter +
      '{{> header}}\n' +
      '{{> blog_entry_header}}\n' +
      '<div class="cell medium-2 large-2 left">\n' +
      '<nav class="sticky-container" data-sticky-container>\n' +
      '<div class="sticky" data-sticky data-anchor="blog-content" data-sticky-on="medium" data-margin-top="5">\n' +
      '<div class="progress-nav">\n' +
      '<div class="progress-rail" id="progress-rail">\n' +
      '<div class="progress-track"></div>\n' +
      PROGRESS_DIAMOND_SVG + '\n' +
      '</div>\n' +
      '<ul class="vertical menu" data-magellan>\n' +
      navItems + '\n' +
      '</ul>\n</div>\n</div>\n</nav>\n</div>\n' +
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
        const linkSummaries = loadLinkSummaries(file.path);
        file.contents = Buffer.from(buildPage(file.contents.toString(enc), dateStr, updatedStr, mastodonUrl, linkSummaries));
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
