# Analiza titlurilor și a descrierilor meta: `site/`

**Data:** 28.09.2026 · **Pagini:** 16 · **Surse:** `parse_html.py` (extragerea tag-urilor), `metadata_template.py` (verificarea pe tot site-ul) și citirea fiecărei pagini.

## Reguli folosite

| Element | Ce verific | Prag |
|---|---|---|
| `<title>` | lungime | 30–60 de caractere (Google taie la ~580–600 px) |
| | cuvânt-cheie la început | subiectul paginii în primele 3–4 cuvinte |
| | potrivire cu H1 | Google rescrie des titlurile care diferă mult de H1 |
| | brand | un sufix consecvent („\| Get Rates”) |
| `meta description` | lungime | 120–160 de caractere (Google taie la ~920 px pe desktop, mai puțin pe mobil) |
| | unicitate | nicio descriere repetată între pagini |
| | afirmații | fără promisiuni nedovedite („guaranteed”, „up to 80%”) |
| | formă | propoziții complete, fără spații duble, cu punct la final |

Google rescrie oricum o parte din descrieri pe baza căutării. O descriere bună crește totuși rata de click (CTR) atunci când e afișată, iar un titlu prea lung sau nepotrivit cu H1 are șanse mari să fie înlocuit cu un text ales de Google.

## Rezultate pe tot site-ul

| Verificare | Rezultat |
|---|---|
| Titluri unice | ✅ 16/16 |
| Descrieri unice | ✅ 16/16 |
| Titluri/descrieri generate din șablon (`metadata_template.py`) | ✅ 0 din 16, risc „low” |
| Titluri în afara intervalului 30–60 | ⚠️ 4: `grcountries` (24), `services` (20), `404` (26), `best-western-milan` (69) |
| Descrieri în afara intervalului 120–160 | ⚠️ 5: `indexgr` (**259**), `grcountries` (115), `hbrandcr` (119), `about` (101), `contact` (111). Plus `404` (49), acceptabil pentru o pagină 404 |
| Titluri fără sufixul de brand | ⚠️ toate cele 9 pagini live de oraș, țară și brand. Doar homepage-urile îl au |
| Descrieri cu promisiuni nedovedite | ❌ 7: `indexgr`, `featured`, `grbrandcountries`, `grcountries`, `crindex`, `hbrandcr`, `psearchescr` |
| Spații duble | ❌ 2 pagini: `nice` (titlu + descriere), `featured` (descriere) |
| Descrieri fără punct final | ⚠️ 3: `nice`, `featured`, `grcountries` |
| Titlu ≠ H1 (subiect sau cifre diferite) | ⚠️ 8 pagini (vezi tabelul de mai jos) |
| Semnal `metadata_template.py` | `services/`: numele mărcii e repetat în descriere („brand_suffix_in_description”) |

### Tipare pe grupuri de pagini

1. **Paginile get-rates** (nice, grcountries, grbrandcountries, featured) **nu au brand în titlu**. În rezultate, utilizatorul nu vede cine e site-ul, iar Google poate adăuga singur „- m.get-rates.com” sau poate rescrie titlul.
2. **Paginile check-rates** folosesc sufixe comerciale diferite de la o pagină la alta: „| Cheap Hotel Deals”, „| Reservations & Deals” sau nimic. Nu există un format stabil.
3. **Descrierile se termină cu promisiuni:**
   - „Best rate guarantee”;
   - „Lowest rate guaranteed”;
   - „save up to 80%”;
   - „Up to 75% off”.

   Nicio pagină nu le susține (vezi [C7 din raportul detaliat](seo-audit-detaliat-2026-09-27.md#c7)).
4. **Moneda e scrisă diferit:** „€15” în titlu și „15 EUR” în H1 pe aceeași pagină (`nice`).
5. **Paginile Get Rates noi** au titluri generice („Practical Services”, „Free Consultation”) care nu spun că site-ul compară prețuri la hoteluri.

---

## Analiza pe fiecare pagină

Pentru fiecare pagină: textul actual, problemele și o propunere. Propunerile folosesc doar cifre care apar deja pe pagină. Acolo unde pagina se contrazice, am ales cifra din blocul principal și am notat asta.

### Pagini live get-rates.com

#### 1. `indexgr.html`: homepage

| | Actual | Lungime |
|---|---|---|
| Titlu | Get-Rates.com: Search. Compare. Save time & money! | 50 ✅ |
| Descriere | Up to 75% off on your hotel deal. Discount on over 850k hotels, bed & breakfasts, inns, guest houses, hostels and apartments available in more than 50k destinations. Compare last minute deals from hundreds of travel websites and hotel chains around the world. | **259** ❌ |
| H1 | Search all hotel deals, in one place. | |

**Titlu:**
- Nu conține „hotel”. Nimeni nu caută „Search. Compare. Save time & money”, așa că titlul nu se potrivește cu nicio căutare reală.
- Brandul e la început. Pentru homepage e acceptabil, dar subiectul („hotel prices”) lipsește complet.

**Descriere:**
- Are 259 de caractere, iar Google o taie după „…available in more”.
- Începe cu „Up to 75% off”, o promisiune pe care pagina nu o susține.
- „850k hotels” contrazice textul paginii („Over 4,500,000 hotel deals”).

**Propunere**
- Titlu: `Compare Hotel Prices from 100+ Sites | Get Rates`
- Descriere: `Compare hotel prices from Booking.com, Expedia, Agoda and 100+ travel sites in one search. 850,000+ hotels in 50,000 destinations worldwide.`

---

#### 2. `nice.html`: Nice

| | Actual | Lungime |
|---|---|---|
| Titlu | Nice Accommodation␣␣from €15 \| Compare Stays in France | 54 ✅ |
| Descriere | Compare 1,300+ apartments, hotels and b&bs in Nice, France. Accommodation␣␣from €15 a night at Hotel Altair Nice. Search major booking sites at once | 148 ✅ |
| H1 | Compare Hotel rates in Nice from 15 EUR | |

**Titlu:**
- Are două spații între „Accommodation” și „from”.
- „Compare Stays in France” e prea vag. Cine caută Nice știe deja că e în Franța, iar spațiul poate fi folosit mai bine.
- Moneda diferă de H1 („€15” față de „15 EUR”).
- Prețul „€15” e fix în titlu. Textul paginii spune că prețul minim e **11 EUR**, deci titlul e deja învechit.

**Descriere:**
- Spațiu dublu, lipsește punctul final, „b&bs” e scris cu minuscule.
- „1,300+” diferă de „1,354” din pagină. E corect ca rotunjire, dar poate fi folosită cifra exactă.
- Numele hostelului cu cel mai mic preț (Hotel Altair) nu ajută la click și nu se potrivește cu intenția de căutare („hotels in Nice”).

**Propunere**
- Titlu: `Hotels in Nice from €11: Compare Prices | Get Rates`
- Descriere: `Compare 1,354 hotels, apartments and B&Bs in Nice. Average €88 a night, from €11. See prices from Booking.com, Agoda and more in one search.`
- **Condiție:** prețul minim din titlu trebuie generat din aceeași sursă ca textul, altfel se învechește din nou.

---

#### 3. `featured.html`: Lepante, Nice

| | Actual | Lungime |
|---|---|---|
| Titlu | Hotels Around the Lepante Neighborhood, Nice | 44 ✅ |
| Descriere | Compare prices on hotels within a 4.9 km (3 mi) radius of the␣␣Lepante Neighborhood in Nice. Search major booking sites at once. Best rate guarantee | 148 ✅ |
| H1 | Cheap hotels near Lepante Neighborhood Hotels | |

**Titlu:**
- E cel mai bun titlu dintre paginile live: clar, cu locul și orașul. Lipsesc doar brandul și un verb de acțiune.
- **H1-ul nu se potrivește cu titlul:** „Cheap … Hotels” repetă cuvântul „Hotels”.

**Descriere:**
- Spațiu dublu („of the␣␣Lepante”).
- Se termină cu „Best rate guarantee” fără punct.
- **„4.9 km radius”** nu corespunde paginii: toate hotelurile afișate sunt la 0,1–0,4 km. Pe o rază de 4,9 km intră aproape tot orașul Nice, deci pagina nu mai spune nimic specific despre Lepante.

**Propunere**
- Titlu: `Hotels near Lepante, Nice: Compare Prices | Get Rates`
- Descriere: `Compare prices on 12 hotels within 400 m of the Lepante district in central Nice, walking distance to the Promenade. Rooms from €39 a night.`
- **Notă:** „walking distance to the Promenade” vine din descrierile hotelurilor (Star Hotel: „10 minutes walk from the old town and the famous Promenade des Anglais”). Dacă vrei doar cifre, șterge fragmentul.

---

#### 4. `grcountries.html`: Franța

| | Actual | Lungime |
|---|---|---|
| Titlu | Places to stay in France | **24** ⚠️ |
| Descriere | France hotels, apartments, B&Bs and resorts. Browse travel destinations and find accommodation near top attractions | **115** ⚠️ |
| H1 | Compare prices on Hotels in France | |

**Titlu:**
- Are 24 de caractere și folosește mai puțin de jumătate din spațiul disponibil.
- Nu conține „hotels”, cuvântul pe care îl conține H1-ul și pe care îl caută oamenii („hotels in France”).
- Nu are cifre și nici brand.

**Descriere:**
- E scurtă, fără punct final, fără cifre și fără beneficiu. „Browse travel destinations” e o formulare generică.

**Propunere**
- Titlu: `Hotels in France: Compare 62,483 Places to Stay | Get Rates`
- Descriere: `Compare prices on 62,483 hotels, apartments and B&Bs in France, from Paris and Nice to Chamonix. Search Booking.com, Agoda and more at once.`

---

#### 5. `grbrandcountries.html`: Best Western în Franța

| | Actual | Lungime |
|---|---|---|
| Titlu | 279+ Best Western Hotels in France | 34 ✅ |
| Descriere | Browse deals on 279 Best Western Hotels locations in France with our best rate guarantee. Compare options across major booking sites. | 133 ✅ |
| H1 | Compare prices on Best Western Hotels in France (+ al doilea H1: „…in France, France”) | |

**Titlu:**
- Formatul e bun: cifra la început atrage atenția.
- **Cifra nu e confirmată de pagină:** ancora spune „27+”, iar orașele listate însumează ~120 de hoteluri. Dacă „279” e greșit, titlul promite ceva ce pagina nu arată.
- Lipsește brandul.

**Descriere:**
- „Best Western Hotels locations” e o formulare stângace.
- „our best rate guarantee” e o promisiune fără pagină de condiții.

**Propunere**
- Titlu: `Best Western Hotels in France: Compare Prices | Get Rates`
- Descriere: `Compare prices on Best Western hotels across France, including Paris, Lyon, Nice and Marseille. See rates from major booking sites in one search.`
- **Condiție:** readaugă cifra în titlu („279 Best Western Hotels in France…”) doar după ce numărul din pagină este verificat.

---

### Pagini live check-rates.com

#### 6. `crindex.html`: homepage

| | Actual | Lungime |
|---|---|---|
| Titlu | Check-Rates.com - Compare Rates for Hotels | 42 ✅ |
| Descriere | Lowest rate guaranteed for cheap apartments, hostels, bed and breakfast, motels, inns and hotels. Discount up to 80% from 1000 booking sites at once. | 149 ✅ |
| H1 | Want to find the lowest rate? | |

**Titlu:**
- E corect ca formă. „Compare Rates for Hotels” e totuși mai puțin natural decât „Compare Hotel Prices”, formularea pe care oamenii o caută.

**Descriere:**
- Conține **două promisiuni nedovedite** („Lowest rate guaranteed”, „Discount up to 80%”).
- **„1000 booking sites”** contrazice pagina („over 100 travel sites”).
- „cheap apartments, hostels, bed and breakfast, motels, inns” e o listă de cuvinte-cheie, nu o propoziție.

**H1:**
- „Want to find the lowest rate?” nu conține „hotel” și nu se potrivește cu titlul.

**Propunere**
- Titlu: `Compare Hotel Prices from 100+ Sites | Check-Rates`
- Descriere: `Compare hotel prices across 100+ booking sites in one search. 800,000+ hotels, apartments and hostels worldwide. Free to use.`

---

#### 7. `croras.html`: Kyoto

| | Actual | Lungime |
|---|---|---|
| Titlu | Kyoto Hotels, Holiday Rentals & Apartments, Japan | 49 ✅ |
| Descriere | Accommodation deals in Kyoto, Japan. Compare hotel websites to get hundreds of options such as hotels, holiday rentals and apartments in one search. | 148 ✅ |
| H1 | **nu există** („Kyoto 741 hotels” e H2) | |

**Titlu:**
- E corect, dar e doar o listă de tipuri de cazare. Nu are cifre, beneficiu sau brand.

**Descriere:**
- E generică. Aceeași structură („Accommodation deals in X. Compare hotel websites to get hundreds of options such as…”) apare și pe `countriescr`, cu alt oraș.
- **„hundreds of options”** e mai slab decât cifra reală de pe pagină (741).
- Nu folosește nimic din datele bune de pe pagină: nota medie 8.7 și prețul minim 2,182 JPY.

**Propunere**
- Titlu: `Kyoto Hotels: Compare 741 Places to Stay | Check-Rates`
- Descriere: `Compare 741 hotels, ryokan inns, apartments and hostels in Kyoto, Japan. Guests rate them 8.7/10 on average. Prices from ¥2,182 a night.`
- **Notă:** pagina afișează 8.7 sus și 8.8 în Overview. Am folosit 8.7. Corectează întâi pagina, apoi alege cifra.

---

#### 8. `hbrandcr.html`: DoubleTree Kyoto

| | Actual | Lungime |
|---|---|---|
| Titlu | Doubletree Hotels in Kyoto \| Cheap Hotel Deals | 46 ✅ |
| Descriere | Find deals on Doubletree hotels and nearby accommodation in Kyoto, for short or extended stays. Lowest rate guaranteed. | **119** ⚠️ |
| H1 | Doubletree␣␣hotels in Kyoto | |

**Titlu:**
- **Numele mărcii e scris greșit:** oficial e „DoubleTree by Hilton”. Cine caută „DoubleTree by Hilton Kyoto” găsește mai bine o pagină cu numele exact.
- **„Cheap Hotel Deals”** nu se potrivește: sunt hoteluri de 4 stele, de la 17.204 JPY pe noapte. Cine dă click așteptând ceva ieftin pleacă imediat de pe pagină.

**Descriere:**
- Nu spune câte hoteluri sunt (2) și nici care sunt.
- „Lowest rate guaranteed” e o promisiune nedovedită.

**Propunere**
- Titlu: `DoubleTree by Hilton Kyoto: Compare Prices | Check-Rates`
- Descriere: `Compare prices at DoubleTree by Hilton Kyoto Station and Kyoto Higashiyama, both rated 8.7+ by guests. Rates from ¥17,204 a night.`
- **Notă:** raportul detaliat recomandă `noindex` pentru paginile brand × oraș cu sub 3 hoteluri. Dacă aplici `noindex`, titlul și descrierea contează mai puțin.

---

#### 9. `psearchescr.html`: Best Western Viena

| | Actual | Lungime |
|---|---|---|
| Titlu | Best Western Hotels Vienna \| Reservations & Deals | 49 ✅ |
| Descriere | Find deals on Best Western hotels in Vienna, for short or extended stays. No hidden fees and easy booking: book today and save up to 80% | 136 ✅ |
| H1 | Best Western Hotels in Vienna | |

**Titlu:**
- Forma e bună. „Reservations & Deals” nu e însă corect: check-rates nu face rezervări, ci trimite utilizatorul pe site-ul de rezervare.

**Descriere:**
- **„No hidden fees”** și **„save up to 80%”** nu pot fi garantate de un comparator. Taxele sunt ale site-ului pe care se face rezervarea.
- **Problema de fond:** 6 din cele 8 hoteluri listate nu mai sunt Best Western. Orice descriere care promite „Best Western hotels in Vienna” e înșelătoare până se corectează lista.

**Propunere** (după curățarea listei)
- Titlu: `Best Western Hotels in Vienna: Compare Prices | Check-Rates`
- Descriere: `Compare prices on Best Western Plus hotels in Vienna, near the Prater and the city centre. Rates from €64 a night across major booking sites.`

---

#### 10. `countriescr.html`: Austria

| | Actual | Lungime |
|---|---|---|
| Titlu | Austria Hotels, Resorts & Apartments | 36 ✅ |
| Descriere | Accommodation deals across Austria. Compare hotel websites to get hundreds of options such as hotels, resorts and apartments in one search. | 139 ✅ |
| H1 | **nu există** | |

**Titlu:**
- E corect, dar e o simplă listă de tipuri de cazare. Nu are cifre și nici brand.

**Descriere:**
- E același șablon ca la Kyoto, cu altă țară.
- „hundreds of options” subestimează pagina, care are **5.963**.

**Propunere**
- Titlu: `Austria Hotels: Compare 5,963 Places to Stay | Check-Rates`
- Descriere: `Compare 5,963 hotels, apartments and B&Bs in Austria, from Vienna and Salzburg to ski resorts like Sölden and Kitzbühel. Search top booking sites at once.`

---

### Pagini Get Rates create de noi

#### 11. `best-western-milan.html`

| | Actual | Lungime |
|---|---|---|
| Titlu | Best Western Milan Hotel Deals \| Compare & Save up to 75% \| Get Rates | **69** ⚠️ |
| Descriere | Compare Best Western Milan rates on Booking.com, Expedia and Hotels.com in one search. Find hotel deals in Milan near Centrale and Corso Buenos Aires. | 150 ✅ |
| H1 | Best Western Milan: Compare Hotel Deals and Rates | |

**Titlu:**
- Are 69 de caractere, deci „| Get Rates” va fi tăiat.
- Are două separatoare „|”.
- „Save up to 75%” nu e susținut de pagină: tabelul arată diferențe de 4–8%.

**Descriere:**
- ✅ **Cea mai bună descriere din site:** cuvântul-cheie e la început, numește site-urile comparate, include repere concrete (Centrale, Corso Buenos Aires) și nu are promisiuni.

**Propunere**
- Titlu: `Best Western Milan: Compare Hotel Deals | Get Rates`
- Descriere: rămâne neschimbată.

---

#### 12. `index.html`

| | Actual | Lungime |
|---|---|---|
| Titlu | Get Rates \| Practical Services, Clearly Explained | 49 ✅ |
| Descriere | Get Rates delivers reliable results with clear pricing, fast responses and practical advice. Explore our services or get in touch today. | 136 ✅ |

**Probleme:**
- Lungimile sunt corecte, dar **conținutul nu descrie ce e Get Rates**.
- „Practical Services”, „practical advice” și „fast responses” vin din scheletul generic. Nimeni nu caută așa ceva, iar titlul nu spune nici că e vorba de hoteluri, nici că se compară prețuri.

**Propunere**
- Titlu: `Get Rates: Compare Hotel Prices in One Search`
- Descriere: `Get Rates compares hotel prices from Booking.com, Expedia, Hotels.com and more, so you can see the best available rate for your dates in one search.`

---

#### 13. `about/index.html`

| | Actual | Lungime |
|---|---|---|
| Titlu | About Get Rates \| Who We Are and How We Work | 44 ✅ |
| Descriere | Learn who Get Rates is, the principles behind our work and what you can expect when you work with us. | **101** ⚠️ |

**Probleme:**
- Formatul e corect. „when you work with us” sugerează o agenție, nu un comparator.
- Descrierea e scurtă și nu dă niciun motiv concret pentru click.

**Propunere**
- Titlu: `About Get Rates: How Our Hotel Price Comparison Works`
- Descriere: `Who runs Get Rates, where our hotel prices come from and how we earn money. Learn how we compare rates across booking sites to show you the full picture.`

---

#### 14. `contact/index.html`

| | Actual | Lungime |
|---|---|---|
| Titlu | Contact Get Rates \| Get a Free Consultation | 43 ✅ |
| Descriere | Contact Get Rates for a free consultation and written quote. We reply to every enquiry within one business day. | **111** ⚠️ |

**Probleme:**
- „Free Consultation” și „written quote” nu corespund unui comparator de hoteluri.
- „within one business day” e o promisiune. Păstreaz-o doar dacă o poți respecta.

**Propunere**
- Titlu: `Contact Get Rates | Help with Hotel Price Comparison`
- Descriere: `Questions about a hotel price you found on Get Rates, or want to list your property? Contact our team by email. We reply within one business day.`

---

#### 15. `services/index.html`

| | Actual | Lungime |
|---|---|---|
| Titlu | Services \| Get Rates | **20** ⚠️ |
| Descriere | Consultation, delivery and ongoing support from Get Rates. See what each service includes, how it works and answers to common questions. | 136 ✅ |

**Probleme:**
- Titlul are 20 de caractere, iar „Services” nu corespunde niciunei căutări.
- `metadata_template.py` semnalează că brandul „Get Rates” e repetat în descriere, deși e deja în titlu.
- Serviciile descrise (consultanță, livrare) nu corespund produsului.

**Propunere**
- Titlu: `How Get Rates Works: Compare Hotel Prices in One Search`
- Descriere: `Search once and compare hotel prices from multiple booking sites. See how we collect rates, how often they update and how to get weekly deals by email.`

---

#### 16. `404.html`

| | Actual | Lungime |
|---|---|---|
| Titlu | Page Not Found \| Get Rates | 26 ✅ |
| Descriere | The page you were looking for could not be found. | 49 ✅ |

✅ **Rămâne neschimbată.** Pagina e `noindex`, deci titlul și descrierea nu apar în rezultate. Lungimile scurte sunt corecte aici.

---

## Titlu față de H1

Google folosește adesea H1-ul când rescrie un titlu. Cu cât cele două spun același lucru, cu atât e mai probabil ca titlul tău să fie afișat.

| Pagină | Titlu | H1 | Se potrivesc? |
|---|---|---|---|
| indexgr | Search. Compare. Save time & money! | Search all hotel deals, in one place. | ⚠️ parțial, niciunul nu spune „hotel prices” |
| nice | Nice Accommodation from €15 | Compare Hotel rates in Nice from 15 EUR | ⚠️ monedă diferită |
| featured | Hotels Around the Lepante Neighborhood | Cheap hotels near Lepante Neighborhood Hotels | ⚠️ H1 cu cuvânt repetat |
| grcountries | Places to stay in France | Compare prices on Hotels in France | ⚠️ termeni diferiți |
| grbrandcountries | 279+ Best Western Hotels in France | 2 × H1 | ❌ |
| crindex | Compare Rates for Hotels | Want to find the lowest rate? | ❌ |
| croras | Kyoto Hotels, Holiday Rentals & Apartments | (lipsește) | ❌ |
| hbrandcr | Doubletree Hotels in Kyoto | Doubletree hotels in Kyoto | ✅ (brand greșit în ambele) |
| psearchescr | Best Western Hotels Vienna | Best Western Hotels in Vienna | ✅ |
| countriescr | Austria Hotels, Resorts & Apartments | (lipsește) | ❌ |
| best-western-milan | Best Western Milan Hotel Deals | Best Western Milan: Compare Hotel Deals and Rates | ✅ |
| index / about / contact / services | … | … | ✅ ca formă, dar conținutul e generic |

## Format recomandat pentru șabloane

Pentru paginile generate automat, un singur format pe tip de pagină:

| Tip de pagină | Titlu | Descriere |
|---|---|---|
| Oraș | `Hotels in {Oraș} from {€min}: Compare Prices \| {Brand}` | `Compare {N} hotels, apartments and B&Bs in {Oraș}. Average {€avg} a night, from {€min}. See prices from {Site1}, {Site2} and more in one search.` |
| Țară | `Hotels in {Țară}: Compare {N} Places to Stay \| {Brand}` | `Compare prices on {N} hotels, apartments and B&Bs in {Țară}, from {Oraș1} and {Oraș2} to {Oraș3}. Search {Site1}, {Site2} and more at once.` |
| Brand × loc | `{Brand hotel oficial} {Loc}: Compare Prices \| {Brand}` | `Compare prices on {N} {Brand hotel} hotels in {Loc}, including {Hotel1} and {Hotel2}. Rates from {€min} a night across major booking sites.` |
| POI | `Hotels near {POI}, {Oraș}: Compare Prices \| {Brand}` | `Compare prices on {N} hotels within {rază} of {POI} in {Oraș}. Rooms from {€min} a night.` |

**Reguli pentru generator:**
- Taie la 60 de caractere pentru titlu și 155 pentru descriere, la final de cuvânt.
- Elimină spațiile duble. Pune punct la finalul descrierii.
- `{€min}` și `{N}` vin din aceeași interogare ca textul paginii, ca să nu apară din nou nepotriviri de tipul „€15” / „11 EUR”.
- Nu folosi cuvinte ca „guaranteed”, „lowest”, „up to X%” sau „no hidden fees”.
- Scrie numele oficial al mărcilor hoteliere („DoubleTree by Hilton”, nu „Doubletree”).
