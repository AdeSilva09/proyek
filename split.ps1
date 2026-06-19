$src = Get-Content -Raw -Path "D:\umkm\mockup-umkm.html"
$outDir = "D:\umkm\app"
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# 1) Extract shared <style>...</style> from source
$styleMatch = [regex]::Match($src, '(?s)<style>(.*?)</style>')
$css = $styleMatch.Groups[1].Value.Trim()

# Override body + add mobile-app styles (full viewport phone)
$mobileCss = @'

/* ============================================================
   MOBILE APP OVERRIDES
   Setiap file HTML = 1 layar mobile penuh.
   Di desktop ditampilkan terpusat dengan lebar HP (max 430px).
   ============================================================ */
html, body { height: 100%; }
body {
  font-family: 'Inter', system-ui, -apple-system, sans-serif;
  background: #0D1B8E;
  color: var(--text);
  padding: 0;
  margin: 0;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: stretch;
}
.app {
  width: 100%;
  max-width: 430px;
  background: var(--bg);
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  position: relative;
  box-shadow: 0 0 40px rgba(0,0,0,.25);
  overflow: hidden;
}
.status-bar {
  height: 32px;
  background: var(--navy);
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}
.app-bar {
  background: var(--navy);
  color: white;
  padding: 14px 18px 18px;
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}
.app-bar .icon-btn {
  width: 34px; height: 34px;
  display: flex; align-items: center; justify-content: center;
  border-radius: 10px;
  background: rgba(255,255,255,.14);
  color: white;
  text-decoration: none;
  cursor: pointer;
  border: none;
}
.app-bar .icon-btn svg { width: 18px; height: 18px; }
.app-bar h2 { font-size: 17px; font-weight: 600; flex: 1; }

.body {
  flex: 1;
  overflow-y: auto;
  padding: 16px 16px 100px;
  font-size: 13px;
}
.body::-webkit-scrollbar { width: 4px; }
.body::-webkit-scrollbar-thumb { background: rgba(0,0,0,.1); border-radius: 4px; }

/* Bottom nav */
.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 100%;
  max-width: 430px;
  height: 70px;
  background: var(--navy);
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 0 16px;
  z-index: 50;
}
.bottom-nav .nav-item {
  color: rgba(255,255,255,.65);
  display: flex; flex-direction: column; align-items: center; gap: 3px;
  font-size: 10px;
  font-weight: 500;
  text-decoration: none;
  flex: 1;
}
.bottom-nav .nav-item svg { width: 20px; height: 20px; }
.bottom-nav .nav-item.active { color: white; }
.bottom-nav .fab {
  width: 56px; height: 56px;
  background: white;
  border: 4px solid var(--bg);
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  margin-top: -32px;
  box-shadow: 0 6px 16px rgba(13,27,142,.4);
  color: var(--navy);
  text-decoration: none;
}
.bottom-nav .fab svg { width: 24px; height: 24px; }

/* Font scaling for mobile-real-size */
.card { padding: 14px; font-size: 13px; }
.card-navy { padding: 18px; }
.card-navy .label { font-size: 12px; }
.card-navy .value { font-size: 28px; }
.card-navy .sub { font-size: 12px; }
.stat .lbl { font-size: 10px; }
.stat .val { font-size: 20px; }
.stat .delta { font-size: 11px; }
.btn { padding: 14px 16px; font-size: 14px; }
.input { padding: 14px 16px; font-size: 14px; }
.input-label { font-size: 12px; }
.li-body .t1 { font-size: 14px; }
.li-body .t2 { font-size: 12px; }
.li-end { font-size: 13px; }
.li-ico { width: 42px; height: 42px; }
.li-ico svg { width: 18px; height: 18px; }
.sec-title h3 { font-size: 14px; }
.sec-title a { font-size: 12px; cursor: pointer; text-decoration: none; }
.chip { font-size: 11px; padding: 5px 12px; }
.tab { font-size: 13px; padding: 10px 6px; }
.search { padding: 12px 14px; }
.search input { font-size: 14px; }
.alert .t { font-size: 13px; }
.alert .s { font-size: 12px; }
.cart-thumb { width: 50px; height: 50px; font-size: 20px; }
.cart-item { padding: 12px; }
.qty button { width: 26px; height: 26px; font-size: 14px; }
.qty span { font-size: 13px; min-width: 20px; }
.chart-bars { height: 120px; }
.donut { width: 110px; height: 110px; }
.avatar { width: 84px; height: 84px; font-size: 28px; }
.qa-grid { gap: 10px; }
.qa { padding: 12px 6px; }
.qa-ico { width: 40px; height: 40px; }
.qa-label { font-size: 11px; }

/* Splash (login) full screen */
.splash {
  flex: 1;
  background: linear-gradient(160deg, var(--navy) 0%, var(--navy-light) 100%);
  color: white;
  padding: 50px 28px 30px;
  display: flex; flex-direction: column;
  border-radius: 0;
  min-height: calc(100vh - 32px);
}
.splash .logo {
  width: 80px; height: 80px;
  background: white;
  border-radius: 24px;
  display: flex; align-items: center; justify-content: center;
  color: var(--navy);
  margin: 30px auto 20px;
  box-shadow: 0 12px 30px rgba(0,0,0,.25);
}
.splash-form {
  background: white;
  border-radius: 22px;
  padding: 22px 20px;
  margin-top: 22px;
  box-shadow: 0 -10px 30px rgba(0,0,0,.15);
  color: var(--text);
}

/* Modal overlay full screen */
.modal-overlay {
  position: fixed;
  inset: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 100%;
  max-width: 430px;
  background: rgba(0,0,0,.5);
  display: flex; align-items: flex-end;
  border-radius: 0;
  overflow: hidden;
  z-index: 100;
}
.modal {
  background: white;
  width: 100%;
  border-radius: 22px 22px 0 0;
  padding: 22px 18px 90px;
  animation: slideUp .3s ease;
}
@keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }
.modal-handle {
  width: 44px; height: 5px;
  background: var(--border);
  border-radius: 3px;
  margin: 0 auto 16px;
}
.toggle { width: 42px; height: 24px; }
.toggle::after { width: 20px; height: 20px; }

/* App-bar title links (for sec-title "lihat semua") */
.body a { color: inherit; }

/* Make icon-btn links visible as buttons */
a.icon-btn { display: inline-flex; }

/* Receipt readability */
.receipt { font-size: 11px; padding: 18px; }

/* Insight card text */
.insight-card { padding: 14px; }
.insight-card div { font-size: 12px; }

/* Bottom-nav offset for screens with content scrolling */
.has-nav .body { padding-bottom: 110px; }

/* Drawer / menu (untuk halaman index) */
.menu-screen {
  background: linear-gradient(160deg, var(--navy) 0%, var(--navy-light) 100%);
  flex: 1;
  padding: 30px 22px;
  color: white;
  min-height: 100vh;
}
.menu-screen h1 {
  font-size: 22px;
  font-weight: 800;
  margin-bottom: 4px;
}
.menu-screen .sub {
  font-size: 13px;
  opacity: .85;
  margin-bottom: 20px;
}
.menu-group {
  background: rgba(255,255,255,.08);
  border-radius: 16px;
  padding: 6px;
  margin-bottom: 14px;
  backdrop-filter: blur(10px);
}
.menu-group-title {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: .5px;
  opacity: .7;
  padding: 10px 12px 6px;
}
.menu-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px;
  border-radius: 12px;
  color: white;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: background .15s;
}
.menu-item:hover { background: rgba(255,255,255,.12); }
.menu-item .mi-num {
  width: 30px; height: 30px;
  border-radius: 8px;
  background: rgba(255,255,255,.18);
  display: flex; align-items: center; justify-content: center;
  font-weight: 700;
  font-size: 12px;
  flex-shrink: 0;
}
.menu-item .mi-arrow {
  margin-left: auto;
  opacity: .5;
}
.menu-fab {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--green);
  color: white;
  padding: 12px 24px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 700;
  text-decoration: none;
  box-shadow: 0 8px 20px rgba(34,197,94,.4);
  z-index: 50;
}
'@

Set-Content -Path "$outDir\style.css" -Value ($css + $mobileCss) -Encoding utf8

# 2) Page metadata
$pages = @(
  @{n='01'; id=1;  slug='login';            title='Login Sistem';            sub='Autentikasi UMKM';            grp='Akun'},
  @{n='02'; id=2;  slug='dashboard';        title='Dashboard Keuangan';      sub='Ringkasan & grafik usaha';    grp='Beranda'},
  @{n='03'; id=3;  slug='profil';           title='Kelola Profil UMKM';      sub='Edit data usaha';             grp='Akun'},
  @{n='04'; id=4;  slug='modal';            title='Manajemen Modal';         sub='Tambah, edit, hapus, riwayat';grp='Modal & Budget'},
  @{n='05'; id=5;  slug='statistik-modal';  title='Statistik Modal';         sub='Grafik & persentase';         grp='Modal & Budget'},
  @{n='06'; id=6;  slug='budget';           title='Manajemen Budget';        sub='Buat & kelola budget';        grp='Modal & Budget'},
  @{n='07'; id=7;  slug='monitoring-budget';title='Monitoring Budget';       sub='Sisa, persentase, notifikasi';grp='Modal & Budget'},
  @{n='08'; id=8;  slug='pengeluaran';      title='Catat Pengeluaran';       sub='Form input terhubung budget'; grp='Transaksi'},
  @{n='09'; id=9;  slug='analisis-pengeluaran'; title='Analisis Pengeluaran'; sub='Tabel & grafik per kategori';grp='Transaksi'},
  @{n='10'; id=10; slug='produk';           title='Manajemen Produk';        sub='Tambah, ubah, hapus produk';  grp='Produk & Stok'},
  @{n='11'; id=11; slug='stok';             title='Manajemen Stok';          sub='Stok masuk, keluar, realtime';grp='Produk & Stok'},
  @{n='12'; id=12; slug='notif-stok';       title='Notifikasi Stok Minimum'; sub='Peringatan otomatis';         grp='Produk & Stok'},
  @{n='13'; id=13; slug='mutasi-stok';      title='Laporan Mutasi Stok';     sub='Riwayat stok masuk & keluar'; grp='Produk & Stok'},
  @{n='14'; id=14; slug='kasir';            title='Kasir';                   sub='Pilih produk untuk dijual';   grp='Penjualan'},
  @{n='15'; id=15; slug='keranjang';        title='Keranjang';               sub='Kelola produk transaksi';     grp='Penjualan'},
  @{n='16'; id=16; slug='pembayaran';       title='Pembayaran';              sub='Tunai & transfer';            grp='Penjualan'},
  @{n='17'; id=17; slug='bukti-penjualan';  title='Bukti Penjualan';         sub='Struk transaksi';             grp='Penjualan'},
  @{n='18'; id=18; slug='riwayat-penjualan';title='Riwayat Penjualan';       sub='Daftar transaksi per periode';grp='Penjualan'},
  @{n='20'; id=20; slug='monitoring-keuangan'; title='Monitoring Keuangan';  sub='KPI: modal, penjualan, profit';grp='Laporan & Analisis'},
  @{n='21'; id=21; slug='analisis-keuntungan'; title='Analisis Keuntungan';  sub='Otomatis dari penjualan';     grp='Laporan & Analisis'},
  @{n='22'; id=22; slug='visualisasi-keuntungan'; title='Tren Profit';       sub='Grafik margin & tren profit'; grp='Laporan & Analisis'},
  @{n='23'; id=23; slug='insight';          title='Insight & Rekomendasi';   sub='AI advisor untuk UMKM';       grp='Laporan & Analisis'},
  @{n='24'; id=24; slug='laporan';          title='Laporan Keuangan';        sub='Generate per periode';        grp='Laporan & Analisis'},
  @{n='25'; id=25; slug='export-pdf';       title='Export PDF';              sub='Modal opsi & download';       grp='Laporan & Analisis'},
  @{n='26'; id=26; slug='export-excel';     title='Export Excel';            sub='Pilih sheet & download';      grp='Laporan & Analisis'},
  @{n='27'; id=27; slug='notifikasi';       title='Notifikasi Sistem';       sub='Pusat notifikasi terpadu';    grp='Akun'},
  @{n='28'; id=28; slug='logout';           title='Logout';                  sub='Konfirmasi keluar aman';      grp='Akun'}
)

function PageFile($p) { return "page-$($p.n)-$($p.slug).html" }

# Bottom nav HTML (linked to dashboard/riwayat/kasir/produk/menu)
$bottomNav = @'
<nav class="bottom-nav">
  <a class="nav-item __BR__" href="page-02-dashboard.html">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
    <span>Beranda</span>
  </a>
  <a class="nav-item __RW__" href="page-18-riwayat-penjualan.html">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 7L9 18l-5-5"/></svg>
    <span>Transaksi</span>
  </a>
  <a class="fab" href="page-14-kasir.html">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 10h18M8 14h2M8 17h2"/></svg>
  </a>
  <a class="nav-item __PR__" href="page-10-produk.html">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
    <span>Produk</span>
  </a>
  <a class="nav-item __MN__" href="index.html">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>
    <span>Menu</span>
  </a>
</nav>
'@

function Get-BottomNav($activeKey) {
  $h = $bottomNav
  $keys = @('BR','RW','PR','MN')
  foreach ($k in $keys) {
    if ($k -eq $activeKey) {
      $h = $h.Replace("__${k}__", "active")
    } else {
      $h = $h.Replace("__${k}__", "")
    }
  }
  return $h
}

# Back-link target: previous logical page or dashboard fallback
function Get-BackHref($p) {
  switch ($p.n) {
    '01' { return $null }
    '02' { return 'index.html' }
    '15' { return 'page-14-kasir.html' }
    '16' { return 'page-15-keranjang.html' }
    '17' { return 'page-16-pembayaran.html' }
    default { return 'index.html' }
  }
}

# Active nav key per page (which bottom tab to highlight)
function Get-NavKey($p) {
  if ($p.n -in @('02')) { return 'BR' }
  if ($p.n -in @('18','08','09','16','17','20','24','25','26','21','22','23','27')) { return 'RW' }
  if ($p.n -in @('14','15')) { return '' }   # kasir uses FAB
  if ($p.n -in @('10','11','12','13')) { return 'PR' }
  if ($p.n -in @('03','04','05','06','07','28')) { return 'MN' }
  return ''
}

# Show bottom nav on app pages (not login, not modals 25/26, not splash success 17)
function Should-ShowNav($p) {
  return @('01') -notcontains $p.n
}

# 3) For each page, extract inner of phone-wrap's .screen
foreach ($p in $pages) {
  $pattern = "(?s)<!-- ========== $($p.id)\. .*?========== -->\s*<div class=`"phone-wrap`">\s*<div class=`"phone`"><div class=`"screen`">(.*?)</div></div>\s*<div class=`"phone-label`">"
  $m = [regex]::Match($src, $pattern)
  if (-not $m.Success) {
    Write-Host "MISS: $($p.n)"
    continue
  }
  $screen = $m.Groups[1].Value.Trim()

  # Remove the original bottom-nav inside the screen (will inject ours linked)
  $screen = [regex]::Replace($screen, '(?s)<nav class="bottom-nav">.*?</nav>', '')

  # Replace back-arrow icon-btn in app-bar with link to back href (first icon-btn that contains "polyline points=`"15 18 9 12 15 6`"")
  $back = Get-BackHref $p
  if ($back) {
    $screen = [regex]::Replace($screen, '<div class="icon-btn"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg></div>', "<a class=`"icon-btn`" href=`"$back`"><svg viewBox=`"0 0 24 24`" fill=`"none`" stroke=`"currentColor`" stroke-width=`"2`"><polyline points=`"15 18 9 12 15 6`"/></svg></a>", 1)
  }

  # Status bar tweak (use cleaner sizing handled by CSS already)
  # Wrap modal-overlay close button (X) for pages 17/25/26/28 -> link back to dashboard
  $screen = $screen.Replace('<div class="icon-btn"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></div>', '<a class="icon-btn" href="page-02-dashboard.html"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></a>')

  # Specific link wirings between flow pages
  if ($p.n -eq '14') {
    # Kasir: "Lihat Cart" button -> keranjang
    $screen = $screen.Replace('<button style="background:var(--green);color:white;border:none;padding:8px 14px;border-radius:10px;font-weight:700;font-size:11px">Lihat Cart &rarr;</button>',
      '<a href="page-15-keranjang.html" style="background:var(--green);color:white;border:none;padding:10px 18px;border-radius:10px;font-weight:700;font-size:13px;text-decoration:none">Lihat Cart &rarr;</a>')
    # in PowerShell the original used → arrow. Try other variants:
    $screen = [regex]::Replace($screen, '<button style="background:var\(--green\);color:white;border:none;padding:8px 14px;border-radius:10px;font-weight:700;font-size:11px">Lihat Cart[^<]*</button>',
      '<a href="page-15-keranjang.html" style="background:var(--green);color:white;padding:10px 18px;border-radius:10px;font-weight:700;font-size:13px;text-decoration:none">Lihat Cart &rarr;</a>')
  }
  if ($p.n -eq '15') {
    $screen = $screen.Replace('<button class="btn btn-primary" style="margin-top:8px">Lanjut ke Pembayaran</button>',
      '<a class="btn btn-primary" href="page-16-pembayaran.html" style="margin-top:8px;text-decoration:none">Lanjut ke Pembayaran</a>')
  }
  if ($p.n -eq '16') {
    $screen = $screen.Replace('<button class="btn btn-primary" style="margin-top:10px">Selesaikan Transaksi</button>',
      '<a class="btn btn-primary" href="page-17-bukti-penjualan.html" style="margin-top:10px;text-decoration:none">Selesaikan Transaksi</a>')
  }
  if ($p.n -eq '01') {
    $screen = $screen.Replace('<button class="btn btn-primary">Masuk</button>',
      '<a class="btn btn-primary" href="page-02-dashboard.html" style="text-decoration:none">Masuk</a>')
  }
  if ($p.n -eq '28') {
    $screen = $screen.Replace('<button class="btn" style="background:var(--red);color:white">Ya, Keluar</button>',
      '<a class="btn" href="page-01-login.html" style="background:var(--red);color:white;text-decoration:none">Ya, Keluar</a>')
  }

  $navHtml = ''
  $hasNavClass = ''
  if (Should-ShowNav $p) {
    $key = Get-NavKey $p
    $navHtml = Get-BottomNav $key
    $hasNavClass = ' has-nav'
  }

  $html = @"
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<meta name="theme-color" content="#0D1B8E" />
<title>$($p.title) &mdash; UMKM DKUKMPP</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="style.css">
</head>
<body>
<div class="app$hasNavClass">
$screen
$navHtml
</div>
</body>
</html>
"@
  Set-Content -Path "$outDir\$(PageFile $p)" -Value $html -Encoding utf8
  Write-Host "OK: $(PageFile $p)"
}

# 4) Build index.html as MAIN MENU (mobile drawer)
$groups = @('Beranda','Modal & Budget','Transaksi','Produk & Stok','Penjualan','Laporan & Analisis','Akun')

$menu = New-Object System.Text.StringBuilder
[void]$menu.AppendLine('<!DOCTYPE html>')
[void]$menu.AppendLine('<html lang="id">')
[void]$menu.AppendLine('<head>')
[void]$menu.AppendLine('<meta charset="UTF-8" />')
[void]$menu.AppendLine('<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />')
[void]$menu.AppendLine('<meta name="theme-color" content="#0D1B8E" />')
[void]$menu.AppendLine('<title>Menu Utama &mdash; UMKM DKUKMPP</title>')
[void]$menu.AppendLine('<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">')
[void]$menu.AppendLine('<link rel="stylesheet" href="style.css">')
[void]$menu.AppendLine('</head>')
[void]$menu.AppendLine('<body>')
[void]$menu.AppendLine('<div class="app has-nav">')
[void]$menu.AppendLine('  <div class="status-bar"><span>9:41</span><span>5G 100%</span></div>')
[void]$menu.AppendLine('  <div class="menu-screen">')
[void]$menu.AppendLine('    <h1>Menu Utama</h1>')
[void]$menu.AppendLine('    <div class="sub">UMKM DKUKMPP &mdash; semua fitur aplikasi</div>')

foreach ($g in $groups) {
  $items = $pages | Where-Object { $_.grp -eq $g }
  if (-not $items) { continue }
  [void]$menu.AppendLine('    <div class="menu-group">')
  [void]$menu.AppendLine("      <div class=`"menu-group-title`">$g</div>")
  foreach ($p in $items) {
    [void]$menu.AppendLine("      <a class=`"menu-item`" href=`"$(PageFile $p)`">")
    [void]$menu.AppendLine("        <div class=`"mi-num`">$($p.n)</div>")
    [void]$menu.AppendLine("        <div><div style=`"font-weight:600`">$($p.title)</div><div style=`"font-size:11px;opacity:.75;margin-top:2px`">$($p.sub)</div></div>")
    [void]$menu.AppendLine('        <svg class="mi-arrow" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>')
    [void]$menu.AppendLine('      </a>')
  }
  [void]$menu.AppendLine('    </div>')
}

[void]$menu.AppendLine('  </div>')
# Bottom nav (Menu tab active)
$mainNav = Get-BottomNav 'MN'
[void]$menu.AppendLine($mainNav)
[void]$menu.AppendLine('</div>')
[void]$menu.AppendLine('</body></html>')

Set-Content -Path "$outDir\index.html" -Value $menu.ToString() -Encoding utf8
Write-Host "OK: index.html (menu utama)"

Write-Host "Done. Output: $outDir"
