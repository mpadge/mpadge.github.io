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

// Stretched wire-frame for .conclusion-block: a thin border rect plus bold
// corner L-brackets. Uses preserveAspectRatio="none" so it fills the element
// regardless of size; vector-effect="non-scaling-stroke" keeps stroke widths
// in screen pixels rather than scaling with the viewBox.
export const CONCLUSION_FRAME_SVG =
  `<svg class="conclusion-frame" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">` +
  `<g fill="none" stroke="currentColor" vector-effect="non-scaling-stroke">` +
  `<rect x="0" y="0" width="100" height="100" stroke-width="0.7" opacity="0.5"/>` +
  `<polyline points="0,13 0,0 13,0"     stroke-width="1.8" stroke-linecap="square"/>` +
  `<polyline points="87,0 100,0 100,13"  stroke-width="1.8" stroke-linecap="square"/>` +
  `<polyline points="100,87 100,100 87,100" stroke-width="1.8" stroke-linecap="square"/>` +
  `<polyline points="13,100 0,100 0,87"  stroke-width="1.8" stroke-linecap="square"/>` +
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
