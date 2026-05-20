// Concave diamond for the reading progress indicator — same shape as the asterism diamonds.
export const PROGRESS_DIAMOND_SVG =
  `<svg class="progress-diamond" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 14 14" aria-hidden="true">` +
  `<path d="M7,1 C9,5 9,5 13,7 C9,9 9,9 7,13 C5,9 5,9 1,7 C5,5 5,5 7,1 Z" fill="currentColor" stroke="none"/>` +
  `</svg>`;

// Corner ornament for .info-block — two petals (right + down) and a curl,
// mirroring the closed petal outlines and tendril of the hr divider ends.
export const INFO_CORNER_SVG =
  `<svg class="info-corner" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 30" aria-hidden="true">` +
  `<g fill="none" stroke="currentColor" stroke-width="1.1" stroke-linecap="round" stroke-linejoin="round">` +
  `<path d="M8,8 C12,5 19,4 24,5 C28,7 27,10 23,11 C18,12 12,10 8,8 Z"/>` +
  `<path d="M8,8 C5,12 4,19 5,24 C7,28 10,27 11,23 C12,18 10,12 8,8 Z"/>` +
  `<path d="M8,8 C5,5 2,3 4,5 C6,7 9,9 8,8"/>` +
  `</g></svg>`;

export const SUMMARY_FRAME_SVG =
  // ----- Top ornament: fixed 28px height, full width, straddles the top edge.
  // y=14 is the centreline. Only the x-axis stretches with the block width;
  // y coordinates map 1:1 to screen pixels.
  // Elements (left→right): taper spike · bead pair · closed scroll (outer+inner) ·
  //   centre diamond · closed scroll (inner+outer) · bead pair · taper spike.
  `<svg class="summary-ornament" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 28" preserveAspectRatio="none" aria-hidden="true">` +
  `<g stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">` +
  // left taper spike — filled lens shape, tip at left edge, widens to 6 px at x=118
  `<path fill="currentColor" stroke="none" d="M1,14 C80,13.4 108,12.2 118,11 L118,17 C108,15.8 80,14.6 1,14 Z"/>` +
  // left bead pair
  `<circle cx="124" cy="14" r="2.5" fill="none" stroke-width="1.2"/>` +
  `<circle cx="133" cy="14" r="3.5" fill="none" stroke-width="1.2"/>` +
  // left outer scroll — closed almond shape
  `<path fill="none" stroke-width="1.2" d="M138,14 C142,6 160,4 174,8 C184,11 190,13.5 191,14 C190,14.5 184,17 174,20 C160,24 142,22 138,14 Z"/>` +
  // left inner scroll — tighter nested outline
  `<path fill="none" stroke-width="0.9" d="M142,14 C146,9 162,7.5 174,11 C183,13.5 190,14 191,14 C183,14.5 174,17 162,20.5 C146,20.5 142,14 Z"/>` +
  // centre diamond + filled dot
  `<path fill="none" stroke-width="1.3" d="M200,5 L207,14 L200,23 L193,14 Z"/>` +
  `<circle cx="200" cy="14" r="2" fill="currentColor" stroke="none"/>` +
  // right inner scroll (mirror)
  `<path fill="none" stroke-width="0.9" d="M258,14 C254,9 238,7.5 226,11 C217,13.5 210,14 209,14 C217,14.5 226,17 238,20.5 C254,20.5 258,14 Z"/>` +
  // right outer scroll (mirror)
  `<path fill="none" stroke-width="1.2" d="M262,14 C258,6 240,4 226,8 C216,11 210,13.5 209,14 C210,14.5 216,17 226,20 C240,24 258,22 262,14 Z"/>` +
  // right bead pair (mirror)
  `<circle cx="267" cy="14" r="3.5" fill="none" stroke-width="1.2"/>` +
  `<circle cx="276" cy="14" r="2.5" fill="none" stroke-width="1.2"/>` +
  // right taper spike (mirror)
  `<path fill="currentColor" stroke="none" d="M399,14 C320,13.4 292,12.2 282,11 L282,17 C292,15.8 320,14.6 399,14 Z"/>` +
  `</g></svg>` +

  // ----- Bottom-left corner: diamond centre at left edge, beads, scrolls, spike trailing right.
  // ViewBox 0 0 200 20; diamond centre at (0,10) = block's bottom-left corner.
  `<svg class="summary-corner-left" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 20" preserveAspectRatio="none" aria-hidden="true">` +
  `<g stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">` +
  `<path fill="none" stroke-width="1.3" d="M0,4 L6,10 L0,16 L-6,10 Z"/>` +
  `<circle cx="0" cy="10" r="1.5" fill="currentColor" stroke="none"/>` +
  `<circle cx="13" cy="10" r="2.5" fill="none" stroke-width="1.2"/>` +
  `<circle cx="20" cy="10" r="1.8" fill="none" stroke-width="1.2"/>` +
  `<path fill="none" stroke-width="1.2" d="M24,10 C28,4 46,3 60,6 C70,8 76,9.5 77,10 C76,10.5 70,12 60,14 C46,17 28,16 24,10 Z"/>` +
  `<path fill="none" stroke-width="0.9" d="M28,10 C32,6.5 48,5.5 60,7.9 C69,9.5 76,10 77,10 C69,10.5 60,12.5 48,14.5 C33,14.5 28.5,10.5 28,10 Z"/>` +
  `<path fill="currentColor" stroke="none" d="M80,8 C130,8.7 162,9.4 199,10 C162,10.6 130,11.3 80,12 Z"/>` +
  `</g></svg>` +

  // ----- Bottom-right corner: mirror — spike from centre, scrolls, beads, diamond centre at right edge.
  `<svg class="summary-corner-right" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 20" preserveAspectRatio="none" aria-hidden="true">` +
  `<g stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">` +
  `<path fill="currentColor" stroke="none" d="M120,8 C70,8.7 38,9.4 1,10 C38,10.6 70,11.3 120,12 Z"/>` +
  `<path fill="none" stroke-width="0.9" d="M172,10 C168,6.5 152,5.5 140,7.9 C131,9.5 124,10 123,10 C131,10.5 140,12.5 152,14.5 C167,14.5 171.5,10.5 172,10 Z"/>` +
  `<path fill="none" stroke-width="1.2" d="M176,10 C172,4 154,3 140,6 C130,8 124,9.5 123,10 C124,10.5 130,12 140,14 C154,17 172,16 176,10 Z"/>` +
  `<circle cx="180" cy="10" r="1.8" fill="none" stroke-width="1.2"/>` +
  `<circle cx="187" cy="10" r="2.5" fill="none" stroke-width="1.2"/>` +
  `<path fill="none" stroke-width="1.3" d="M200,4 L206,10 L200,16 L194,10 Z"/>` +
  `<circle cx="200" cy="10" r="1.5" fill="currentColor" stroke="none"/>` +
  `</g></svg>` +

  // ----- Left side: extends upward from bottom-left corner along the left edge.
  // ViewBox 0 0 20 200; diamond centre at (10,200) = block's bottom-left corner.
  // Spike (y=0..109) stretches with block height; scroll/beads/diamond (y=109..207) fixed.
  `<svg class="summary-side-left" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 200" preserveAspectRatio="none" aria-hidden="true">` +
  `<g stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">` +
  `<path fill="currentColor" stroke="none" d="M8,109 C8.7,72 9.3,42 10,1 C10.7,42 11.3,72 12,109 Z"/>` +
  `<path fill="none" stroke-width="1.2" d="M10,117 C4,120 2,138 5,148 C7,155 9,161 10,163 C11,161 13,155 15,148 C18,138 16,120 10,117 Z"/>` +
  `<path fill="none" stroke-width="0.9" d="M10,121 C6,124 5,140 7,149 C9,155 10,163 10,163 C10,163 11,155 13,149 C15,140 14,124 10,121 Z"/>` +
  `<circle cx="10" cy="178" r="1.8" fill="none" stroke-width="1.2"/>` +
  `<circle cx="10" cy="187" r="2.5" fill="none" stroke-width="1.2"/>` +
  `<path fill="none" stroke-width="1.3" d="M10,193 L17,200 L10,207 L3,200 Z"/>` +
  `<circle cx="10" cy="200" r="1.5" fill="currentColor" stroke="none"/>` +
  `</g></svg>` +

  // ----- Right side: symmetric content (left/right identical around x=10), positioned at right edge.
  `<svg class="summary-side-right" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 200" preserveAspectRatio="none" aria-hidden="true">` +
  `<g stroke="currentColor" stroke-linecap="round" stroke-linejoin="round">` +
  `<path fill="currentColor" stroke="none" d="M8,109 C8.7,72 9.3,42 10,1 C10.7,42 11.3,72 12,109 Z"/>` +
  `<path fill="none" stroke-width="1.2" d="M10,117 C4,120 2,138 5,148 C7,155 9,161 10,163 C11,161 13,155 15,148 C18,138 16,120 10,117 Z"/>` +
  `<path fill="none" stroke-width="0.9" d="M10,121 C6,124 5,140 7,149 C9,155 10,163 10,163 C10,163 11,155 13,149 C15,140 14,124 10,121 Z"/>` +
  `<circle cx="10" cy="178" r="1.8" fill="none" stroke-width="1.2"/>` +
  `<circle cx="10" cy="187" r="2.5" fill="none" stroke-width="1.2"/>` +
  `<path fill="none" stroke-width="1.3" d="M10,193 L17,200 L10,207 L3,200 Z"/>` +
  `<circle cx="10" cy="200" r="1.5" fill="currentColor" stroke="none"/>` +
  `</g></svg>`;

export const CONCLUSION_FRAME_SVG =
  `<svg class="conclusion-frame" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">` +
  `<g fill="none" stroke="currentColor" vector-effect="non-scaling-stroke">` +
  `<rect x="0" y="0" width="100" height="100" stroke-width="0.7" opacity="0.5"/>` +
  `<polyline points="0,13 0,0 13,0"         stroke-width="1.8" stroke-linecap="square"/>` +
  `<polyline points="87,0 100,0 100,13"     stroke-width="1.8" stroke-linecap="square"/>` +
  `<polyline points="100,87 100,100 87,100" stroke-width="1.8" stroke-linecap="square"/>` +
  `<polyline points="13,100 0,100 0,87"     stroke-width="1.8" stroke-linecap="square"/>` +
  `</g></svg>`;

export const ASTERISM_HTML =
  `<div class="asterism" aria-hidden="true">` +
  `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 180 80">` +
  `<defs>` +
  `<radialGradient id="dz-fill">` +
  `<stop offset="0%" stop-color="currentColor" stop-opacity="0"/>` +
  `<stop offset="65%" stop-color="currentColor" stop-opacity="0.1"/>` +
  `<stop offset="100%" stop-color="currentColor" stop-opacity="0.32"/>` +
  `</radialGradient>` +
  `</defs>` +
  `<g stroke="currentColor" stroke-width="1.3" stroke-linejoin="round">` +
  `<path fill="url(#dz-fill)" d="M90,5 C94,14 94,14 103,18 C94,22 94,22 90,31 C86,22 86,22 77,18 C86,14 86,14 90,5 Z"/>` +
  `<circle cx="90" cy="18" r="2" fill="currentColor" stroke="none"/>` +
  `<path fill="url(#dz-fill)" d="M52,47 C56,56 56,56 65,60 C56,64 56,64 52,73 C48,64 48,64 39,60 C48,56 48,56 52,47 Z"/>` +
  `<circle cx="52" cy="60" r="2" fill="currentColor" stroke="none"/>` +
  `<path fill="url(#dz-fill)" d="M128,47 C132,56 132,56 141,60 C132,64 132,64 128,73 C124,64 124,64 115,60 C124,56 124,56 128,47 Z"/>` +
  `<circle cx="128" cy="60" r="2" fill="currentColor" stroke="none"/>` +
  `</g></svg></div>\n`;

export const DIVIDER_HTML =
  `<div class="blog-divider" aria-hidden="true">` +
  `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 28">` +
  `<g fill="none" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round">` +
  // centre lines and diamond
  `<line x1="90" y1="14" x2="193" y2="14"/>` +
  `<line x1="207" y1="14" x2="310" y2="14"/>` +
  `<path d="M193,14 C198,12 198,12 200,7 C202,12 202,12 207,14 C202,16 202,16 200,21 C198,16 198,16 193,14 Z"/>` +
  `<circle cx="200" cy="14" r="1.5" fill="currentColor" stroke="none"/>` +
  // left petals — three closed outlines from base (70,14)
  `<path d="M70,14 C65,10 62,5 65,3 C69,1 74,6 72,11 Z"/>` +
  `<path d="M70,14 C58,11 44,7 38,7 C32,7 32,13 38,15 C44,17 58,16 70,14 Z"/>` +
  `<path d="M70,14 C58,17 44,21 38,21 C32,21 32,15 38,13 C44,11 58,12 70,14 Z"/>` +
  // left tendril — sweeps far left around all petals, spirals back with small reverse curl
  `<path d="M64,16 C48,23 26,26 12,22 C2,18 2,12 6,8 C10,4 22,2 38,5 C54,8 68,12 72,14 C76,16 82,14 84,11 C86,8 84,8 82,10 C80,12 82,14 90,14"/>` +
  // right petals — exact x-mirror (x → 400−x) of left
  `<path d="M330,14 C335,10 338,5 335,3 C331,1 326,6 328,11 Z"/>` +
  `<path d="M330,14 C342,11 356,7 362,7 C368,7 368,13 362,15 C356,17 342,16 330,14 Z"/>` +
  `<path d="M330,14 C342,17 356,21 362,21 C368,21 368,15 362,13 C356,11 342,12 330,14 Z"/>` +
  // right tendril — mirror of left
  `<path d="M336,16 C352,23 374,26 388,22 C398,18 398,12 394,8 C390,4 378,2 362,5 C346,8 332,12 328,14 C324,16 318,14 316,11 C314,8 316,8 318,10 C320,12 318,14 310,14"/>` +
  `</g></svg></div>\n`;
