// Minimal outline icon registry. Renders inline SVGs in place of [data-ic] elements.
(function () {
  const P = 'http://www.w3.org/2000/svg';
  // Each value: array of <path> "d" strings, drawn with stroke=currentColor.
  const I = {
    'dashboard':      ['M3 13h8V3H3v10zM13 21h8V11h-8v10zM3 21h8v-6H3v6zM13 3v6h8V3h-8z'],
    'store':          ['M3 9l1.5-5h15L21 9M4 9v11h16V9M4 9a3 3 0 006 0 3 3 0 006 0 3 3 0 006 0M10 20v-6h4v6'],
    'check':          ['M5 12l5 5L20 7'],
    'check-circle':   ['M9 12l2 2 4-4', 'M21 12a9 9 0 11-18 0 9 9 0 0118 0z'],
    'x':              ['M6 6l12 12M18 6L6 18'],
    'x-circle':       ['M9 9l6 6M15 9l-6 6', 'M21 12a9 9 0 11-18 0 9 9 0 0118 0z'],
    'pause':          ['M9 5v14M15 5v14'],
    'play':           ['M6 4l14 8-14 8V4z'],
    'alert':          ['M12 3L1 21h22L12 3z', 'M12 10v5M12 18v.5'],
    'users':          ['M16 21v-2a4 4 0 00-4-4H6a4 4 0 00-4 4v2', 'M9 11a4 4 0 100-8 4 4 0 000 8z', 'M22 21v-2a4 4 0 00-3-3.87', 'M16 3.13a4 4 0 010 7.75'],
    'shield':         ['M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6l8-3z'],
    'clipboard':      ['M9 3h6v3H9V3z', 'M9 3H5a1 1 0 00-1 1v16a1 1 0 001 1h14a1 1 0 001-1V4a1 1 0 00-1-1h-4', 'M9 12h6M9 16h4'],
    'calendar':       ['M3 6a2 2 0 012-2h14a2 2 0 012 2v14a2 2 0 01-2 2H5a2 2 0 01-2-2V6z', 'M16 2v4M8 2v4M3 10h18'],
    'wallet':         ['M3 7a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V7z', 'M16 13h2M3 9h18'],
    'banknote':       ['M2 7a2 2 0 012-2h16a2 2 0 012 2v10a2 2 0 01-2 2H4a2 2 0 01-2-2V7z', 'M12 15a3 3 0 100-6 3 3 0 000 6z'],
    'trend-up':       ['M3 17l6-6 4 4 8-8', 'M14 7h7v7'],
    'trend-down':     ['M3 7l6 6 4-4 8 8', 'M14 17h7v-7'],
    'trophy':         ['M8 21h8M12 17v4M7 4h10v4a5 5 0 01-10 0V4z', 'M17 4h3v3a3 3 0 01-3 3M7 4H4v3a3 3 0 003 3'],
    'mail':           ['M3 7a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V7z', 'M3 7l9 7 9-7'],
    'bar-chart':      ['M3 21V9M9 21V3M15 21v-7M21 21v-11'],
    'pie-chart':      ['M21 12a9 9 0 11-9-9v9h9z', 'M12 3v9l6.5 6.5'],
    'arrow-up':       ['M12 19V5M5 12l7-7 7 7'],
    'arrow-down':     ['M12 5v14M5 12l7 7 7-7'],
    'arrow-right':    ['M5 12h14M12 5l7 7-7 7'],
    'star':           ['M12 3l2.9 6 6.6.95-4.75 4.6 1.1 6.55L12 17.95 6.15 21.1l1.1-6.55L2.5 9.95 9.1 9 12 3z'],
    'cart':           ['M3 4h2l2.5 11h11l2-8H6', 'M9 21a1.5 1.5 0 100-3 1.5 1.5 0 000 3zM18 21a1.5 1.5 0 100-3 1.5 1.5 0 000 3z'],
    'fire':           ['M12 3s4 4 4 9a4 4 0 11-8 0c0-2 1-3 1-3s-3 1-3 5a6 6 0 1012 0c0-7-6-11-6-11z'],
    'clock':          ['M21 12a9 9 0 11-18 0 9 9 0 0118 0z', 'M12 7v5l3 2'],
    'money-off':      ['M3 3l18 18', 'M9 7h6M9 12h3M7 17h8'],
    'search':         ['M11 4a7 7 0 110 14 7 7 0 010-14z', 'M21 21l-5-5'],
    'pin':            ['M12 2l5 5-2 2 1 5-4-3-6 6v-7l5-5-2-2 3-1z'],
    'bell':           ['M6 8a6 6 0 1112 0c0 7 3 7 3 9H3c0-2 3-2 3-9z', 'M10 21a2 2 0 004 0'],
    'edit':           ['M4 20h4l11-11-4-4L4 16v4z', 'M14 6l4 4'],
    'target':         ['M12 21a9 9 0 100-18 9 9 0 000 18z', 'M12 16a4 4 0 100-8 4 4 0 000 8z', 'M12 12h.01'],
    'package':        ['M3 7l9-4 9 4-9 4-9-4z', 'M3 7v10l9 4 9-4V7M12 11v10'],
    'settings':       ['M12 15a3 3 0 100-6 3 3 0 000 6z', 'M19.4 15a1.7 1.7 0 00.3 1.8l.1.1a2 2 0 11-2.8 2.8l-.1-.1a1.7 1.7 0 00-1.8-.3 1.7 1.7 0 00-1 1.5V21a2 2 0 01-4 0v-.1a1.7 1.7 0 00-1-1.5 1.7 1.7 0 00-1.8.3l-.1.1a2 2 0 11-2.8-2.8l.1-.1a1.7 1.7 0 00.3-1.8 1.7 1.7 0 00-1.5-1H3a2 2 0 010-4h.1a1.7 1.7 0 001.5-1 1.7 1.7 0 00-.3-1.8l-.1-.1a2 2 0 112.8-2.8l.1.1a1.7 1.7 0 001.8.3H9a1.7 1.7 0 001-1.5V3a2 2 0 014 0v.1a1.7 1.7 0 001 1.5 1.7 1.7 0 001.8-.3l.1-.1a2 2 0 112.8 2.8l-.1.1a1.7 1.7 0 00-.3 1.8V9a1.7 1.7 0 001.5 1H21a2 2 0 010 4h-.1a1.7 1.7 0 00-1.5 1z'],
    'file':           ['M14 3H6a2 2 0 00-2 2v14a2 2 0 002 2h12a2 2 0 002-2V9l-6-6z', 'M14 3v6h6'],
    'file-text':      ['M14 3H6a2 2 0 00-2 2v14a2 2 0 002 2h12a2 2 0 002-2V9l-6-6z', 'M14 3v6h6M8 13h8M8 17h6'],
    'lock':           ['M5 11h14v10H5V11z', 'M8 11V7a4 4 0 018 0v4'],
    'logout':         ['M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4', 'M16 17l5-5-5-5M21 12H9'],
    'database':       ['M4 6c0-1.7 3.6-3 8-3s8 1.3 8 3-3.6 3-8 3-8-1.3-8-3z', 'M4 6v6c0 1.7 3.6 3 8 3s8-1.3 8-3V6', 'M4 12v6c0 1.7 3.6 3 8 3s8-1.3 8-3v-6'],
    'monitor':        ['M3 5a2 2 0 012-2h14a2 2 0 012 2v10a2 2 0 01-2 2H5a2 2 0 01-2-2V5z', 'M8 21h8M12 17v4'],
    'export':         ['M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4', 'M17 8l-5-5-5 5M12 3v12'],
    'save':           ['M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z', 'M17 21v-8H7v8M7 3v5h8'],
    'eye':            ['M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12z', 'M12 15a3 3 0 100-6 3 3 0 000 6z'],
    'printer':        ['M6 9V3h12v6', 'M6 18H4a2 2 0 01-2-2v-5a2 2 0 012-2h16a2 2 0 012 2v5a2 2 0 01-2 2h-2', 'M6 14h12v7H6v-7z'],
    'medal':          ['M12 15a5 5 0 100-10 5 5 0 000 10z', 'M8 14l-3 7 4-1 3 3 3-3 4 1-3-7'],
    'food':           ['M3 11h18a9 9 0 01-18 0z', 'M3 11h18M5 4l1 3M12 3v4M19 4l-1 3', 'M2 21h20'],
    'drink':          ['M6 3h12l-1.5 16a2 2 0 01-2 2h-5a2 2 0 01-2-2L6 3z', 'M6.5 9h11'],
    'briefcase':      ['M3 8a2 2 0 012-2h14a2 2 0 012 2v11a2 2 0 01-2 2H5a2 2 0 01-2-2V8z', 'M9 6V4a2 2 0 012-2h2a2 2 0 012 2v2', 'M3 13h18'],
    'globe':          ['M21 12a9 9 0 11-18 0 9 9 0 0118 0z', 'M3 12h18M12 3a14 14 0 010 18 14 14 0 010-18z'],
    'book':           ['M4 4h10a4 4 0 014 4v13a3 3 0 00-3-3H4V4z', 'M4 4v13h11M14 4v13'],
    'hand':           ['M7 11V5a2 2 0 014 0v6M11 11V4a2 2 0 014 0v7M15 11V6a2 2 0 014 0v9a6 6 0 01-12 0v-2a2 2 0 014 0'],
    'history':        ['M3 12a9 9 0 109-9 9 9 0 00-7.6 4.1', 'M3 4v5h5M12 7v5l3 2'],
    'plus':           ['M12 5v14M5 12h14'],
    'minus':          ['M5 12h14'],
    'filter':         ['M3 5h18l-7 9v6l-4-2v-4L3 5z'],
    'tag':            ['M3 12V3h9l9 9-9 9-9-9z', 'M7 7h.01'],
    'chevron-down':   ['M6 9l6 6 6-6'],
    'chevron-right':  ['M9 6l6 6-6 6'],
    'chevron-left':   ['M15 6l-6 6 6 6'],
    'home':           ['M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z', 'M9 22V12h6v10'],
    'user':           ['M12 12a4 4 0 100-8 4 4 0 000 8z', 'M4 21v-1a7 7 0 0114 0v1'],
    'image':          ['M3 3h18v18H3z', 'M3 16l5-5 4 4 3-3 6 6', 'M8.5 8.5a1.5 1.5 0 100 3 1.5 1.5 0 000-3z'],
    'plus-circle':    ['M12 21a9 9 0 100-18 9 9 0 000 18z', 'M12 8v8M8 12h8'],
    'box':            ['M21 8v13H3V8M1 3h22v5H1zM10 12h4'],
    'truck':          ['M1 3h15v13H1zM16 8h4l3 3v5h-7', 'M5.5 19a2 2 0 100-4 2 2 0 000 4zM18.5 19a2 2 0 100-4 2 2 0 000 4z'],
    'gift':           ['M20 12v9H4v-9', 'M2 7h20v5H2zM12 22V7M12 7a2.5 2.5 0 010-5 2.5 2.5 0 015 2.5V7h-5zM12 7a2.5 2.5 0 010-5 2.5 2.5 0 00-5 2.5V7h5z'],
    'building':       ['M3 21h18M5 21V5a2 2 0 012-2h10a2 2 0 012 2v16', 'M9 7h.01M9 11h.01M9 15h.01M13 7h.01M13 11h.01M13 15h.01'],
    'phone':          ['M22 16.9v3a2 2 0 01-2.2 2 19.8 19.8 0 01-8.6-3.1 19.5 19.5 0 01-6-6A19.8 19.8 0 012 4.2 2 2 0 014 2h3a2 2 0 012 1.7c.1.9.3 1.8.6 2.6a2 2 0 01-.5 2.1L7.9 9.7a16 16 0 006.4 6.4l1.3-1.3a2 2 0 012.1-.5c.8.3 1.7.5 2.6.6a2 2 0 011.7 2z'],
  };

  function svg(name, size) {
    const paths = I[name] || I['package'];
    const s = size || 18;
    let out = `<svg xmlns="${P}" width="${s}" height="${s}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">`;
    for (const d of paths) out += `<path d="${d}"/>`;
    return out + '</svg>';
  }

  window.IC = svg;

  function render(root) {
    const nodes = (root || document).querySelectorAll('[data-ic]');
    nodes.forEach(n => {
      if (n.dataset.icRendered) return;
      const name = n.dataset.ic;
      const size = n.dataset.size || (n.classList.contains('ic-lg') ? 26 : 18);
      n.innerHTML = svg(name, size);
      n.dataset.icRendered = '1';
    });
  }

  window.ICRender = render;
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => render());
  } else {
    render();
  }
})();
