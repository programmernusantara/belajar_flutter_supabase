// Import package yang diperlukan
import 'package:flutter/material.dart'; // Package untuk UI Flutter
import 'package:supabase_flutter/supabase_flutter.dart'; // Package untuk koneksi Supabase

// Fungsi utama yang dijalankan pertama kali saat aplikasi dimulai
Future<void> main() async {
  // Memastikan binding Flutter sudah diinisialisasi sebelum menjalankan app
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi koneksi ke Supabase
  await Supabase.initialize(
    url: 'https://khmoryszrwvosuhubasz.supabase.co', // URL Supabase project
    anonKey: // Key anonim untuk autentikasi
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtobW9yeXN6cnd2b3N1aHViYXN6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4MDMzMjcsImV4cCI6MjA2NTM3OTMyN30.NdAzfYRY3PSLjj7EJOH0BjbXUum9ZCp29kVnbYHgscs',
  );

  // Menjalankan aplikasi Flutter dengan widget MyApp sebagai root
  runApp(MyApp());
}

// Widget utama aplikasi (StatelessWidget)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      title: "Bakid App", // Judul aplikasi
      home: Scaffold(
        // Scaffold sebagai kerangka dasar halaman
        appBar: AppBar(
          title: Text("Home"), // Judul app bar
          backgroundColor: Colors.grey[200], // Warna background app bar
          centerTitle: true, // Judul diposisikan di tengah
        ),
        body: Home(), // Widget Home sebagai body
      ),
    );
  }
}

// Widget Home (StatefulWidget karena perlu mengelola state)
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// State class untuk widget Home
class _HomeState extends State<Home> {
  // Mengambil data dari tabel 'instruments' di Supabase
  final _future = Supabase.instance.client.from('instruments').select();

  @override
  Widget build(BuildContext context) {
    // FutureBuilder untuk menangani data async dari Supabase
    return FutureBuilder(
      future: _future, // Future yang akan di-handle (data dari Supabase)

      builder: (context, snapshot) {
        // Jika data belum tersedia, tampilkan loading indicator
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Jika data sudah tersedia, ambil data dari snapshot
        final instruments = snapshot.data!;

        // Buat ListView yang menampilkan data instruments
        return ListView.builder(
          itemCount: instruments.length, // Jumlah item berdasarkan data
          itemBuilder: ((context, index) {
            final instrument = instruments[index]; // Ambil data per item
            return ListTile(
              title: Text(instrument['name']), // Tampilkan nama instrument
            );
          }),
        );
      },
    );
  }
}

/*
📚 Yang Harus Kamu Pelajari Agar Paham Kode Ini
🟢 1. Bahasa Dart
Dasar yang WAJIB kamu kuasai:

 Variable dan Tipe Data (int, String, List, Map, bool)

 Fungsi (void, Future, parameter, return)

 Null safety (?, !, late)

 Class dan Object (OOP dasar)

 Future & Async/Await → ⚠️ Penting untuk FutureBuilder

 Error Handling (try-catch, snapshot.hasError)

🟢 2. Flutter
Hal yang kamu gunakan di kode:

 MaterialApp, Scaffold, AppBar, Text, ListView, ListTile

 Stateless vs Stateful Widget

 FutureBuilder untuk menangani data async

 Widget lifecycle (initState, build)

 UI Layouting & Widget Composition (penataan dan struktur UI)

 Optional: Navigasi antar halaman (Navigator.push, dll.)

🟢 3. Supabase (Flutter SDK)
Hal penting yang kamu gunakan dan perlu dipahami:

 Supabase.initialize() → menghubungkan Flutter ke project Supabase

 Supabase.instance.client.from().select() → ambil data dari database

 Konsep table, row, column di database Supabase

 Membaca List<Map<String, dynamic>> hasil dari query Supabase

 Optional lanjutan:

 Autentikasi user (signUp, signIn)

 Insert/update/delete data (insert(), update(), delete())

*/
