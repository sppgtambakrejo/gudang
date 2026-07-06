-- Jalankan skrip ini di Supabase Dashboard: SQL Editor > New query > Run

create table if not exists kv_store (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

-- Aktifkan Row Level Security
alter table kv_store enable row level security;

-- PENTING (baca README bagian "Catatan Keamanan"):
-- Aplikasi ini login-nya dicek di sisi frontend (bukan Supabase Auth),
-- jadi anon key dipakai untuk baca & tulis tabel ini. Artinya siapa pun
-- yang tahu URL + anon key project bisa baca/ubah data lewat API Supabase
-- langsung (di luar aplikasi). Ini cocok untuk pemakaian internal/tim kecil
-- yang saling percaya, TAPI bukan tingkat keamanan enterprise.
create policy "allow anon read" on kv_store
  for select to anon using (true);

create policy "allow anon write" on kv_store
  for insert to anon with check (true);

create policy "allow anon update" on kv_store
  for update to anon using (true) with check (true);
