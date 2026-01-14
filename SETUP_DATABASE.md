# Setup Database Supabase

## 🚨 STEP 1: Fix Users Table Dulu (PRIORITAS UTAMA)

Jika registrasi masih bermasalah, jalankan file ini untuk completely fix users table:

### Opsi A: Check Status Users Table Dulu
1. Buka file `check_users_table.sql`
2. Copy semua isinya
3. Paste ke Supabase SQL Editor
4. Klik **Run**
5. Lihat hasilnya - apakah ada error atau policy yang salah?

### Opsi B: Complete Fix Users Table (RECOMMENDED)
1. Buka file `fix_users_table_complete.sql`
2. Copy semua isinya  
3. Paste ke Supabase SQL Editor
4. Klik **Run**

File ini akan:
- ✅ Fix semua RLS policies yang bermasalah
- ✅ Pastikan struktur table users benar
- ✅ Buat function `create_user_profile` untuk bypass RLS
- ✅ Test function langsung di database

### Test Registrasi Setelah Fix
```bash
flutter run -d chrome
```

Coba daftar akun baru. Jika masih error, lihat console dan kasih tau error messagenya.

---

## STEP 2: Buat 9 Table Lainnya (Setelah Users OK)

Untuk menggunakan fitur cart dan favorites yang tersimpan di database, ikuti langkah-langkah berikut:

## ⚠️ PENTING: Jika Tabel Users Sudah Ada dan Berfungsi

Jika tabel `users` sudah ada dan registrasi berfungsi normal, **JANGAN** jalankan `erd.sql` karena akan menghapus tabel users yang sudah ada.

### Opsi A: Tabel Users Sudah Ada (RECOMMENDED)
Gunakan file `create_remaining_tables.sql` yang hanya membuat 9 tabel lainnya:

1. Buka file `create_remaining_tables.sql`
2. Copy semua isinya
3. Paste ke Supabase SQL Editor
4. Klik **Run**

### Opsi B: Setup Database dari Awal
Hanya gunakan jika belum ada tabel sama sekali:

1. Buka file `erd.sql`
2. Copy semua isinya
3. Paste ke Supabase SQL Editor
4. Klik **Run**

## 2. Insert Sample Data

Setelah tabel berhasil dibuat, jalankan file `insert_sample_data.sql`:

1. Buka file `insert_sample_data.sql`
2. Copy semua isinya
3. Paste ke Supabase SQL Editor
4. Klik **Run**

File ini sudah aman untuk dijalankan berulang kali.

## 3. Verifikasi Data

Setelah menjalankan SQL di atas, verifikasi bahwa data sudah masuk:

```sql
-- Cek semua tabel ada
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Cek categories
SELECT * FROM categories;

-- Cek products
SELECT * FROM products;

-- Cek users table masih ada
SELECT COUNT(*) as user_count FROM users;
```

## 4. Test Aplikasi

Setelah database setup selesai:

1. **Restart aplikasi Flutter**
   ```bash
   flutter run -d chrome
   ```

2. **Test registrasi** - Pastikan masih bisa daftar akun baru
3. **Login ke aplikasi**
4. **Test fitur:**
   - Klik "Add to Cart" → Data tersimpan ke `cart_items`
   - Klik tombol favorite → Data tersimpan ke `user_favorites`
   - Edit profile → Data tersimpan ke `users`

## 5. Monitoring Database

Untuk melihat data cart dan favorites:

```sql
-- Lihat data cart
SELECT 
    ci.*, 
    u.full_name, 
    p.name as product_name 
FROM cart_items ci
JOIN users u ON ci.user_id = u.id
JOIN products p ON ci.product_id = p.id;

-- Lihat data favorites
SELECT 
    uf.*, 
    u.full_name, 
    p.name as product_name 
FROM user_favorites uf
JOIN users u ON uf.user_id = u.id
JOIN products p ON uf.product_id = p.id;

-- Lihat semua users
SELECT id, full_name, email, phone_number FROM users;
```

## Troubleshooting

### ❌ Error "type already exists"
**Solusi:** File `erd.sql` sudah diperbaiki dengan `DROP IF EXISTS`. Jalankan ulang file tersebut.

### ❌ Error "table already exists"  
**Solusi:** File `erd.sql` sudah diperbaiki dengan `DROP TABLE IF EXISTS`. Jalankan ulang file tersebut.

### ❌ **Registrasi gagal setelah run erd.sql**
**Penyebab:** RLS (Row Level Security) policies terlalu ketat.

**Solusi A - Fix RLS Policies:**
```sql
-- Jalankan file fix_rls_registration.sql
-- Atau copy-paste SQL berikut:

DROP POLICY IF EXISTS "Users can view own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Allow user registration" ON users;

CREATE POLICY "Users can view own profile" ON users 
FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users 
FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Allow user registration" ON users 
FOR INSERT WITH CHECK (auth.uid() = id);
```

**Solusi B - Disable RLS Sementara (untuk testing):**
```sql
-- HANYA untuk development/testing!
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- Test registrasi, lalu enable kembali:
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
```

### ❌ Jika masih menggunakan sample data:
- Pastikan SQL sudah dijalankan dengan benar di Supabase
- Restart aplikasi Flutter: `flutter run -d chrome`
- Cek console untuk error message

### ❌ Jika error "Invalid product":
- Pastikan produk memiliki ID dari database
- Refresh halaman produk
- Cek koneksi ke Supabase

### ❌ Jika data tidak tersimpan:
- Cek RLS (Row Level Security) policies
- Pastikan user sudah login
- Cek console untuk error message

## Reset Database (Jika Diperlukan)

Jika ingin reset semua data:

```sql
-- Hapus semua data
DELETE FROM cart_items;
DELETE FROM user_favorites;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM payment_methods;
DELETE FROM addresses;
DELETE FROM products;
DELETE FROM categories;

-- Reset sequences
ALTER SEQUENCE categories_id_seq RESTART WITH 1;
ALTER SEQUENCE products_id_seq RESTART WITH 1;
```

Lalu jalankan ulang `insert_sample_data.sql`.