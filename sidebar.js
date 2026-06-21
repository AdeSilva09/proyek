// Shared sidebar + topbar + footer injector for all pages
// - Desktop: sidebar can be collapsed (icon-only) via hamburger
// - Mobile (<900px): sidebar becomes overlay drawer with backdrop
// - State persisted in localStorage
(function() {
  const isUMKM = /\/umkm\//i.test(location.pathname);

  const navAdmin = [
    { type: 'single', href: 'dashboard.html', icon: 'dashboard', label: 'Dashboard' },
    { type: 'single', href: 'verifikasi-pendaftaran.html', icon: 'shield', label: 'Kelola Data Registrasi' },
    { type: 'single', href: 'manajemen-umkm.html', icon: 'store', label: 'Kelola Data UMKM' },
    { type: 'single', href: 'monitoring-modal.html', icon: 'wallet', label: 'Kelola Manajemen Modal UMKM' },
    { type: 'single', href: 'monitoring-penjualan.html', icon: 'cart', label: 'Kelola Transaksi UMKM' },
    { type: 'single', href: 'monitoring-pengeluaran.html', icon: 'money-off', label: 'Kelola Pengeluaran UMKM' },
    { type: 'single', href: 'monitoring-keuntungan.html', icon: 'trend-up', label: 'Kelola Keuntungan UMKM' },
    { type: 'single', href: 'laporan-umkm.html', icon: 'file-text', label: 'Kelola Laporan UMKM' },
    { type: 'section', label: 'Pengaturan', items: [
      { href: 'logout.html', icon: 'logout', label: 'Logout' },
    ]},
  ];

  const navUMKM = [
    { type: 'single', href: 'dashboard.html', icon: 'dashboard', label: 'Dashboard' },
    { type: 'single', href: 'profil.html', icon: 'store', label: 'Kelola Data UMKM' },
    { type: 'single', href: 'modal.html', icon: 'wallet', label: 'Kelola Modal' },
    { type: 'single', href: 'produk.html', icon: 'package', label: 'Kelola Data Produk' },
    { type: 'single', href: 'bahan-baku.html', icon: 'box', label: 'Kelola Bahan Baku' },
    { type: 'group', key: 'penjualan', icon: 'cart', label: 'Kelola Penjualan', items: [
      { href: 'kasir.html', label: 'Kasir Penjualan' },
      { href: 'riwayat-penjualan.html', label: 'Riwayat Penjualan' },
    ]},
    { type: 'single', href: 'riwayat-pengeluaran.html', icon: 'money-off', label: 'Kelola Pengeluaran' },
    { type: 'single', href: 'kalkulator-keuntungan.html', icon: 'trend-up', label: 'Kelola Keuntungan' },
    { type: 'single', href: 'laporan-keuangan.html', icon: 'file-text', label: 'Kelola Laporan' },
    { type: 'section', label: 'Pengaturan', items: [
      { href: 'notifikasi.html', icon: 'bell', label: 'Notifikasi Sistem' },
      { href: 'rekomendasi.html', icon: 'star', label: 'Rekomendasi' },
      { href: 'logout.html', icon: 'logout', label: 'Logout' },
    ]},
  ];

  const nav = isUMKM ? navUMKM : navAdmin;
  const brandText = isUMKM ? 'SIM-UMKM<br><small style="font-weight:400;font-size:11px;opacity:0.75">Panel Pelaku UMKM</small>' : 'SIM-UMKM<br><small style="font-weight:400;font-size:11px;opacity:0.75">Admin Panel</small>';
  const userName = isUMKM ? 'Bu Sari' : 'Dirga Admin';
  const userRole = isUMKM ? 'Pelaku UMKM' : 'Administrator';
  const userInitial = isUMKM ? 'BS' : 'DA';

  const currentFile = (location.pathname.split('/').pop() || 'dashboard.html').toLowerCase();

  function iconHTML(name, size) {
    return window.IC ? window.IC(name, size || 18) : '';
  }

  // Build sidebar
  const sidebar = document.createElement('aside');
  sidebar.className = 'sidebar';

  let html = `
    <div class="sidebar-brand">
      <div class="logo">UB</div>
      <div class="brand-text">${brandText}</div>
    </div>
    <nav class="sidebar-nav">
  `;

  for (const node of nav) {
    if (node.type === 'single') {
      const active = node.href === currentFile ? ' active' : '';
      html += `<a href="${node.href}" class="nav-item${active}" title="${node.label}"><span class="ico">${iconHTML(node.icon)}</span><span class="lbl">${node.label}</span></a>`;
    } else if (node.type === 'group') {
      const isOpen = node.items.some(i => i.href === currentFile);
      html += `
        <div class="nav-group${isOpen ? ' open' : ''}" data-group="${node.key}">
          <button type="button" class="nav-item nav-toggle" title="${node.label}">
            <span class="ico">${iconHTML(node.icon)}</span>
            <span class="lbl">${node.label}</span>
            <span class="caret">${iconHTML('chevron-down', 14)}</span>
          </button>
          <div class="nav-sub">
            ${node.items.map(i => {
              const a = i.href === currentFile ? ' active' : '';
              return `<a href="${i.href}" class="nav-sub-item${a}">${i.label}</a>`;
            }).join('')}
          </div>
        </div>`;
    } else if (node.type === 'section') {
      html += `</nav><div class="sidebar-section">${node.label}</div><nav class="sidebar-nav">`;
      for (const i of node.items) {
        const a = i.href === currentFile ? ' active' : '';
        html += `<a href="${i.href}" class="nav-item${a}" title="${i.label}"><span class="ico">${iconHTML(i.icon)}</span><span class="lbl">${i.label}</span></a>`;
      }
    }
  }
  html += `</nav>`;
  sidebar.innerHTML = html;

  // Dropdown toggle (klik group header)
  sidebar.addEventListener('click', (e) => {
    const t = e.target.closest('.nav-toggle');
    if (!t) return;
    e.preventDefault();
    const g = t.closest('.nav-group');
    g.classList.toggle('open');
  });

  // Topbar with hamburger
  const pageTitle = document.body.dataset.title || 'Dashboard';
  const hamburgerSvg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>';
  const topbar = document.createElement('header');
  topbar.className = 'topbar';
  topbar.innerHTML = `
    <button type="button" class="hamburger" id="sidebarToggle" aria-label="Toggle sidebar">${hamburgerSvg}</button>
    <h1>${pageTitle}</h1>
    <div class="user">
      <div class="user-info text-right">
        <strong>${userName}</strong>
        <small>${userRole}</small>
      </div>
      <div class="avatar">${userInitial}</div>
    </div>
  `;

  // Footer
  const footer = document.createElement('footer');
  footer.className = 'site-footer';
  footer.innerHTML = `
    <div class="footer-inner">
      <div class="footer-brand">
        <strong>SIM-UMKM</strong>
        <small>Sistem Informasi Manajemen UMKM Binaan DKUKMPP Kota Bandung</small>
      </div>
      <div class="footer-meta">
        <span>&copy; 2026 DKUKMPP Kota Bandung</span>
        <span class="dot">&middot;</span>
        <a href="#">Bantuan</a>
        <span class="dot">&middot;</span>
        <a href="#">Kebijakan Privasi</a>
      </div>
    </div>
  `;

  // Backdrop (for mobile drawer)
  const backdrop = document.createElement('div');
  backdrop.className = 'sidebar-backdrop';

  // Wrap existing content
  const existingContent = document.body.innerHTML;
  document.body.innerHTML = '';
  const app = document.createElement('div');
  app.className = 'app';
  const main = document.createElement('main');
  main.className = 'main';
  const content = document.createElement('div');
  content.className = 'content';
  content.innerHTML = existingContent;

  main.appendChild(topbar);
  main.appendChild(content);
  main.appendChild(footer);
  app.appendChild(sidebar);
  app.appendChild(main);
  app.appendChild(backdrop);
  document.body.appendChild(app);

  // Restore saved collapsed state (desktop only)
  const SAVED_KEY = 'umkmSidebarCollapsed';
  if (localStorage.getItem(SAVED_KEY) === '1') {
    app.classList.add('sidebar-collapsed');
  }

  // Hamburger behavior:
  // - Desktop (>= 900px): toggle .sidebar-collapsed (icon-only)
  // - Mobile (< 900px): toggle .sidebar-open (overlay drawer)
  const toggleBtn = document.getElementById('sidebarToggle');
  toggleBtn.addEventListener('click', () => {
    if (window.innerWidth < 900) {
      app.classList.toggle('sidebar-open');
    } else {
      app.classList.toggle('sidebar-collapsed');
      localStorage.setItem(SAVED_KEY, app.classList.contains('sidebar-collapsed') ? '1' : '0');
    }
  });

  // Close drawer on backdrop click
  backdrop.addEventListener('click', () => {
    app.classList.remove('sidebar-open');
  });

  // Close drawer on nav-link click (mobile UX)
  sidebar.addEventListener('click', (e) => {
    if (window.innerWidth >= 900) return;
    const link = e.target.closest('a[href]');
    if (link) app.classList.remove('sidebar-open');
  });

  // ESC to close drawer
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') app.classList.remove('sidebar-open');
  });

  // Auto-close drawer when crossing breakpoint
  window.addEventListener('resize', () => {
    if (window.innerWidth >= 900) app.classList.remove('sidebar-open');
  });

  if (window.ICRender) window.ICRender(document.body);
})();
