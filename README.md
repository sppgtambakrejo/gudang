# Gudang Persediaan SPPG

Aplikasi manajemen persediaan gudang (penerimaan/pengeluaran barang, laporan stok,
master barang, supplier, periode, user, log aktivitas). Frontend React + Vite,
data disimpan di Supabase (Postgres).

## 1. Setup Supabase

1. Buat project baru di https://supabase.com (gratis).
2. Buka **SQL Editor** > **New query**, tempel isi file `supabase/schema.sql`, lalu **Run**.
   Ini membuat tabel `kv_store` beserta izin aksesnya.
3. Buka **Project Settings > API**, catat:
   - `Project URL` → jadi `VITE_SUPABASE_URL`
   - `anon public` key → jadi `VITE_SUPABASE_ANON_KEY`

## 2. Jalankan lokal (opsional, untuk coba dulu di komputer)

```bash
npm install
cp .env.example .env
# lalu edit .env, isi VITE_SUPABASE_URL dan VITE_SUPABASE_ANON_KEY
npm run dev
```

Buka `http://localhost:5173`.

## 3. Push ke GitHub

```bash
git init
git add .
git commit -m "Initial commit: Gudang Persediaan SPPG"
git branch -M main
git remote add origin https://github.com/<username>/<nama-repo>.git
git push -u origin main
```

## 4. Aktifkan GitHub Pages (deploy otomatis)

1. Di repo GitHub: **Settings > Pages** > bagian "Build and deployment" > Source pilih
   **GitHub Actions** (bukan "Deploy from a branch").
2. Di repo GitHub: **Settings > Secrets and variables > Actions > New repository secret**,
   tambahkan 2 secret:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
3. Push ke branch `main` (atau jalankan workflow manual lewat tab **Actions**).
   Workflow `.github/workflows/deploy.yml` otomatis build lalu deploy.
4. Setelah selesai (cek tab **Actions**), situs bisa diakses di:
   `https://<username>.github.io/<nama-repo>/`

## Login default (bisa diganti lewat menu Manajemen User setelah login)

- Superadmin: `superadmin` / `super123`
- Admin: `admin1` / `admin123`
- Viewer (lihat saja): PIN `1234`

**Segera ganti password/PIN default ini setelah deploy pertama kali.**

## Catatan Keamanan (penting, baca ini)

Login di aplikasi ini dicek di sisi frontend (bukan pakai Supabase Auth),
dan semua data disimpan di satu tabel `kv_store` yang bisa dibaca/ditulis
oleh siapa saja yang memegang `anon key` (kunci publik ini memang ikut
ter-bundle di file JS hasil build — itu wajar untuk aplikasi Supabase
client-side, tapi karena tidak ada Supabase Auth, tidak ada lapisan
otorisasi tambahan di level database).

Cocok untuk: pemakaian internal tim kecil yang saling percaya.
Tidak disarankan untuk: data sensitif publik-facing tanpa pengamanan tambahan.

Kalau nanti mau ditingkatkan, opsi yang bisa dilakukan:
- Pindah ke Supabase Auth (email/password) + Row Level Security per user/role.
- Pecah tabel `kv_store` jadi tabel relasional per entitas (items, transaksi, dll)
  supaya bisa diberi policy RLS yang lebih granular.

## Struktur data

Aplikasi menyimpan tiap "kategori data" (users, transaksi masuk, transaksi keluar,
saldo per periode, master barang, supplier, periode, log aktivitas) sebagai satu
baris JSON di tabel `kv_store`, mengikuti key yang didefinisikan di `KEYS` dalam
`src/App.jsx`. Ini pendekatan paling cepat untuk migrasi dari storage lama tanpa
menulis ulang seluruh logika aplikasi.
