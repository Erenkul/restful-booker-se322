Restful-Booker Nedir?
Otel rezervasyon sistemi API'si — yazılım test eğitimi için tasarlanmış bir REST API uygulaması. Node.js / Express ile yazılmış.

Proje Yapısı

restful-booker-se322/
├── app.js              → Express uygulaması, middleware ayarları
├── bin/www             → Sunucuyu başlatan dosya
├── routes/index.js     → Tüm API endpoint'leri burada
├── models/booking.js   → Veritabanı işlemleri (LokiJS - in-memory DB)
├── helpers/            → Parser, validator, booking creator yardımcıları
├── tests/spec.js       → Otomatik testler (Mocha + Chai)
└── public/             → Statik dosyalar / API dokümantasyonu
API Endpoint'leri
Method	URL	Açıklama
GET	/ping	Sunucu sağlık kontrolü
GET	/booking	Tüm rezervasyon ID'lerini listele
GET	/booking/:id	Belirli bir rezervasyonu getir
POST	/booking	Yeni rezervasyon oluştur
PUT	/booking/:id	Rezervasyonu tamamen güncelle
PATCH	/booking/:id	Rezervasyonu kısmen güncelle
DELETE	/booking/:id	Rezervasyonu sil
POST	/auth	Token al (login)
Önemli Detaylar
Veritabanı: Gerçek bir DB yok, LokiJS kullanıyor (uygulama kapanınca veriler siliyor)
Kimlik doğrulama: PUT, PATCH, DELETE için ya token cookie ya da Basic Auth gerekiyor
Kullanıcı adı: admin, Şifre: password123
Format desteği: JSON, XML ve URL-encoded formatları destekliyor
Test amacıyla tasarlandığı için başlangıçta 10 rastgele rezervasyon seed'leniyor
Test framework: Mocha + Chai + Supertest (npm test ile çalışır)
Nasıl Çalıştırılır?

npm install
npm start   # http://localhost:3000 adresinde açılır
Kısaca: API testing pratikleri için hazırlanmış, gerçek bir otel rezervasyon sistemi simülasyonu. SE322 dersi için test yazma alıştırması yapılacak bir proje olduğu anlaşılıyor.