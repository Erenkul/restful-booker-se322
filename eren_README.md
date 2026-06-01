ALP EREN KUL 22244710073

-----------------------------------------------------------------------------
PROJE ÖZETİ – SE322

1. New Endpoint – GET /booking/search
   routes/index.js dosyasına eklendi. GET /booking'den farkı: ID yerine tam booking objelerini döndürür.
   Filtreler: firstname, lastname, checkin, checkout (query param)

2. OpenAPI Specification
   Dosya: docs/api/openapi.yaml
   Tüm endpointler belgelenmiştir (GET /booking/search dahil).

3. C4 Architecture (Level 1, 2, 3)
   Dosya: docs/architecture/workspace.dsl
   Görseller: docs/architecture/
     - Level1-SystemContext-dark.png  → Sistem bağlamı
     - Level2-Container-dark.png      → Container'lar
     - Level3-Component-dark.png      → Component'ler

4. Architectural Tactics (3 adet)
   - Warm Redundant Spare  → Standby Application (Level 2)
   - Input Validation      → Validator component (Level 3)
   - Data Replication      → Replica Database (Level 2)
-----------------------------------------------------------------------------



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


Phase 3 — Ne Yapacağız?
Task 3.1 — C4 Diyagramları (Structurizr DSL)

Sistemi 3 seviyede modelleyeceğiz:

Level 1 (System Context): API Client → Restful Booker sistemi
Level 2 (Container): Node.js app, Primary DB, Replica DB, Standby App
Level 3 (Component): Router, Validator, Parser, Booking Model, Auth Handler



workspace.dsl dosyasında C4 Architecture modelini Structurizr DSL formatında yazdık. İşte yaptıklarımız:

Model (Kim var, ne var)

client → API'yi kullanan kişi/sistem (Person)
restfulBooker → Ana yazılım sistemi (SoftwareSystem)
webApp → Node.js/Express uygulaması (birincil container)
standbyApp → Yedek uygulama instance'ı (container)
primaryDb → Ana LokiJS veritabanı (container)
replicaDb → Replica veritabanı (container)
webApp'in içindeki componentler (Level 3)

validator → Gelen request'leri doğrular
router → Tüm endpoint'leri yönetir
parser → JSON/XML/URL-encoded response formatlar
bookingCreator → Başlangıçta DB'yi seed'ler
authHandler → Token üretir ve doğrular
bookingModel → DB CRUD işlemleri
3 Architectural Tactic (Ders gereksinimi)

Tactic	Nerede görünür
Warm Redundant Spare	standbyApp — Level 2 diyagramda
Input Validation	validator — Level 3 diyagramda
Data Replication	replicaDb — Level 2 diyagramda
3 Diagram View

Level 1 – System Context (dışarıdan bakış)
Level 2 – Container (container'lar arası ilişki)
Level 3 – Component (webApp içindeki componentler)



Task 3.2 — 3 Architectural Tactic (diyagramda görünür olacak)

| Tactic               | Nerede görünür                          | Dosya                                        |
|----------------------|-----------------------------------------|----------------------------------------------|
| Warm Redundant Spare | Level 2'de Standby Application container| Level2-Container-dark.png                    |
| Input Validation     | Level 3'te Validator component          | Level3-Component-dark.png                    |
| Data Replication     | Level 2'de Replica DB container         | Level2-Container-dark.png                    |

EREN: TÜM PNG'LER docs/architecture/ KLASÖRÜNE EKLENDİ VE eren BRANCH'İNE PUSH EDİLDİ.
- Level1-SystemContext-dark.png
- Level2-Container-dark.png
- Level3-Component-dark.png
(+ her birinin legend/key versiyonu)