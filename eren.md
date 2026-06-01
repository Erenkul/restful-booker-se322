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




-----------------------------------------------------------------------------
2. PHASE 1 – OpenAPI Spec
docs/api/openapi.yaml dosyası oluşturuldu. Mevcut tüm endpointler belgelendi.

| Method | Endpoint        | Açıklama                        |
|--------|-----------------|----------------------------------|
| GET    | /ping           | Health check                     |
| POST   | /auth           | Token alma                       |
| GET    | /booking        | Tüm ID'ler (filtreli/filtresiz)  |
| POST   | /booking        | Yeni booking oluştur             |
| GET    | /booking/{id}   | Tek booking getir                |
| PUT    | /booking/{id}   | Tam güncelleme                   |
| PATCH  | /booking/{id}   | Kısmi güncelleme                 |
| DELETE | /booking/{id}   | Silme                            |

EREN: BU PHASE DE GENEL OLARAK YAPTIĞIMIZ APININ ENDPOINTLERINI, ALDIĞI PARAMETRELERİ VE DÖNEN RESPONSE LARI İÇERİYOR.

-----------------------------------------------------------------------------
3. PHASE 2 – Yeni Endpoint: GET /booking/search
routes/ klasörüne yeni route ekleyeceksin. Örnek Node.js kodu:
javascriptrouter.get('/booking/search', async (req, res) => {
  const { firstname, lastname, checkin, checkout } = req.query;
  // filtreleme mantığı
});


EREN: routes/index.js de get/booking sadece id leri döndürüyor anladığım. bizim ekleyeceğimiz ile filtrelerle tam booking booking objeleri döndürülecek. bu GET /booking/search ile.

AI da anladığım gibi olduğunu söyledi işte:
    GET /booking → sadece [{ bookingid: 1 }, { bookingid: 2 }] döner
    GET /booking/search → tam objeleri döner (isim, fiyat, tarihler vs.)

 GET /booking/search endpoint'i koda eklenmeli
 openapi.yaml bu yeni endpoint ile güncellenmeli
-----------------------------------------------------------------------------

4. PHASE 3 – C4 Diyagramları (Structurizr DSL)
docs/architecture/workspace.dsl dosyası + 3 tactic (Warm Redundant Spare, Input Validation, Data Replication) modellenecek.
DSL dosyasını yazmamı ister misin? → "C4 DSL yaz" de.