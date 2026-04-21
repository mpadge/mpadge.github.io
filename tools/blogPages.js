import panini   from 'panini';
import through2 from 'through2';

export function blogPages(PATHS) {
  const marked = require('marked');

  function slugify(text) {
    return text.toLowerCase().replace(/[^\w\s-]/g, '').replace(/\s+/g, '-');
  }

  function processFootnotes(mdContent) {
    const definitions = {};
    const referenceOrder = [];

    // Extract [^label]: content definitions (single-line)
    const defRegex = /^\[\^([^\]]+)\]:\s*(.+)$/gm;
    let match;
    while ((match = defRegex.exec(mdContent)) !== null) {
      definitions[match[1]] = match[2].trim();
    }

    // Remove definition lines from content
    let content = mdContent.replace(/^\[\^[^\]]+\]:\s*.+\n?/gm, '');

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

  function buildPage(mdContent) {
    const { content, sidenotesHtml } = processFootnotes(mdContent);

    const headings = [];
    const renderer = new marked.Renderer();

    renderer.heading = function(text, level) {
      const id = slugify(text);
      headings.push({ id, text });
      return `<section id="${id}" data-magellan-target="${id}"><h${level}>${text}</h${level}></section>\n`;
    };

    const html = marked(content, { renderer }).replace(/\{\{/g, '\\{{');

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
      '{{> blog_entry_footer}}\n' +
      '{{> footer}}\n';
  }

  return require('gulp').src('src/pages/blog/*.md', { base: 'src/pages/' })
    .pipe(through2.obj(function(file, enc, cb) {
      if (file.isBuffer()) {
        file.contents = Buffer.from(buildPage(file.contents.toString(enc)));
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
