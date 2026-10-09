# Ilmalogiya API Hujjatlari (API Documentation)

Ushbu hujjat **Ilmalogiya** loyihasining backend qismidagi barcha API endpointlari, ularning vazifalari, parametrlari, so'rov va javob namunalari bo'yicha to'liq qo'llanmadir.

---

## 📌 Umumiy Ma'lumotlar

- **Asosiy server (Base URL):** `https://api.ilmalogiya.uz` (yoki mahalliy: `http://127.0.0.1:8000`)
- **Format:** Barcha so'rov va javoblar odatda `application/json` formatida (fayl yuklanadigan endpointlar bundan mustasno: `multipart/form-data`).
- **Autentifikatsiya turi:** JSON Web Token (JWT) — `rest_framework_simplejwt`.
- **Avtorizatsiya Header formati:**
  ```http
  Authorization: Bearer <access_token>
  ```
- **Interaktiv API hujjatlari:**
  - Swagger UI: `GET /swagger/`
  - ReDoc: `GET /redoc/`
  - XML Sitemap: `GET /sitemap.xml`

---

## 🔐 1. Autentifikatsiya va Foydalanuvchilar (`/api/auth/`)

### 1.1. Google orqali tizimga kirish / Ro'yxatdan o'tish
Firebase orqali olingan Google `id_token` ni tekshiradi. Foydalanuvchi mavjud bo'lmasa avtomatik ro'yxatdan o'tkazadi va JWT juftligini (access va refresh token) qaytaradi.

- **Metod:** `POST`
- **URL:** `/api/auth/google/`
- **Ruxsat:** Ochiq (`AllowAny`)
- **Content-Type:** `application/json`

**Request Body:**
```json
{
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6..."
}
```

**Javob (200 OK):**
```json
{
  "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6...",
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6...",
  "user": {
    "id": 1,
    "email": "user@gmail.com",
    "full_name": "Falonchi Pistonchiyev",
    "avatar": "https://lh3.googleusercontent.com/...",
    "bio": "Dasturchi va kitobxon",
    "social_links": ["https://t.me/username", "https://github.com/username"],
    "date_joined": "2026-01-10T12:00:00Z"
  },
  "is_new": false
}
```

---

### 1.2. JWT Tokenni Yangilash (Refresh Token)
Muddati o'tgan access tokenni yangilash uchun ishlatiladi.

- **Metod:** `POST`
- **URL:** `/api/auth/token/refresh/`
- **Ruxsat:** Ochiq (`AllowAny`)

**Request Body:**
```json
{
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6..."
}
```

**Javob (200 OK):**
```json
{
  "access": "yangi_access_token_string",
  "refresh": "yangi_refresh_token_string"
}
```

---

### 1.3. Joriy Foydalanuvchi Profili (Profile Me)
Tizimga kirgan foydalanuvchining o'z shaxsiy profilini olish va tahrirlash.

- **URL:** `/api/auth/me/`
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)
- **Headers:** `Authorization: Bearer <access_token>`

#### GET — Profil ma'lumotlarini olish
**Javob (200 OK):**
```json
{
  "id": 1,
  "email": "user@gmail.com",
  "full_name": "Falonchi Pistonchiyev",
  "avatar": "https://...",
  "bio": "Mening biom",
  "social_links": ["https://t.me/falonchi"],
  "date_joined": "2026-01-10T12:00:00Z"
}
```

#### PATCH — Profilni qisman tahrirlash
> Izoh: `social_links` ko'pi bilan 5 ta to'g'ri URL manzilidan iborat bo'lishi mumkin.

**Request Body:**
```json
{
  "full_name": "Yangi Ism",
  "bio": "Yangilangan bio tavsifi",
  "social_links": [
    "https://t.me/yangi_akkaunt",
    "https://github.com/yangi"
  ]
}
```

**Javob (200 OK):** Yangilangan profil obyekti qaytadi.

---

### 1.4. Barcha Foydalanuvchilar Ro'yxati (Admin / Qidiruv)
- **Metod:** `GET`
- **URL:** `/api/auth/users/`
- **Ruxsat:** Ochiq (`AllowAny`)
- **Query Parametrlari:**
  - `search` (ixtiyoriy): Foydalanuvchi ismi yoki emaili bo'yicha qidiruv.
  - `page` (ixtiyoriy, default: 1): Sahifa raqami.
  - `page_size` (ixtiyoriy, default: 20, max: 100): Har sahifadagi elementlar soni.

**Javob (200 OK):**
```json
{
  "count": 150,
  "next": "https://api.ilmalogiya.uz/api/auth/users/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "email": "user@gmail.com",
      "full_name": "Falonchi Pistonchiyev",
      "avatar": "https://...",
      "is_active": true,
      "is_staff": false,
      "date_joined": "2026-01-10T12:00:00Z",
      "saved_posts_count": 5,
      "saved_quotes_count": 12
    }
  ]
}
```

---

### 1.5. Muallifning Ochiq Profili (Public Author Profile)
Boshqa foydalanuvchilar ko'rishi mumkin bo'lgan ochiq ma'lumotlar va tasdiqlangan postlar soni.

- **Metod:** `GET`
- **URL:** `/api/auth/users/<id>/profile/`
- **Ruxsat:** Ochiq (`AllowAny`)

**Javob (200 OK):**
```json
{
  "id": 1,
  "full_name": "Falonchi Pistonchiyev",
  "avatar": "https://...",
  "bio": "Bio matni",
  "social_links": ["https://t.me/falonchi"],
  "posts_count": 8,
  "verified": true,
  "date_joined": "2026-01-10T12:00:00Z"
}
```

---

### 1.6. Saqlangan Elementlar (Barchasi birgalikda)
Foydalanuvchi saqlagan barcha postlar va iqtiboslarni bitta javobda olish.

- **Metod:** `GET`
- **URL:** `/api/auth/me/saved/`
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)

**Javob (200 OK):**
```json
{
  "saved_posts": {
    "count": 2,
    "results": [ /* PostSerializer obyektlari */ ]
  },
  "saved_quotes": {
    "count": 4,
    "results": [ /* QuoteDetailSerializer obyektlari */ ]
  }
}
```

---

### 1.7. Saqlangan Postlar (CRUD)
- **URL:** `/api/auth/me/saved/posts/`
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)

#### GET — Saqlangan postlar ro'yxati (Paginated, page_size: 10)
**Javob (200 OK):** Sahifalangan postlar ro'yxati.

#### POST — Postni saqlash
**Request Body:**
```json
{
  "post_id": 15
}
```
**Javob (201 Created yoki 200 OK):**
```json
{
  "detail": "Post saqlandi."
}
```

#### DELETE — Postni saqlanganlardan o'chirish
**Request Body:**
```json
{
  "post_id": 15
}
```
**Javob (200 OK):**
```json
{
  "detail": "Post saqlanganlardan o'chirildi."
}
```

---

### 1.8. Saqlangan Iqtiboslar (Saved Quotes CRUD)
- **URL:** `/api/auth/me/saved/quotes/`
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)

#### GET — Saqlangan iqtiboslar ro'yxati (Paginated, page_size: 10)
**Javob (200 OK):** Sahifalangan iqtiboslar ro'yxati.

#### POST — Iqtibosni saqlash
**Request Body:**
```json
{
  "quote_id": 7
}
```
**Javob (201 Created yoki 200 OK):**
```json
{
  "detail": "Quote saqlandi."
}
```

#### DELETE — Iqtibosni saqlanganlardan o'chirish
**Request Body:**
```json
{
  "quote_id": 7
}
```
**Javob (200 OK):**
```json
{
  "detail": "Quote saqlanganlardan o'chirildi."
}
```

---

## 📝 2. Postlar va Bosh Sahifa (`/api/`)

### 2.1. Tasdiqlangan Postlar Ro'yxati
Saytda e'lon qilingan maqolalar (`status="approved"`).

- **Metod:** `GET`
- **URL:** `/api/posts/`
- **Ruxsat:** Ochiq (`AllowAny`)
- **Query Parametrlari:**
  - `page` (int, default: 1)
  - `page_size` (int, default: 10, max: 100)
  - `tag` (string): Bitta yoki bir nechta teg bo'yicha filtrlash (vergul bilan: `?tag=dasturlash,suniy-intellekt`)
  - `tags` (array): Teglar ro'yxati (`?tags[]=dasturlash&tags[]=ai`)
  - `search` (string): Sarlavha (`title`) yoki matn (`description`) bo'yicha qidirish
  - `author` (int): Muallifning `user_id` si bo'yicha

**Javob (200 OK):**
```json
{
  "count": 45,
  "next": "https://api.ilmalogiya.uz/api/posts/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "title": "Sun'iy intellekt kelajagi",
      "slug": "suniy-intellekt-kelajagi",
      "description": "Sun'iy intellekt haqida batafsil maqola...",
      "tags": ["texnologiya", "ai"],
      "file": "https://api.ilmalogiya.uz/media/posts/files/ai.png",
      "imgblur": "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
      "views": 154,
      "status": "approved",
      "is_saved": false,
      "author_name": "Azizbek",
      "author_links": ["https://t.me/azizbek"],
      "author_verified": true,
      "rejection_reason": "",
      "publishedDate": "2026-02-15T09:30:00Z",
      "modifiedDate": "2026-02-15T10:00:00Z"
    }
  ]
}
```

---

### 2.2. Post Yaratish (Admin / To'liq CRUD)
- **Metod:** `POST`
- **URL:** `/api/posts/`
- **Ruxsat:** Ochiq / Admin
- **Content-Type:** `multipart/form-data` yoki `application/json`
- **Izoh:** Post yaratilgach Firebase Cloud Messaging (FCM) orqali `news` mavzusiga avtomatik push notification yuboriladi. Rasm yuklansa BlurHash avtomatik hisoblanadi.

**Form Data / JSON maydonlari:**
- `title` (matn, majburiy)
- `description` (matn, majburiy)
- `tags` (massiv: `["ai", "kitob"]`)
- `file` (fayl/rasm, ixtiyoriy)

---

### 2.3. Post Tafsiloti (Bitta postni olish)
- **Metod:** `GET`
- **URL:** `/api/posts/<slug>/`
- **Ruxsat:** Ochiq (Ammo post tasdiqlanmagan bo'lsa, faqat egasiga ko'rinadi)
- **Izoh:** Har safar chaqirilganda ushbu postning `views` (ko'rishlar soni) avtomatik ravishda `+1` ga oshadi.

---

### 2.4. Postni Tahrirlash va O'chirish
- **URL:** `/api/posts/<slug>/`
- **Metodlar:**
  - `PUT` — To'liq yangilash
  - `PATCH` — Qisman yangilash
  - `DELETE` — O'chirish (204 No Content)

---

### 2.5. Foydalanuvchi Tomonidan Maqola Yuborish (Submit Post)
Oddiy foydalanuvchilar o'z maqolalarini tekshirishga yuborishi uchun. Status avtomatik tarzda `pending` bo'ladi.

- **Metod:** `POST`
- **URL:** `/api/posts/submit/`
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)
- **Content-Type:** `multipart/form-data`
- **Cheklovlar:**
  - Faqat rasm yuklash mumkin (`.jpg`, `.jpeg`, `.png`, `.webp`)
  - Maksimal rasm hajmi: **1 MB**

**Form-Data maydonlari:**
- `title`: Maqola sarlavhasi (string)
- `description`: Maqola matni (string)
- `tags`: Teglar (masalan: `dasturlash`, `ilm`)
- `file`: Muqova rasmi (rasm fayli)

**Javob (201 Created):**
```json
{
  "id": 42,
  "title": "Mening yangi maqolam",
  "slug": "mening-yangi-maqolam",
  "description": "...",
  "tags": ["ilm"],
  "file": "http://.../posts/files/rasm.webp",
  "status": "pending"
}
```

---

### 2.6. Foydalanuvchining O'z Maqolalari
Foydalanuvchi yuborgan barcha maqolalar ro'yxati (kutilayotgan, tasdiqlangan yoki rad etilgan).

- **Metod:** `GET`
- **URL:** `/api/posts/my-posts/`
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)

---

### 2.7. Postlarni Moderatsiya Qilish (Admin)
- **Metod:** `GET`
- **URL:** `/api/posts/moderation/`
- **Query Parametrlari:**
  - `status`: `pending` (standart), `approved`, yoki `rejected`

---

### 2.8. Postni Tasdiqlash (Approve)
Postni saytda chop etish va obunachilarga push notification jo'natish.

- **Metod:** `POST`
- **URL:** `/api/posts/<slug>/approve/`
- **Javob (200 OK):** Tasdiqlangan post obyekti.

---

### 2.9. Postni Rad Etish (Reject)
- **Metod:** `POST`
- **URL:** `/api/posts/<slug>/reject/`
- **Request Body:**
  ```json
  {
    "reason": "Maqolada imlo xatolari ko'p yoki talablarga to'g'ri kelmadi."
  }
  ```
- **Javob (200 OK):** Rad etilgan post obyekti (`status="rejected"`, `rejection_reason` bilan).

---

### 2.10. Tasodifiy Post (Random Post)
- **Metod:** `GET`
- **URL:** `/api/posts/random/`
- **Query Parametr:** `exclude` (string, ixtiyoriy) — hozir ko'rilayotgan postning slugi, uni natijadan chiqarib tashlaydi.
- **Izoh:** Ko'rishlar soni (`views`) oshirilmaydi.

---

### 2.11. Eng So'nggi Post (Latest Post)
- **Metod:** `GET`
- **URL:** `/api/posts/latest/`
- **Query Parametr:** `exclude` (string, ixtiyoriy)
- **Izoh:** Eng oxirgi chop etilgan postni qaytaradi, `views` o'zgarmaydi.

---

### 2.12. Aralash Postlar (Mixed Posts)
60% eng so'nggi postlar va 40% eng mashhur (ko'p ko'rilgan) postlarni tasodifiy aralashtirib taqdim etadi.

- **Metod:** `GET`
- **URL:** `/api/posts/mixed-posts/`
- **Query Parametr:** `limit` (default: 10, max: 50)

---

### 2.13. Postni Saqlash / Olib Tashlash (Toggle Save)
- **Metod:** `POST`
- **URL:** `/api/posts/<slug>/save/`
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)

**Javob (201 Created yoki 200 OK):**
```json
// Agar saqlansa:
{
  "saved": true,
  "message": "Saqlandi"
}

// Agar allaqachon saqlangan bo'lsa va yana bosilsa:
{
  "saved": false,
  "message": "Saqlashdan olib tashlandi"
}
```

---

### 2.14. Aloqador (O'xshash) Postlar (Related Posts)
Shu postning teglari bilan mos keladigan eng yaqin postlar.

- **Metod:** `GET`
- **URL:** `/api/posts/<slug>/related/`
- **Javob (200 OK):** Mos keluvchi postlar ro'yxati (10 tagacha).

---

### 2.15. Post Teglari (`/api/tags/`)
- `GET /api/tags/` — Barcha teglar ro'yxati (pagination yo'q).
- `POST /api/tags/` — Yangi teg yaratish (`{"name": "matn"}`). Mavjud bo'lsa, mavjudi qaytadi.
- `GET /api/tags/<id>/` — Teg tafsiloti.
- `PUT/PATCH /api/tags/<id>/` — Tegni tahrirlash.
- `DELETE /api/tags/<id>/` — Tegni o'chirish.
- `POST /api/tags/get_or_create/` — Teg nomi bo'yicha olish yoki yangisini yaratish (`{"name": "tag_name"}`).

---

### 2.16. Bosh Sahifa Agregatsiyasi (Home Page)
Frontend bosh sahifasi uchun barcha kerakli ma'lumotlarni yagona so'rovda qaytaradi.

- **Metod:** `GET`
- **URL:** `/api/home/`
- **Query Parametrlari:**
  - `page` (int, default: 1)
  - `page_size` (int, default: 10, max: 50)
  - `seed` (string, ixtiyoriy) — aralashtirish barqarorligi uchun tasodifiy seed
  - `tag`, `tags`, `search` — postlarni filtrlash

**Javob (200 OK):**
```json
{
  "tags": [
    { "id": 1, "name": "dasturlash" },
    { "id": 2, "name": "suniy-intellekt" }
  ],
  "posts": {
    "count": 45,
    "next": "https://api.ilmalogiya.uz/api/home/?page=2&seed=0.456",
    "previous": null,
    "seed": "0.456",
    "results": [ /* 60% yangi + 40% mashhur postlar */ ]
  },
  "random_post": { /* bitta tasodifiy post obyekti */ },
  "latest_post": { /* bitta eng yangi post obyekti */ }
}
```

---

### 2.17. Umumiy Statistika (Site Stats)
Admin panel yoki dashboard uchun to'liq analitika.

- **Metod:** `GET`
- **URL:** `/api/stats/`
- **Ruxsat:** Ochiq (`AllowAny`)

**Javob (200 OK):**
```json
{
  "totals": {
    "posts": 120,
    "tags": 35,
    "views": 45200,
    "saved_posts": 310,
    "saved_quotes": 480,
    "users": 850,
    "active_users": 845,
    "staff_users": 3,
    "new_users_30d": 92
  },
  "top_posts_by_views": [
    { "title": "Maqola sarlavhasi", "slug": "maqola-slug", "views": 3200 }
  ],
  "top_posts_by_saves": [
    { "title": "Maqola sarlavhasi", "slug": "maqola-slug", "saves": 140 }
  ],
  "top_users": [
    { "email": "user@gmail.com", "full_name": "Aziz", "saves": 55 }
  ],
  "monthly": {
    "posts": [ { "month": "2026-01", "count": 14 } ],
    "users": [ { "month": "2026-01", "count": 45 } ],
    "saved_posts": [ { "month": "2026-01", "count": 120 } ],
    "saved_quotes": [ { "month": "2026-01", "count": 180 } ]
  }
}
```

---

## 💬 3. Iqtiboslar va Mualliflar (`/api/quotes/`)

### 3.1. Mualliflar (Authors CRUD)
- **URL:** `/api/quotes/authors/`
- **Lookup maydoni:** `slug` (masalan `/api/quotes/authors/alisher-navoiy/`)

#### GET `/api/quotes/authors/`
Mualliflar ro'yxati (paginated).
**Javob (200 OK):**
```json
{
  "count": 12,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1,
      "name": "Alisher Navoiy",
      "slug": "alisher-navoiy",
      "bio": "Buyuk o'zbek shoiri va mutafakkiri",
      "photo": "https://api.ilmalogiya.uz/media/quotes/authors/navoiy.jpg",
      "quotes_count": 25,
      "created_date": "2026-01-01T00:00:00Z",
      "modified_date": "2026-01-01T00:00:00Z"
    }
  ]
}
```

#### POST `/api/quotes/authors/`
Yangi muallif yaratish (`multipart/form-data`: `name`, `bio`, `photo`).

#### GET `/api/quotes/authors/<slug>/`
Muallif tafsiloti.

#### PUT / PATCH `/api/quotes/authors/<slug>/`
Muallif ma'lumotlarini tahrirlash.

#### DELETE `/api/quotes/authors/<slug>/`
Muallifni o'chirish.

#### GET `/api/quotes/authors/<slug>/quotes/`
Aynan shu muallifga tegishli barcha iqtiboslar ro'yxati (paginated).

---

### 3.2. Iqtiboslar (Quotes CRUD)
- **URL:** `/api/quotes/quotes/`
- **Lookup maydoni:** `slug`

#### GET `/api/quotes/quotes/`
Barcha iqtiboslar ro'yxati.
- **Query Parametrlari:**
  - `page` (int, default: 1)
  - `page_size` (int, default: 10, max: 100)
  - `tag` (string): vergul bilan ajratilgan teglar (`?tag=hikmat,ilm`)
  - `tags` (array): `?tags[]=hikmat&tags[]=ilm`
  - `search` (string): Iqtibos matni yoki muallif ismi bo'yicha qidirish
  - `author` (string): Muallifning slugi bo'yicha filtrlash (`?author=alisher-navoiy`)

**Javob (200 OK):**
```json
{
  "count": 50,
  "next": "https://api.ilmalogiya.uz/api/quotes/quotes/?page=2",
  "previous": null,
  "results": [
    {
      "id": 3,
      "text": "Tilga ixtiyorsiz — elga e'tiborsiz.",
      "slug": "tilga-ixtiyorsiz-elga-etiborsiz",
      "author_slug": "alisher-navoiy",
      "author_name": "Alisher Navoiy",
      "author_photo": "https://api.ilmalogiya.uz/media/quotes/authors/navoiy.jpg",
      "tags": ["til", "hikmat"],
      "is_saved": false,
      "created_date": "2026-01-05T10:00:00Z",
      "modified_date": "2026-01-05T10:00:00Z"
    }
  ]
}
```

#### POST `/api/quotes/quotes/`
Yangi iqtibos qo'shish.
**Request Body:**
```json
{
  "text": "Harakatda barakat bor.",
  "author_slug": "alisher-navoiy",
  "tags": ["hikmat", "hayot"]
}
```

#### GET `/api/quotes/quotes/<slug>/`
Iqtibos tafsilotini olish (bunda to'liq `author` obyekti va to'liq `tags` massivi qaytadi).

#### PUT / PATCH `/api/quotes/quotes/<slug>/`
Iqtibosni tahrirlash.

#### DELETE `/api/quotes/quotes/<slug>/`
Iqtibosni o'chirish.

#### GET `/api/quotes/quotes/random/`
Tasodifiy bitta iqtibosni olish.

#### GET `/api/quotes/quotes/latest/`
Eng so'nggi yaratilgan bitta iqtibosni olish.

#### POST `/api/quotes/quotes/<slug>/save/`
Iqtibosni saqlash / saqlashdan chiqarish (Toggle).
- **Ruxsat:** Autentifikatsiyadan o'tgan (`IsAuthenticated`)
- **Javob:** `{"saved": true, "message": "Saqlandi"}` yoki `{"saved": false, "message": "Saqlashdan olib tashlandi"}`

---

### 3.3. Iqtibos Teglari (`/api/quotes/tags/`)
- `GET /api/quotes/tags/` — Iqtibos teglari ro'yxati (paginated).
- `POST /api/quotes/tags/` — Yangi teg qo'shish (`{"name": "hikmat"}`).
- `GET /api/quotes/tags/<id>/` — Teg tafsiloti.
- `PUT / PATCH /api/quotes/tags/<id>/` — Tegni o'zgartirish.
- `DELETE /api/quotes/tags/<id>/` — Tegni o'chirish.

---

### 3.4. Iqtiboslar Sahifasi Agregatsiyasi (Quotes Page)
Frontend iqtiboslar sahifasi uchun barcha ma'lumotlarni birdaniga qaytaradi.

- **Metod:** `GET`
- **URL:** `/api/quotes/quotes-page/`
- **Query Parametrlari:**
  - `page`, `page_size`, `tag`, `tags`, `search`, `author`

**Javob (200 OK):**
```json
{
  "tags": [
    { "id": 1, "name": "hikmat" },
    { "id": 2, "name": "ilm" }
  ],
  "quotes": {
    "count": 50,
    "next": "https://api.ilmalogiya.uz/api/quotes/quotes-page/?page=2",
    "previous": null,
    "results": [ /* QuoteSerializer obyektlari */ ]
  },
  "random_post": { /* Bitta tasodifiy blog post obyekti */ },
  "latest_post": { /* Bitta eng so'nggi blog post obyekti */ }
}
```

---

## 🗺️ 4. Tizim va SEO Endpointlari

### 4.1. XML Sitemap
Qidiruv tizimlari (Google, Yandex) uchun dinamik yaratiluvchi sitemap.

- **Metod:** `GET`
- **URL:** `/sitemap.xml`
- **Content-Type:** `application/xml`
- **Tarkibi:**
  - Asosiy sahifalar (`/`, `/quotes`)
  - Barcha tasdiqlangan postlar (`/posts/<slug>`)
  - Barcha iqtiboslar (`/quotes/<slug>`)
  - Barcha mualliflar (`/quotes/author/<slug>`)

---

## ⚠️ 5. Xatoliklar va HTTP Status Kodlari

| HTTP Status Kod | Ma'nosi | Misol holatlar |
|---|---|---|
| `200 OK` | Muvaffaqiyatli | Ma'lumot olindi yoki yangilandi |
| `201 Created` | Muvaffaqiyatli yaratildi | Yangi post, foydalanuvchi yoki saqlash qo'shildi |
| `204 No Content` | Muvaffaqiyatli o'chirildi | Delete so'rovlarida |
| `400 Bad Request` | Noto'g'ri so'rov | Yuborilgan parametrlar xato, fayl hajmi 1MB dan katta yoki havola noto'g'ri |
| `401 Unauthorized` | Autentifikatsiyadan o'tilmagan | JWT token berilmagan yoki muddati o'tgan |
| `403 Forbidden` | Ruxsat yetarli emas | Begona postni ko'rish yoki tahrirlash huquqi yo'q |
| `404 Not Found` | Topilmadi | Post, iqtibos yoki sahifa mavjud emas |
| `500 Server Error` | Server ichki xatoligi | Kutilmagan server xatosi |
