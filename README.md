# 📚 Yang Harus Kamu Pelajari Agar Paham Kode Ini

## 🟢 1. Bahasa Dart

Dasar yang **WAJIB** kamu kuasai:

- **Variable dan Tipe Data**  
  `int`, `String`, `List`, `Map`, `bool`

- **Fungsi**  
  `void`, `Future`, parameter, `return`

- **Null Safety**  
  `?`, `!`, `late`

- **Class dan Object**  
  OOP dasar (Object-Oriented Programming)

- **Future & Async/Await**  
  ⚠️ Penting untuk penggunaan `FutureBuilder`

- **Error Handling**  
  `try-catch`, `snapshot.hasError`

---

## 🟢 2. Flutter

Hal yang kamu gunakan di kode:

- `MaterialApp`, `Scaffold`, `AppBar`, `Text`, `ListView`, `ListTile`
- **Stateless** vs **Stateful** Widget
- `FutureBuilder` untuk menangani data async
- **Widget Lifecycle**  
  `initState`, `build`
- **UI Layouting & Widget Composition**  
  Penataan dan struktur UI
- **Optional**: Navigasi antar halaman  
  (`Navigator.push`, dll.)

---

## 🟢 3. Supabase (Flutter SDK)

Hal penting yang kamu gunakan dan perlu dipahami:

- `Supabase.initialize()`  
  Menghubungkan Flutter ke project Supabase

- `Supabase.instance.client.from().select()`  
  Mengambil data dari database

- **Konsep Table, Row, Column**  
  di database Supabase

- Membaca `List<Map<String, dynamic>>`  
  hasil dari query Supabase

### Optional lanjutan:

- **Autentikasi User**  
  (`signUp`, `signIn`)

- **Manipulasi Data**  
  (`insert()`, `update()`, `delete()`)