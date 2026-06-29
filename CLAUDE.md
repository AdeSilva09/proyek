# CLAUDE.md — SIM-UMKM

Dokumen ini berisi konteks lengkap proyek **SIM-UMKM** untuk dipakai oleh AI assistant (Claude Code) maupun pengembang baru. Bacalah file ini lebih dulu sebelum melakukan perubahan apa pun.

---

## 1. Project Overview

**Nama:** SIM-UMKM — Sistem Informasi UMKM
**Pemilik domain:** DKUKMPP (Dinas Koperasi, Usaha Kecil, Menengah, Perindustrian & Perdagangan) Kota Cirebon.
**Tujuan:** Platform terintegrasi untuk memonitor, membina, dan mengevaluasi perkembangan UMKM binaan — mulai dari registrasi, manajemen modal, transaksi, pengeluaran, sampai pelaporan keuntungan dan pertumbuhan.

**Status saat ini:** **Prototipe UI / mockup interaktif** berbasis HTML statis. **Tidak ada backend, tidak ada database persisten** — semua data adalah hardcoded dummy. State sesi (login) disimpan di `localStorage`.

**Asumsi:** Prototipe ini ditujukan sebagai bahan presentasi / clickthrough demo, dan kelak akan dihubungkan ke backend (misal Laravel atau Node) dengan API REST.

---

## 2. Tech Stack

| Lapisan | Teknologi |
|---|---|
| Markup | HTML5 (vanilla, satu file per halaman) |
| Styling | CSS3 vanilla, satu file global `style.css` (~1.250+ baris, dengan CSS variables) |
| Font | Inter via Google Fonts |
| Scripting | JavaScript vanilla ES6+ (tanpa framework, tanpa bundler) |
| Chart | Chart.js 4.4.0 via CDN jsdelivr |
| Ikon | Custom inline SVG registry di `icons.js` (50+ ikon outline, render via `[data-ic="nama"]`) |
| State | `localStorage` (key `simumkmSession`, `umkmSidebarCollapsed`) |
| Build | Tidak ada bundler. Tidak ada npm. File HTML/CSS/JS disajikan apa adanya. |
| Tooling | Skrip PowerShell `split.ps1` (utility historis, tidak dipakai runtime) |

**Tidak ada:** Laravel, React, Vue, Tailwind, Sass, TypeScript, database, server, package.json, atau dependency manager.

---

## 3. Architecture

Pola arsitekturnya adalah **multi-page application (MPA) statis** dengan **shared chrome injection**:

1. Setiap halaman adalah file HTML mandiri.
2. Setiap halaman me-link `../style.css` lalu memuat 2 skrip:
   ```html
   <script src="../icons.js"></script>
   <script src="../sidebar.js"></script>
   ```
3. `sidebar.js` melakukan **runtime DOM wrapping**: membungkus seluruh `<body>` ke dalam shell `.app > .main`, kemudian menyisipkan **sidebar, topbar, dan footer** di sekitar konten asli. Konsekuensinya: **halaman tidak perlu menulis sidebar/topbar sendiri**, cukup tulis konten body saja.
4. `sidebar.js` juga **menjadi auth gate**: di awal eksekusi ia cek `localStorage.simumkmSession`. Jika tidak ada/role salah, redirect ke `login.html`. Halaman `login.html`/`logout.html` di-skip.
5. `icons.js` mengganti semua elemen `[data-ic="nama"]` dengan inline SVG. Dipanggil otomatis oleh `sidebar.js` via `window.ICRender(document.body)`.
6. `auth.js` (file mandiri, dipakai di halaman login/logout) menyediakan API `SIMAuth.login()`, `logout()`, `getSession()`, `guard()`.

**Konsekuensi penting bagi AI:**
- Jangan tulis sidebar/topbar di halaman baru — biarkan `sidebar.js` mengurusnya.
- Halaman cukup memuat 2 skrip standar + opsional Chart.js bila perlu chart.
- Set `<body data-title="...">` agar topbar menampilkan judul halaman.
- Konten halaman cukup berupa `.page-title`, `.page-sub`, `.card`, `.toolbar`, `.stat-grid`, dll. Lihat halaman existing untuk pola.

---

## 4. Folder Structure

```
/                                        (workspace root)
├── CLAUDE.md                            ← dokumen ini
├── index.html                           ← landing page publik (pilih Admin / UMKM)
├── style.css                            ← satu-satunya stylesheet (global)
├── sidebar.js                           ← shell injector + auth gate + nav
├── icons.js                             ← SVG icon registry
├── auth.js                              ← API session helper (login/logout/getSession)
├── split.ps1                            ← skrip historis (tidak runtime)
├── dkukmpp/                             ← panel administrator DKUKMPP
│   ├── login.html, logout.html, dashboard.html
│   ├── verifikasi-pendaftaran.html      ← kelola registrasi UMKM (approve/reject)
│   ├── manajemen-umkm.html              ← daftar UMKM binaan + Lihat detail
│   ├── detail-umkm.html                 ← profil & semua data 1 UMKM (tabs)
│   ├── kelola-produk-bahan-baku.html    ← gabungan produk + bahan baku (tabs)
│   ├── kelola-pemasukan-pengeluaran.html← gabungan transaksi penjualan + pengeluaran (tabs)
│   ├── monitoring-modal.html            ← kelola modal UMKM
│   ├── monitoring-keuntungan.html       ← kelola keuntungan UMKM
│   ├── laporan-umkm.html                ← cetak laporan (tab: keuntungan / pertumbuhan / per kategori)
│   ├── monitoring-*.html                ← beberapa kini redirect ke versi gabungan
│   ├── pelatihan.html, peta-sebaran.html, forecasting.html, umkm-bermasalah.html
│   ├── master-kategori.html, manajemen-hak-akses.html, manajemen-notifikasi.html
│   ├── audit-log.html, backup-restore.html, export.html, filter-laporan.html
│   ├── fitur-sistem-umkm.html           ← dokumentasi daftar fitur (internal)
│   ├── mockup-umkm.html                 ← preview semua mockup mobile dalam 1 page (internal)
│   ├── monitoring-statistik.html        ← dashboard agregat (tabs)
│   └── laporan-kategori.html, laporan-kinerja.html, laporan-pertumbuhan.html (sebagian redirect)
└── umkm/                                ← panel pelaku UMKM
    ├── login.html, logout.html, dashboard.html
    ├── profil.html, profil-edit.html
    ├── modal.html, modal-tambah.html, modal-edit.html
    ├── produk.html
    ├── bahan-baku.html
    ├── kasir.html, riwayat-penjualan.html, transaksi-detail.html, transaksi-tambah.html, transaksi-edit.html
    ├── riwayat-pengeluaran.html
    ├── kalkulator-keuntungan.html
    ├── laporan-keuangan.html, export.html
    ├── notifikasi.html, rekomendasi.html, insight.html
    └── statistik-detail.html
```

**Konvensi penamaan file:**
- Semua lowercase, kata dipisah `-`.
- Awalan `kelola-*` untuk halaman gabungan baru (admin).
- Awalan `monitoring-*` adalah peninggalan lama — beberapa sudah dijadikan redirect 0-detik ke halaman `kelola-*` gabungan; **jangan buat halaman baru dengan prefix `monitoring-`**.
- Detail page diakses dengan `?id=...` (query string) — selalu parameterized.
- Modal page (tambah/edit) sering sudah inline `.modal-backdrop` di list page; halaman `*-tambah.html`/`*-edit.html` adalah full-page form untuk versi mobile.

---

## 5. User Roles

Sistem mengenal **2 role** (dummy auth, password disimpan plaintext di `auth.js` karena ini mockup):

| Role | Email demo | Password demo | Akses |
|---|---|---|---|
| `admin` | `admin@umkm.go.id` | `admin123` | Seluruh halaman di `dkukmpp/` |
| `umkm` | `busari@umkm.go.id` | `umkm123` | Seluruh halaman di `umkm/` |

**Aturan akses:**
- `sidebar.js` melakukan guard otomatis. Halaman di `dkukmpp/` menuntut role `admin`, halaman di `umkm/` menuntut role `umkm`. Jika tidak login / role salah → redirect ke `login.html` di folder yang sama.
- Halaman `login.html` dan `logout.html` di-bypass dari guard.
- Login dilakukan via `SIMAuth.login(email, pw)` yang mengecek credential di whitelist `CREDS` di `auth.js`. Jika cocok → simpan `{ email, role, name, initial, ts }` ke `localStorage.simumkmSession`.
- Logout via `SIMAuth.logout()` yang menghapus key tersebut.
- Topbar (di-render `sidebar.js`) menampilkan nama & avatar dari session, dengan dropdown logout.

**Asumsi:** Saat backend nanti, role akan diperluas (misal: super-admin DKUKMPP vs. operator), dan password akan hash di server. Saat ini cukup 2 role dummy.

---

## 6. Features

### Panel DKUKMPP (Admin)
Sidebar items:
1. **Dashboard** — ringkasan KPI agregat, alur proses, pendaftaran terbaru, chart pertumbuhan & distribusi kategori.
2. **Kelola Data Registrasi** (`verifikasi-pendaftaran.html`) — daftar pendaftaran masuk, tombol Setujui/Tolak dengan modal konfirmasi.
3. **Kelola Data UMKM** (`manajemen-umkm.html`) — CRUD daftar UMKM binaan, tombol Lihat → `detail-umkm.html?id=UMK-xxx`.
4. **Kelola Produk & Bahan Baku** (`kelola-produk-bahan-baku.html`) — 2 tab: Produk dan Bahan Baku, masing-masing dengan filter + search.
5. **Kelola Modal UMKM** (`monitoring-modal.html`) — sebaran sumber modal, perkembangan, detail per UMKM.
6. **Kelola Pemasukan & Pengeluaran** (`kelola-pemasukan-pengeluaran.html`) — 2 tab: Pemasukan (transaksi penjualan) dan Pengeluaran, dengan filter UMKM/kategori/tanggal/metode.
7. **Kelola Keuntungan UMKM** (`monitoring-keuntungan.html`).
8. **Kelola Laporan UMKM** (`laporan-umkm.html`) — 3 tab: Laporan Keuntungan, Laporan Pertumbuhan, Laporan Per Kategori. Mendukung filter periode + tombol Cetak PDF / Export Excel (mock).
9. **Logout**.

Halaman lain (di luar sidebar saat ini, dapat diakses via URL langsung): `pelatihan.html`, `peta-sebaran.html`, `forecasting.html`, `umkm-bermasalah.html`, `master-kategori.html`, `manajemen-hak-akses.html`, `manajemen-notifikasi.html`, `audit-log.html`, `backup-restore.html`.

### Panel UMKM (Pelaku Usaha)
Sidebar items:
1. **Dashboard** — greeting, sisa dana, KPI modal/pengeluaran/penjualan/keuntungan, chart 6 bulan, quick actions.
2. **Kelola Data UMKM** (`profil.html`, edit di `profil-edit.html`).
3. **Kelola Modal** (`modal.html`, tambah/edit di `modal-tambah.html`/`modal-edit.html`).
4. **Kelola Data Produk** (`produk.html`) — CRUD inline modal.
5. **Kelola Bahan Baku** (`bahan-baku.html`).
6. **Kelola Penjualan** (group):
   - Kasir Penjualan (`kasir.html`)
   - Riwayat Penjualan (`riwayat-penjualan.html`) → detail di `transaksi-detail.html?id=...`, edit di `transaksi-edit.html`.
7. **Kelola Pengeluaran** (`riwayat-pengeluaran.html`, tambah di `transaksi-tambah.html`).
8. **Kelola Keuntungan** (`kalkulator-keuntungan.html`).
9. **Kelola Laporan** (`laporan-keuangan.html`, export di `export.html`).
10. Pengaturan: **Notifikasi Sistem**, **Rekomendasi**, **Logout**.

Halaman tambahan: `insight.html`, `statistik-detail.html`.

---

## 7. Database Rules

**Tidak ada database.** Semua data adalah dummy hardcoded di HTML/JS. Tidak ada schema, migration, ORM, atau API call.

**Skema entitas implisit** (tercermin dari UI, untuk referensi saat backend nanti):

| Entitas | Atribut utama |
|---|---|
| `UMKM` | id (UMK-001), nama, pemilik, kategori, sub_kategori, NIB, alamat, telepon, email, jumlah_karyawan, modal_awal, status (Aktif/Tidak Aktif), tanggal_bergabung, status_verifikasi |
| `Registrasi` | nama_umkm, pemilik, kategori, sub_kategori, tanggal_daftar, status (Menunggu/Disetujui/Ditolak), catatan |
| `Modal` | umkm_id, tanggal, nama, sumber (Modal Sendiri/Pinjaman/Investor/Hibah), sub_kategori, nominal |
| `Produk` | kode (P-xxx), umkm_id, nama, kategori, sub_kategori, harga_modal, harga_jual, margin (derived), stok, stok_minimum |
| `Bahan Baku` | kode (BB-xxx), umkm_id, nama, kategori, satuan, harga, stok, stok_minimum, status (Aman/Menipis/Habis) |
| `Transaksi Penjualan` | tanggal, umkm_id, produk, kategori, qty, metode (Tunai/Transfer/QRIS), total |
| `Pengeluaran` | tanggal, umkm_id, kategori (Bahan Baku/Gaji Karyawan/Operasional/Sewa Tempat/Marketing), sub_kategori, deskripsi, nominal |
| `Laporan` | umkm_id, periode (Bulanan/Kuartalan/Tahunan), penjualan, pengeluaran, keuntungan |
| `Pelatihan` | judul, tanggal, lokasi, peserta_umkm[] |
| `Notifikasi` | tanggal, kategori (Modal/Transaksi/Pengeluaran/Produk/Bahan Baku/Laporan/Pelatihan), tipe (success/warning/danger/info), judul, deskripsi |

**Aturan derived:**
- `margin = (harga_jual - harga_modal) / harga_jual * 100%`
- `keuntungan = penjualan - pengeluaran`
- Status stok: `<= 0 → Habis`, `<= stok_minimum → Menipis`, else `Aman`.
- Status UMKM otomatis aktif setelah registrasi disetujui admin.

---

## 8. Coding Standards

### HTML
- Selalu sertakan `<meta name="viewport" content="width=device-width, initial-scale=1">`.
- `<body data-title="Judul Halaman">` — dipakai topbar.
- Bahasa konten **Indonesia**.
- Tidak ada DOCTYPE strict atau modern HTML attributes baru — cukup HTML5 standar.
- Inline `style="..."` boleh untuk tweak kecil (warna teks, lebar input). Untuk pola besar, pakai class di `style.css`.

### CSS
- Single file `style.css`. Semua palet via CSS custom properties di `:root` (`--primary`, `--success`, `--danger`, `--gray-*`, `--radius`, `--shadow*`, dst).
- Breakpoint responsif: **1100px**, **900px**, **600px**, **480px**.
- Sidebar jadi drawer overlay di < 900px.
- Tabel `.data` di `.table-wrap` otomatis menjadi **card layout vertikal** di < 600px (gunakan `data-label` di setiap `<td>` agar label muncul).
- Class naming: **kebab-case**, deskriptif, prefix `.m-*` untuk komponen warisan mobile lama (dipertahankan untuk kompatibilitas).
- Jangan menambah framework CSS baru.

### JavaScript
- **Vanilla ES6+**. IIFE untuk shared scripts agar tidak mencemari `window` (lihat `sidebar.js`, `icons.js`, `auth.js`).
- Hindari dependency baru. Chart.js sudah cukup untuk grafik.
- Event listener didelegasikan ke parent bila banyak elemen sejenis.
- Filter/search pattern: ambil nilai semua input → loop `<tr>` → set `tr.style.display`.
- Modal pattern: `.modal-backdrop#xxx` toggling class `.active`.
- **Tidak ada `alert()` untuk error/sukses real** kecuali sebagai mock (export PDF/Excel, dll). Untuk konfirmasi, pakai pola `.modal-backdrop`.

### Penamaan
- File: kebab-case (`kelola-pemasukan-pengeluaran.html`).
- ID/class JS hook: camelCase (`pilihUmkm`, `filterKat`).
- Variabel data dummy: hardcoded di table HTML — bila perlu diolah JS, baca dari `<td>` atau pakai `data-*` attribute (lihat `data-date` di `kelola-pemasukan-pengeluaran.html`).

---

## 9. UI/UX Guidelines

### Palet warna
- **Primary navy**: `#0D1B8E` — branding utama, sidebar, primary button.
- **Primary dark**: `#050D5C` — header gradient atas.
- **Primary light**: `#2C3BD1` — hover, accent.
- **Success** (hijau): `#22C55E` — keuntungan, status aman, panel UMKM accent.
- **Warning** (oranye): `#F59E0B` — stok menipis, perlu perhatian.
- **Danger** (merah): `#EF4444` — habis, ditolak, hapus.
- **Purple**: `#6366F1` — KPI sekunder.
- **Gray scale**: `--gray-50` s/d `--gray-900`.

### Komponen reusable (sudah tersedia di `style.css`)
- `.card`, `.card-header`, `.card-title` — container utama.
- `.stat-grid` + `.stat[.green|.orange|.red|.purple]` — KPI card.
- `.btn[.secondary|.success|.danger|.warning|.outline|.ghost][.sm|.lg|.block]`.
- `.toolbar` + `.search` + `.spacer` — filter bar.
- `.table-wrap > table.data` — tabel responsive.
- `.badge[.success|.warning|.danger|.info]`, `.chip`.
- `.tabs > .tab.active` (underline) atau `.pill-tabs > .tab.active` (pill).
- `.alert[.success|.warning|.danger]`.
- `.modal-backdrop > .modal` — toggle dengan class `.active`.
- `.form-grid.cols-2|.cols-3 > .form-group > label + .form-control`.
- `.qa-grid > .qa[.green|.warn|.red|.purple]` — quick action grid.

### Pola halaman list
```
<div class="page-title">Judul</div>
<div class="page-sub">Sub deskripsi.</div>

<div class="stat-grid"> ... 4 KPI ... </div>

<div class="card">
  <div class="card-header"><div class="card-title">...</div> <button class="btn sm">+ Tambah</button></div>
  <div class="toolbar">
    <div class="search"><input placeholder="Cari..."></div>
    <select class="form-control" style="width:160px"> ... </select>
    <div class="spacer"></div>
  </div>
  <div class="table-wrap"><table class="data"> ... </table></div>
</div>
```

### Bahasa & tone
- Konten dalam **Bahasa Indonesia**.
- Tombol pakai kata kerja: "Setujui", "Tolak", "Lihat", "Hapus", "Cetak PDF", "Export Excel".
- Label form bersifat formal namun ringkas.
- Tidak pakai emoji di UI kecuali sangat spesifik (🥇🥈🥉 untuk peringkat).

### Aksesibilitas
- Topbar punya `aria-label` di hamburger.
- Modal ditutup oleh klik backdrop & tombol Batal.
- Sidebar drawer ditutup oleh Escape & klik backdrop.
- Kontras warna mengikuti palet standar.

---

## 10. Business Rules

1. **Registrasi UMKM**: pendaftaran masuk dengan status `Menunggu`. Admin DKUKMPP memverifikasi via modal Setujui/Tolak. Setelah disetujui, UMKM otomatis terdaftar dengan status `Aktif`.
2. **UMKM Aktif vs. Tidak Aktif**: status dapat diubah admin via dropdown di `manajemen-umkm.html`. UMKM tidak aktif tidak ikut dihitung di KPI agregat (asumsi — implementasi mock).
3. **UMKM Bermasalah** (`umkm-bermasalah.html`): UMKM yang mengalami penurunan modal, penjualan rendah, atau lama tidak aktif. Perlu intervensi pembinaan/program pelatihan.
4. **Akses data finansial**: admin DKUKMPP **view-only** atas semua data UMKM (modal, transaksi, pengeluaran, laporan). UMKM **read-write** untuk data dirinya sendiri.
5. **Stok**:
   - `stok <= 0` → status `Habis` (badge danger).
   - `stok <= stok_minimum` → status `Menipis` (badge warning).
   - selain itu → `Aman` (badge success).
6. **Margin produk** dihitung otomatis dari `(harga_jual - harga_modal) / harga_jual * 100%`.
7. **Modal**: tiap input modal punya sumber (Modal Sendiri/Pinjaman/Investor/Hibah) + sub-kategori (Tabungan Pribadi, KUR, Koperasi, Hibah DKUKMPP, dll). Status modal dinilai dari pertumbuhannya (Sangat Baik / Baik / Stabil / Perlu Perhatian / Menurun).
8. **Laporan keuntungan**: UMKM dengan margin > 25% → "Sangat Baik", 15–25% → "Baik", <15% → "Rendah", negatif → "Rugi".
9. **Laporan pertumbuhan**: penjualan dibandingkan periode awal vs sekarang → > 25% "Tumbuh Pesat", 10–25% "Stabil", < 0% "Menurun" / "Perlu Pembinaan".
10. **Notifikasi UMKM**: dipicu otomatis (mock) untuk stok menipis, pengeluaran besar, modal masuk, target tercapai, undangan pelatihan, laporan siap unduh.
11. **Pelatihan & Pembinaan**: program internal DKUKMPP, UMKM diundang berdasarkan kebutuhan (terutama yang bermasalah). *Saat ini halaman `pelatihan.html` ada tapi belum terintegrasi penuh ke alur — TODO.*

---

## 11. Development Workflow

### Menjalankan
Tidak perlu build. Cukup salah satu:
- Buka `index.html` langsung di browser, atau
- Jalankan static server di root (mis. `python -m http.server` atau Live Server VS Code).
- Untuk deployment: cocok dipasang di **GitHub Pages**, Netlify, Vercel, atau hosting statis manapun (lihat komentar di `index.html` & commit history).

### Login demo
- Admin: `admin@umkm.go.id` / `admin123`
- UMKM: `busari@umkm.go.id` / `umkm123`
- Credential tercetak juga di kartu login sebagai bantuan demo.

### Menambah halaman baru
1. Buat `nama-halaman.html` di folder yang sesuai (`dkukmpp/` atau `umkm/`).
2. Boilerplate minimum:
   ```html
   <!DOCTYPE html>
   <html lang="id">
   <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1">
     <title>Judul - SIM-UMKM</title>
     <link rel="stylesheet" href="../style.css">
   </head>
   <body data-title="Judul Halaman">
     <div class="page-title">Judul</div>
     <div class="page-sub">Deskripsi singkat.</div>
     <!-- konten -->
     <script src="../icons.js"></script>
     <script src="../sidebar.js"></script>
   </body>
   </html>
   ```
3. Bila perlu masuk navigasi, tambahkan entri di `sidebar.js` (`navAdmin` atau `navUMKM`).
4. Bila halaman butuh chart: tambah `<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>` sebelum `sidebar.js`.

### Menambah ikon baru
Tambahkan path SVG di `icons.js` pada object `I`. Gunakan via `<span data-ic="nama-baru"></span>`.

### Git
Branch utama: `main`. Commit message biasanya berbahasa Inggris ringkas (lihat git log: "Add landing page index.html...", "Restructure admin DKUKMPP per use case...").

---

## 12. Important Notes for AI Assistants

1. **Ini prototipe UI, BUKAN aplikasi production.** Tidak ada backend, tidak ada database, tidak ada API call ke server. Jangan menambah dependency, framework, atau build tool tanpa instruksi eksplisit.
2. **Hampir semua data hardcoded di HTML.** Tabel, statistik, chart — semuanya dummy. Filter/search yang functional bekerja dengan menyembunyikan `<tr>` di DOM, bukan query DB.
3. **`sidebar.js` adalah jantung shell + auth.** Setiap halaman bergantung padanya. Bila edit, pastikan tidak merusak: (a) auth guard, (b) DOM wrapping, (c) drawer mobile, (d) collapsed desktop, (e) ICRender call di akhir.
4. **Halaman `monitoring-*.html` yang sudah jadi redirect: JANGAN diisi konten baru.** Mereka hanya `meta refresh` + `location.replace` ke versi `kelola-*` gabungan. Pengubahan konten harus dilakukan di file `kelola-*.html`.
5. **Detail page wajib parameterized.** `detail-umkm.html` dan `transaksi-detail.html` harus baca `?id=` dan tampilkan data sesuai. Saat ini implementasinya **belum lengkap** — kalau diminta diperbaiki, gunakan data map JS sederhana di halaman.
6. **Tombol no-op tidak boleh ditinggalkan.** Pola pengganti: handler JS yang minimal — misal `alert('Mock: ...')`, modal konfirmasi, atau interaksi DOM (hapus baris, ubah badge).
7. **Mobile-first responsif sudah diatur di `style.css`.** Tabel besar otomatis jadi kartu di < 600px **asalkan tiap `<td>` punya `data-label="..."`**. Selalu tambahkan `data-label` saat membuat tabel baru.
8. **Bahasa konten: Indonesia.** Komentar kode boleh Inggris (lihat `sidebar.js`, `auth.js`).
9. **Jangan rename file yang sudah dilink di banyak tempat** (mis. `dashboard.html`, `login.html`, `manajemen-umkm.html`). Bila harus rename, sertakan redirect HTML lama.
10. **Saat menambah filter/search:** taruh script inline di akhir halaman, bind event `input`/`change`, set `tr.style.display = '' | 'none'`. Update counter `Menampilkan X dari Y` bila ada.
11. **Saat menambah halaman gabungan baru:** ikuti pola `kelola-produk-bahan-baku.html` dan `kelola-pemasukan-pengeluaran.html` (pill-tabs + 2 view div + hash routing).
12. **Hindari overengineering.** Pengguna meminta prototipe yang berfungsi, bukan rewrite ke React/Vue/Tailwind. Solusi paling kecil yang menyelesaikan masalah selalu lebih baik.
13. **Konsistensi label sidebar:** kata "Monitoring" sudah dihapus, ganti dengan "Kelola". Jangan reintroduce kata "Monitoring" di label baru.
14. **Asumsi (perlu dikonfirmasi pengguna bila relevan):**
    - Backend masa depan: kemungkinan Laravel (sesuai konvensi pemerintahan & dialek tugas user). Belum ada keputusan final.
    - Database: kemungkinan MySQL/PostgreSQL. Skema entitas di Section 7 adalah rancangan dari UI.
    - Hosting akhir: GitHub Pages untuk demo, lalu hosting server-side bila backend selesai.
    - Multi-tenant per UMKM: saat ini UMKM dummy tunggal (Bu Sari). Backend nanti perlu scope data per `umkm_id` user yang login.

---

*Update terakhir dokumen: 2026-06-24. Bila menambah modul besar, perbarui Section 4 (Folder Structure), Section 6 (Features), dan Section 11 (Workflow) sekaligus.*
