# Function Calling Documentation

Dokumentasi ini menjelaskan function calling yang tersedia untuk LLM dalam sistem rekomendasi wisata Banjarnegara.

## Daftar Functions

Saat ini, terdapat **6 function declarations** yang didefinisikan untuk LLM:

### 1. `get_recommendations`
Mendapatkan rekomendasi tempat wisata berdasarkan kriteria pengguna.

**Kapan digunakan:**
- User meminta rekomendasi tempat wisata (umum atau spesifik)
- User mencari tempat wisata dengan kriteria tertentu (misal: pantai, gunung, air terjun, dll)

**Parameter:**
- `criteria` (string): Kriteria pencarian. Gunakan "general" untuk permintaan umum.

**File Declaration:** `src/functionDeclarations/getRecommendations.js`

**Contoh Query:**
- "Rekomendasikan tempat wisata di Banjarnegara"
- "Cari tempat wisata yang ada air terjunnya"
- "Wisata alam di Banjarnegara"

---

### 2. `get_information`
Mendapatkan informasi detail tentang tempat wisata tertentu.

**Kapan digunakan:**
- User bertanya tentang informasi spesifik suatu tempat wisata
- User ingin tahu detail lebih lanjut tentang destinasi tertentu

**Parameter:**
- `query` (string): Query pencarian informasi

**File Declaration:** `src/functionDeclarations/getInformation.js`

**Contoh Query:**
- "Informasi tentang Curug Pitu"
- "Ceritakan tentang Dieng Plateau"
- "Apa saja fasilitas di Kalibeber"

---

### 3. `get_comments`
Mendapatkan komentar/review dari pengguna untuk tempat wisata tertentu.

**Kapan digunakan:**
- User ingin melihat review atau komentar tentang tempat wisata
- User bertanya tentang pendapat pengunjung lain

**Parameter:**
- `wisata_id` (number, **optional**): ID tempat wisata. Jika tidak disediakan, akan otomatis diambil dari metadata hasil query sebelumnya (`get_recommendations` atau `get_information`)

**File Declaration:** `src/functionDeclarations/getComments.js`

**Implementasi:** `src/services/tourismDBService.js` → `getComments()`

**Database Table:** `komentar`

**Contoh Query:**
- "Apa kata orang tentang Curug Pitu?" (setelah query tentang Curug Pitu)
- "Tunjukkan review tempat ini"
- "Komentar pengunjung untuk wisata ini"

---

### 4. `get_likes_count`
Mendapatkan jumlah likes untuk tempat wisata tertentu.

**Kapan digunakan:**
- User ingin tahu seberapa populer suatu tempat wisata
- User bertanya tentang jumlah likes atau popularitas

**Parameter:**
- `wisata_id` (number, **optional**): ID tempat wisata. Jika tidak disediakan, akan otomatis diambil dari metadata hasil query sebelumnya (`get_recommendations` atau `get_information`)

**File Declaration:** `src/functionDeclarations/getLikesCount.js`

**Implementasi:** `src/services/tourismDBService.js` → `getLikesCount()`

**Database Table:** `likes`

**Contoh Query:**
- "Berapa banyak yang suka tempat ini?" (setelah query tentang suatu tempat)
- "Seberapa populer wisata ini?"
- "Jumlah likes untuk tempat wisata ini"

---

### 5. `get_weather`
Mendapatkan prakiraan cuaca untuk tempat wisata tertentu.

**Kapan digunakan:**
- User ingin mengetahui kondisi cuaca di suatu tempat wisata
- User bertanya tentang prakiraan cuaca sebelum berkunjung
- LLM merasa informasi cuaca relevan dengan rekomendasi

**Parameter:**
- `region_code` (string): Kode region level IV (adm4) dari BMKG Indonesia (contoh: "31.75.08.17")

**File Declaration:** `src/functionDeclarations/getWeather.js`

**Implementasi:** `src/services/weatherService.js` → `getWeatherData()`

**Data Source:** [BMKG Weather API](https://api.bmkg.go.id/publik/prakiraan-cuaca)

**Contoh Query:**
- "Bagaimana cuacanya di Dieng?"
- "Ceritakan tentang cuaca di Banjarnegara"
- "Prakiraan cuaca untuk wisata ini"

---

### 6. `get_distance_km`
Menghitung jarak antara dua koordinat menggunakan TomTom Routing API.

**Kapan digunakan:**
- User ingin mengetahui jarak dari satu tempat ke tempat lain
- User bertanya berapa jauh tempat wisata dari lokasi mereka
- Informasi jarak relevan untuk rekomendasi perjalanan

**Parameter:**
- `start_lat` (number): Latitude lokasi awal
- `start_long` (number): Longitude lokasi awal
- `end_lat` (number): Latitude lokasi tujuan (wisata)
- `end_long` (number): Longitude lokasi tujuan (wisata)

**File Declaration:** `src/functionDeclarations/getDistanceKm.js`

**Implementasi:** `src/services/distanceService.js` → `getDistanceKm()`

**API Provider:** [TomTom Routing API](https://developer.tomtom.com/routing-api/)

**Return Value:** Jarak dalam kilometer (2 decimal places)

**Contoh Query:**
- "Berapa jauhnya dari Bandung ke Curug Pitu?"
- "Jarak dari lokasi saya ke tempat wisata ini"
- "Seberapa jauh perjalanan ke sini?"

**Requirements:**
- `TOMTOM_API_KEY` harus dikonfigurasi di `.env`

---

## Alur Kerja Function Calling

### Workflow Standar

1. **Query Awal** → User bertanya tentang wisata
   ```
   User: "Rekomendasikan wisata air terjun"
   LLM calls: get_recommendations(criteria: "air terjun")
   Response: [List tempat wisata + metadata termasuk wisata_id]
   ```

2. **Follow-up Query** → User bertanya tentang comments/likes
   ```
   User: "Berapa yang suka tempat pertama?"
   LLM calls: get_likes_count()
   System: Otomatis menggunakan wisata_id dari query sebelumnya
   Response: "Tempat wisata ini memiliki 150 likes"
   ```

### Metadata Context

`ChatService` menyimpan `metadataContext` dari hasil query Vector DB yang berisi:
- `wisata_id`: ID tempat wisata dari database
- Metadata lainnya dari ChromaDB

Context ini digunakan untuk function `get_comments` dan `get_likes_count` jika `wisata_id` tidak diberikan secara eksplisit.

---

## Implementasi di ChatService

**File:** `src/services/chatService.js`

### Constructor
```javascript
constructor(llmService, tourismService, tourismDBService) {
  this.llmService = llmService;
  this.tourismService = tourismService;      // ChromaDB operations
  this.tourismDBService = tourismDBService;  // PostgreSQL operations
}
```

### Process Query Flow

1. LLM menerima query dengan 6 function declarations
2. LLM memilih function yang sesuai berdasarkan intent user
3. Function dipanggil dan hasilnya dikembalikan ke LLM
4. LLM dapat memanggil multiple functions dalam loop (maksimal 5 iterasi)
5. LLM memformat response dalam bahasa natural
6. Response dikirim ke user

### Metadata Extraction

Untuk `get_comments` dan `get_likes_count`:

```javascript
// Simpan metadata dari query sebelumnya
if (name === "get_recommendations") {
  const metadatas = toolResponse?.metadatas?.[0] ?? [];
  if (metadatas.length > 0) {
    metadataContext = metadatas;
  }
}

// Gunakan metadata untuk mendapatkan wisata_id
if (name === "get_comments") {
  let { wisata_id } = toolCall[0].args;
  
  if (!wisata_id && metadataContext) {
    wisata_id = metadataContext[0]?.wisata_id;
  }
}
```

---

## Dependencies

### Services
- **LlmService**: Komunikasi dengan Google Gemini API
- **TourismService**: Query ke ChromaDB (vector database)
- **TourismDBService**: Query ke PostgreSQL (relational database)

### Prisma Models
- `komentar`: Tabel komentar wisata
- `likes`: Tabel likes wisata

---

## Error Handling

Semua function memiliki error handling untuk:
- ✅ Parameter validation
- ✅ Database connection errors
- ✅ Data not found scenarios
- ✅ Type conversion errors

**Contoh:**
```javascript
if (!wisata_id) {
  throw new AppError(
    400,
    "Unable to determine wisata_id. Please specify a tourist attraction first."
  );
}
```

---

## Testing Function Calls

### Test Scenario 1: Recommendations + Likes
```
1. POST /chat/query
   Body: { "query": "Wisata air terjun di Banjarnegara" }
   Expected: get_recommendations dipanggil

2. POST /chat/query
   Body: { "query": "Berapa yang suka tempat pertama?" }
   Expected: get_likes_count dipanggil dengan wisata_id dari context
```

### Test Scenario 2: Information + Comments
```
1. POST /chat/query
   Body: { "query": "Informasi tentang Curug Pitu" }
   Expected: get_information dipanggil

2. POST /chat/query
   Body: { "query": "Apa kata pengunjung tentang tempat ini?" }
   Expected: get_comments dipanggil dengan wisata_id dari context
```

### Test Scenario 3: Weather Information
```
1. POST /chat/query
   Body: { "query": "Bagaimana cuaca di Dieng Plateau?" }
   Expected: get_weather dipanggil dengan region_code yang sesuai
   Response: Weather forecast untuk area Dieng
```

### Test Scenario 4: Distance Calculation
```
1. POST /chat/query
   Body: { "query": "Berapa jauh dari Jakarta ke Curug Pitu?" }
   Expected: get_distance_km dipanggil dengan koordinat Jakarta dan Curug Pitu
   Response: Jarak dalam kilometer
```

### Test Scenario 5: Multi-Function Call
```
1. POST /chat/query
   Body: { "query": "Rekomendasikan wisata air terjun dan berapa jauh dari Bandung?" }
   Expected:
   - get_recommendations dipanggil untuk air terjun
   - get_distance_km dipanggil untuk hitung jarak
   - get_weather dipanggil (opsional) untuk cuaca
   Response: Rekomendasi lengkap dengan jarak dan cuaca
```

---

## Catatan Penting

⚠️ **Metadata Requirement**
- `get_comments` dan `get_likes_count` memerlukan `wisata_id` yang didapat dari metadata ChromaDB
- Pastikan data di ChromaDB memiliki metadata `wisata_id` yang valid
- Jika metadata tidak ada, function akan error

⚠️ **Session Context**
- Context metadata hanya berlaku dalam satu session `processQuery()`
- Setiap request baru akan reset metadata context
- Untuk multi-turn conversation, pertimbangkan implementasi session management

💡 **Best Practice**
- Selalu panggil `get_recommendations` atau `get_information` terlebih dahulu
- Biarkan LLM menentukan function mana yang sesuai
- Jangan hardcode wisata_id di query user

---

## Future Improvements

- [ ] Session management untuk multi-turn conversations
- [ ] Caching metadata context
- [ ] Support untuk multiple wisata_id dalam satu request
- [ ] Rate limiting untuk function calls
- [ ] Analytics dan logging untuk function usage

---
