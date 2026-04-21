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
    var MEDIUM_BP = 640;
    var refs = document.querySelectorAll('.sidenote-ref');
    var notes = document.querySelectorAll('.sidenote');
    var hideTimer = null;

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
        var note = document.getElementById('sn-' + ref.dataset.sn);
        if (!note) return;
        popup.innerHTML = note.innerHTML;
        popup.classList.add('active');
        // Position above the ref; measure after showing off-screen
        var rect = ref.getBoundingClientRect();
        var pw = popup.offsetWidth;
        var ph = popup.offsetHeight;
        var left = rect.left + rect.width / 2 - pw / 2;
        left = Math.max(8, Math.min(left, window.innerWidth - pw - 8));
        var top = rect.top - ph - 8;
        if (top < 8) { top = rect.bottom + 8; } // flip below if too close to top
        popup.style.left = left + 'px';
        popup.style.top = top + 'px';
        activeRef = ref;
    }

    function hidePopup() {
        popup.classList.remove('active');
        activeRef = null;
    }

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

    // --- wide-screen hover wiring ---
    refs.forEach(function (ref) {
        ref.addEventListener('mouseenter', function () {
            if (window.innerWidth < MEDIUM_BP) return;
            showNote(ref.dataset.sn);
        });
        ref.addEventListener('mouseleave', function () {
            if (window.innerWidth < MEDIUM_BP) return;
            scheduleHide();
        });
    });

    notes.forEach(function (note) {
        note.addEventListener('mouseenter', function () {
            if (hideTimer) { clearTimeout(hideTimer); hideTimer = null; }
        });
        note.addEventListener('mouseleave', scheduleHide);
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
