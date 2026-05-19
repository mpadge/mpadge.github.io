import $ from 'jquery';
import 'what-input';

// Foundation JS relies on a global variable. In ES6, all imports are hoisted
// to the top of the file so if we used `import` to import Foundation,
// it would execute earlier than we have assigned the global variable.
// This is why we have to use CommonJS require() here since it doesn't
// have the hoisting behavior.
window.jQuery = $;
require('foundation-sites');

// If you want to pick and choose which modules to include, comment out the above and uncomment
// the line below
//import './lib/foundation-explicit-pieces';


$(document).foundation();

// Dark mode toggle
(function () {
    var stored = localStorage.getItem('theme');
    var prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    if (stored === 'dark' || (!stored && prefersDark)) {
        document.documentElement.setAttribute('data-theme', 'dark');
    }

    $(document).on('click', '.theme-toggle-btn', function () {
        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        if (isDark) {
            document.documentElement.removeAttribute('data-theme');
            localStorage.setItem('theme', 'light');
        } else {
            document.documentElement.setAttribute('data-theme', 'dark');
            localStorage.setItem('theme', 'dark');
        }
    });
}());

// Sidenotes: hover/click shows note in right panel (wide) or popup above ref (narrow)
(function () {
    var MEDIUM_BP = 1100;
    var refs = document.querySelectorAll('.sidenote-ref');
    var notes = document.querySelectorAll('.sidenote');
    var hideTimer = null;
    var popupHideTimer = null;

    // --- wide-screen: right panel ---
    function showNote(num) {
        if (hideTimer) { clearTimeout(hideTimer); hideTimer = null; }
        notes.forEach(function (n) { n.classList.remove('active'); });
        var note = document.getElementById('sn-' + num);
        if (note) { note.classList.add('active'); }
    }

    function scheduleHide() {
        hideTimer = setTimeout(function () {
            if (!document.querySelector('.sidenote:hover')) {
                notes.forEach(function (n) { n.classList.remove('active'); });
            }
            hideTimer = null;
        }, 150);
    }

    // --- narrow-screen: floating popup ---
    var popup = document.createElement('div');
    popup.id = 'sidenote-popup';
    document.body.appendChild(popup);

    var activeRef = null;

    function showPopup(ref) {
        if (popupHideTimer) { clearTimeout(popupHideTimer); popupHideTimer = null; }
        var note = document.getElementById('sn-' + ref.dataset.sn);
        if (!note) return;
        popup.innerHTML = note.innerHTML;
        popup.style.top = '-9999px';
        popup.classList.add('active');
        var margin = 16;
        var vh = window.innerHeight;
        var ph = popup.offsetHeight;
        var rect = ref.getBoundingClientRect();
        popup.style.left = margin + 'px';
        var top = rect.top - 20;
        top = Math.min(top, vh - ph - margin);
        top = Math.max(margin, top);
        popup.style.top = top + 'px';
        activeRef = ref;
    }

    function hidePopup() {
        popup.classList.remove('active');
        activeRef = null;
    }

    function scheduleHidePopup() {
        popupHideTimer = setTimeout(function () { hidePopup(); popupHideTimer = null; }, 150);
    }

    function cancelHidePopup() {
        if (popupHideTimer) { clearTimeout(popupHideTimer); popupHideTimer = null; }
    }

    // Popup stays open while the user hovers over it
    popup.addEventListener('mouseenter', cancelHidePopup);
    popup.addEventListener('mouseleave', scheduleHidePopup);

    // Touch fallback: click toggles popup on devices with no hover
    document.addEventListener('click', function (e) {
        if (window.innerWidth >= MEDIUM_BP) return;
        var ref = e.target.closest('.sidenote-ref');
        if (ref) {
            e.preventDefault();
            if (activeRef === ref) { hidePopup(); } else { showPopup(ref); }
            return;
        }
        if (!popup.contains(e.target)) { hidePopup(); }
    });

    // --- hover wiring for both wide and narrow ---
    refs.forEach(function (ref) {
        ref.addEventListener('mouseenter', function () {
            if (window.innerWidth >= MEDIUM_BP) { showNote(ref.dataset.sn); }
            else { showPopup(ref); }
        });
        ref.addEventListener('mouseleave', function () {
            if (window.innerWidth >= MEDIUM_BP) { scheduleHide(); }
            else { scheduleHidePopup(); }
        });
    });

    notes.forEach(function (note) {
        note.addEventListener('mouseenter', function () {
            if (hideTimer) { clearTimeout(hideTimer); hideTimer = null; }
        });
        note.addEventListener('mouseleave', scheduleHide);
    });
}());

// Reading progress diamond
(function () {
    var rail = document.getElementById('progress-rail');
    if (!rail) return;
    var diamond = rail.querySelector('.progress-diamond');
    var content = document.getElementById('blog-content');
    if (!diamond || !content) return;

    function updateProgress() {
        // Measure live — Foundation sticky changes layout after init
        var navList = rail.parentElement && rail.parentElement.querySelector('ul');
        var railH = navList ? navList.getBoundingClientRect().height : rail.getBoundingClientRect().height;
        if (!railH) return;
        var dH = 14;
        var contentTop = content.getBoundingClientRect().top + window.scrollY;
        var contentH = content.offsetHeight;
        var totalScroll = contentTop + contentH - window.innerHeight;
        var progress = Math.min(1, Math.max(0, window.scrollY / totalScroll));
        diamond.style.top = (progress * (railH - dH)) + 'px';
    }

    window.addEventListener('scroll', updateProgress, { passive: true });
    window.addEventListener('resize', updateProgress, { passive: true });
    // Defer first measurement until Foundation has initialised
    setTimeout(updateProgress, 300);
}());

// Tag filter for blog index
(function () {
    var filterBar = document.getElementById('tag-filter');
    if (!filterBar) return;

    var entries = Array.from(document.querySelectorAll('.blog-entry'));
    if (!entries.length) return;

    var tagSet = {};
    entries.forEach(function (el) {
        (el.dataset.tags || '').split(',').forEach(function (t) {
            t = t.trim();
            if (t) tagSet[t] = true;
        });
    });
    var tags = Object.keys(tagSet).sort();
    if (!tags.length) return;

    function makeBtn(label, tag) {
        var btn = document.createElement('button');
        btn.className = 'tag-filter-btn' + (tag === null ? ' active' : '');
        btn.textContent = label;
        btn.dataset.tag = tag === null ? '' : tag;
        return btn;
    }

    filterBar.appendChild(makeBtn('all', null));
    tags.forEach(function (t) { filterBar.appendChild(makeBtn(t, t)); });

    filterBar.addEventListener('click', function (e) {
        var btn = e.target.closest('.tag-filter-btn');
        if (!btn) return;
        filterBar.querySelectorAll('.tag-filter-btn').forEach(function (b) {
            b.classList.remove('active');
        });
        btn.classList.add('active');
        var activeTag = btn.dataset.tag;
        entries.forEach(function (el) {
            if (!activeTag) {
                el.style.display = '';
            } else {
                var entryTags = (el.dataset.tags || '').split(',').map(function (t) { return t.trim(); });
                el.style.display = entryTags.indexOf(activeTag) !== -1 ? '' : 'none';
            }
        });
    });
}());

// Smart sticky nav: hide on scroll down, reveal on scroll up
(function () {
    var stickyBar = document.querySelector('[data-sticky-container] .top-bar');
    var lastScrollY = window.scrollY;
    var ticking = false;

    window.addEventListener('scroll', function () {
        if (!ticking) {
            window.requestAnimationFrame(function () {
                var currentScrollY = window.scrollY;
                if (stickyBar) {
                    if (currentScrollY > lastScrollY && stickyBar.classList.contains('is-stuck')) {
                        stickyBar.classList.add('nav-hidden');
                    } else if (currentScrollY < lastScrollY) {
                        stickyBar.classList.remove('nav-hidden');
                    }
                }
                lastScrollY = currentScrollY;
                ticking = false;
            });
            ticking = true;
        }
    });
}());
