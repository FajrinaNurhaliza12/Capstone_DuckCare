# 🦆 DuckCare — Smart Duck Farm Management

Aplikasi mobile untuk monitoring dan manajemen peternakan bebek berbasis kecerdasan buatan.

## 🏗 Arsitektur Aplikasi

```
Flutter (GetX MVC Pattern)
    ↓ HTTP/JSON
PHP Backend (XAMPP/Apache)
    ↓ PDO Prepared Statement
MySQL Database
    ↓ SMTP
PHPMailer → Mailtrap (Email OTP)
```

---

## 🔐 Fitur Keamanan

| Teknik | Deskripsi |
|---|---|
| OTP via Email | Kode verifikasi 6 digit dengan expired 2 menit |
| Bcrypt Hashing | Password tidak disimpan plaintext |
| JWT Token | Autentikasi session setelah login |
| Max 3x Attempts | Mencegah brute force OTP |
| Single-use OTP | OTP hanya bisa dipakai sekali |
| PDO Prepared Statement | Mencegah SQL Injection |
| Login Activity Log | Mencatat riwayat login user |

---

## 📂 Struktur Project

```
lib/
└── app/
    ├── data/
    │   ├── models/
    │   │   ├── user_model.dart
    │   │   ├── login_activity_model.dart
    │   │   └── log_model.dart
    │   └── providers/
    │       └── auth_provider.dart
    ├── modules/
    │   ├── splash/
    │   ├── login/
    │   ├── register/
    │   ├── otp/
    │   ├── forgot_password/
    │   ├── reset_password/
    │   ├── home/
    │   ├── profile/
    │   ├── duckscan/
    │   ├── duck_management/
    │   ├── notification/
    │   └── report/
    └── routes/
        ├── app_pages.dart
        └── app_routes.dart
```

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- XAMPP (Apache + MySQL)
- Composer

### Backend Setup
```bash
cd C:\xampp\htdocs\duckcare_api
composer install
```

Isi kredensial Mailtrap di `helpers/otp_helper.php`:
```php
$mail->Username = 'your_mailtrap_username';
$mail->Password = 'your_mailtrap_password';
```

Isi IP lokal di `lib/app/data/providers/auth_provider.dart`:
```dart
static const String _base = 'http://IP_LOKAL_KAMU/duckcare_api/auth';
```

### Flutter Setup
```bash
flutter pub get
flutter run
```

---

## 🔐 Pentest Summary

| Skenario | Hasil |
|---|---|
| Brute Force OTP (3x salah) | ✅ Diblokir |
| OTP Expired (2 menit) | ✅ Ditolak |
| Akses tanpa JWT | ✅ 401 Unauthorized |
| SQL Injection | ✅ Aman (PDO) |
| Token JWT Palsu | ✅ Ditolak |
