# Audit SEO pe pagini: `site/`

Data: 2026-09-27 · Unelte: claude-seo v2.4.0 (`parse_html.py`, `content_quality.py`) + analizor static pe fiecare pagină · 16 fișiere HTML

## Metodologie

- Scor 0–100 calculat pe categoriile claude-seo: Tehnic 22, Conținut 23, On-page 20, Performanță 10, Pregătire AI 10, Imagini 5.
- **Schema/JSON-LD (10%) este exclusă intenționat.** Ai cerut eliminarea ei, așa că scorul e normalizat pe 90 de puncte.
- **Analiza este statică**, pe fișierele locale. Nu am putut măsura live Core Web Vitals, redirecturile, codurile HTTP sau robots.txt de pe domeniile reale, pentru că proxy-ul containerului blochează get-rates.com. Scorul de performanță este o estimare: scripturi blocante, dimensiuni imagini, mărime HTML.
- „Cuvinte în zona principală” exclude meniurile, footer-ul, formularele și listele de navigare.
- Paginile check-rates și get-rates „live” sunt copii exacte ale surselor trimise de tine. Resursele relative (CSS, JS, imagini) nu există local.

## Rezumat

| # | Pagină | Tip | Scor | Titlu (car.) | Meta desc. (car.) | H1 | Canonical | Cuvinte | Probleme Critic/Ridicat/Mediu |
|---|---|---|---|---|---|---|---|---|---|
| 1 | `site/best-western-milan.html` | Get Rates (landing) | 🟢 **94** | 69 | 150 | 1 | ✅ | 900 | 0/0/2 |
| 2 | `site/about/index.html` | Get Rates (nou) | 🟢 **86** | 44 | 101 | 1 | ✅ | 111 | 0/1/0 |
| 3 | `site/contact/index.html` | Get Rates (nou) | 🟢 **86** | 43 | 111 | 1 | ✅ | 73 | 0/1/0 |
| 4 | `site/index.html` | Get Rates (nou) | 🟢 **86** | 49 | 136 | 1 | ✅ | 135 | 0/1/0 |
| 5 | `site/services/index.html` | Get Rates (nou) | 🟢 **83** | 20 | 136 | 1 | ✅ | 165 | 0/1/1 |
| 6 | `site/404.html` | Get Rates (nou) | 🟡 **70** | 26 | 49 | 1 | ❌ | 26 | 0/0/2 |
| 7 | `site/featured.html` | get-rates (live) | 🟡 **63** | 44 | 148 | 1 | ❌ | 925 | 0/1/9 |
| 8 | `site/nice.html` | get-rates (live) | 🟡 **63** | 54 | 148 | 1 | ❌ | 1614 | 0/1/9 |
| 9 | `site/crindex.html` | check-rates (live) | 🟡 **62** | 42 | 149 | 1 | ❌ | 570 | 0/1/8 |
| 10 | `site/hbrandcr.html` | check-rates (live) | 🟡 **62** | 46 | 119 | 1 | ❌ | 1115 | 0/1/8 |
| 11 | `site/psearchescr.html` | check-rates (live) | 🟡 **62** | 49 | 136 | 1 | ❌ | 1388 | 0/1/8 |
| 12 | `site/grcountries.html` | get-rates (live) | 🟡 **61** | 24 | 115 | 1 | ❌ | 1318 | 0/2/10 |
| 13 | `site/croras.html` | check-rates (live) | 🟡 **60** | 49 | 148 | 0 | ❌ | 1628 | 0/2/8 |
| 14 | `site/grbrandcountries.html` | get-rates (live) | 🔴 **58** | 34 | 133 | 2 | ❌ | 716 | 0/2/9 |
| 15 | `site/countriescr.html` | check-rates (live) | 🔴 **57** | 36 | 139 | 0 | ❌ | 934 | 1/2/8 |
| 16 | `site/indexgr.html` | get-rates (live) | 🔴 **53** | 50 | 259 | 1 | ❌ | 131 | 0/2/7 |

**Medie pagini live (get-rates + check-rates): 60/100** · **Medie pagini Get Rates noi: 84/100**

### Probleme comune tuturor celor 10 pagini live

1. **Niciuna nu are `rel=canonical`.** Vor exista versiuni `m.` și desktop, parametri de URL și duplicate de POI. *(Ridicat)*
2. **Ierarhia de titluri e ruptă.** Șablonul pune H3-uri de meniu/popup înaintea H1, iar două pagini (croras, countriescr) nu au deloc H1. *(Ridicat/Mediu)*
3. **Linkuri `javascript:void(0)`.** Sunt între 8 și 45 pe pagină, iar hotelurile listate nu pot fi urmărite de crawler. *(Mediu)*
4. **Analytics mort.** `_gaq.push()` (Universal Analytics a fost retras) și `ga('send')` fără biblioteca încărcată produc erori JS la click. *(Mediu)*
5. **jQuery 1.4.2 / YUI și scripturi blocante în `<head>`.** Cresc timpul până la primul conținut vizibil și au vulnerabilități cunoscute. *(Mediu)*
6. **Afirmații neverificabile** („Guaranteed”, „up to 75%”, „best rate guarantee”). Sunt un risc pentru încrederea utilizatorilor și, în UE, pentru legislația de protecție a consumatorului. *(Mediu)*
7. **Blocul „Different ways to stay in United Kingdom”** apare pe pagini despre Franța. *(Ridicat pe paginile afectate)*
8. **HTML invalid.** Există ID-uri duplicate, ID-uri doar numerice, `<div>` în `<ol>` și tag-uri neînchise. Nu e folosit niciun element semantic HTML5 (`main`, `nav`, `header`). *(Scăzut, dar afectează agenții AI și accesibilitatea)*
9. **Imagini fără `width`/`height`** (risc CLS) și AddThis pe paginile check-rates (serviciu închis). *(Mediu/Scăzut)*

---

## Rapoarte pe pagină

### 🟢 `site/best-western-milan.html`: 94/100

*Get Rates (landing) · 184 linii · 11 KB · 11 linkuri · 0 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 22/22 |
| Conținut | 20/23 |
| On-page | 18/20 |
| Performanță (estimat static) | 10/10 |
| Pregătire AI | 10/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (69 car.): `Best Western Milan Hotel Deals | Compare & Save up to 75% | Get Rates`
- Meta description (150 car.): `Compare Best Western Milan rates on Booking.com, Expedia and Hotels.com in one search. Find hotel deals in Milan near Centrale and Corso Buenos Aires.`
- Canonical: `https://get-rates.com/best-western-milan.html` · Robots: `index, follow, max-snippet:-1, max-image-preview:large` · lang: `en` · viewport: da · OG tags: 10
- Cuvinte: 900 în zona principală / 931 vizibile în total

**Structura titlurilor**

```
H1: Best Western Milan: Compare Hotel Deals and Rates
  H2: Where to stay: top Best Western hotels in Milan
  H2: Compare Milan hotel rates across booking sites
  H2: How to find the best hotel deals in Milan
  H2: Best Western Milan: frequently asked questions
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Mediu | Titlu de 69 caractere (recomandat 30–60) — poate fi trunchiat în SERP |
| Mediu | „Save up to 75%” în titlu — afirmație neverificabilă |
| Verificare manuală | Cea mai bună pagină din site: H1 unic, ierarhie H2 logică, rezumat citabil pentru AI, tabel comparativ, FAQ. |
| Verificare manuală | Tabelul de prețuri este marcat ca ilustrativ. Dacă ajunge în producție, trebuie alimentat cu date reale, altfel devine o afirmație falsă. |

### 🟢 `site/about/index.html`: 86/100

*Get Rates (nou) · 95 linii · 3 KB · 12 linkuri · 0 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 22/22 |
| Conținut | 14/23 |
| On-page | 20/20 |
| Performanță (estimat static) | 10/10 |
| Pregătire AI | 6/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (44 car.): `About Get Rates | Who We Are and How We Work`
- Meta description (101 car.): `Learn who Get Rates is, the principles behind our work and what you can expect when you work with us.`
- Canonical: `https://get-rates.com/about/` · Robots: `index, follow, max-image-preview:large` · lang: `en` · viewport: da · OG tags: 10
- Cuvinte: 111 în zona principală / 131 vizibile în total

**Structura titlurilor**

```
H1: About Get Rates
  H2: How we work
    H3: Clarity first
    H3: Respect for your time
    H3: Easy to reach
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Conținut subțire: ~111 cuvinte în zona principală |
| Verificare manuală | Tehnic curat. Textul (~110 cuvinte) nu spune cine operează site-ul, de când și cum sunt obținute tarifele. Pentru E-E-A-T lipsesc aceste semnale de încredere. |

### 🟢 `site/contact/index.html`: 86/100

*Get Rates (nou) · 86 linii · 3 KB · 10 linkuri · 0 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 22/22 |
| Conținut | 14/23 |
| On-page | 20/20 |
| Performanță (estimat static) | 10/10 |
| Pregătire AI | 6/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (43 car.): `Contact Get Rates | Get a Free Consultation`
- Meta description (111 car.): `Contact Get Rates for a free consultation and written quote. We reply to every enquiry within one business day.`
- Canonical: `https://get-rates.com/contact/` · Robots: `index, follow, max-image-preview:large` · lang: `en` · viewport: da · OG tags: 10
- Cuvinte: 73 în zona principală / 93 vizibile în total

**Structura titlurilor**

```
H1: Contact Get Rates
  H2: What happens after you get in touch
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Conținut subțire: ~73 cuvinte în zona principală |
| Verificare manuală | Nu există adresă, e-mail sau entitate juridică. Pentru un comparator de prețuri, lipsa acestor date e un semnal slab de încredere. |

### 🟢 `site/index.html`: 86/100

*Get Rates (nou) · 102 linii · 4 KB · 14 linkuri · 0 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 22/22 |
| Conținut | 14/23 |
| On-page | 20/20 |
| Performanță (estimat static) | 10/10 |
| Pregătire AI | 6/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (49 car.): `Get Rates | Practical Services, Clearly Explained`
- Meta description (136 car.): `Get Rates delivers reliable results with clear pricing, fast responses and practical advice. Explore our services or get in touch today.`
- Canonical: `https://get-rates.com/` · Robots: `index, follow, max-image-preview:large` · lang: `en` · viewport: da · OG tags: 10
- Cuvinte: 135 în zona principală / 157 vizibile în total

**Structura titlurilor**

```
H1: Practical services, clearly explained
  H2: What we do
    H3: Consultation
    H3: Delivery
    H3: Support
  H2: Why customers choose Get Rates
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Conținut subțire: ~135 cuvinte în zona principală |
| Verificare manuală | Pagina de start a site-ului Get Rates creat de noi: structură curată, canonical, OG, fără erori tehnice. |
| Verificare manuală | Singura problemă reală: textul e scurt (~135 cuvinte) și generic („Practical services”), nu vorbește despre compararea tarifelor hoteliere, deci nu se potrivește cu restul paginilor. |

### 🟢 `site/services/index.html`: 83/100

*Get Rates (nou) · 108 linii · 4 KB · 12 linkuri · 0 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 22/22 |
| Conținut | 14/23 |
| On-page | 18/20 |
| Performanță (estimat static) | 10/10 |
| Pregătire AI | 6/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (20 car.): `Services | Get Rates`
- Meta description (136 car.): `Consultation, delivery and ongoing support from Get Rates. See what each service includes, how it works and answers to common questions.`
- Canonical: `https://get-rates.com/services/` · Robots: `index, follow, max-image-preview:large` · lang: `en` · viewport: da · OG tags: 10
- Cuvinte: 165 în zona principală / 185 vizibile în total

**Structura titlurilor**

```
H1: Our services
  H2: Consultation
  H2: Delivery
  H2: Support
  H2: Frequently asked questions
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Conținut subțire: ~165 cuvinte în zona principală |
| Mediu | Titlu de 20 caractere (recomandat 30–60) |
| Verificare manuală | Titlul „Services | Get Rates” are doar 20 de caractere și nu conține niciun cuvânt-cheie. |

### 🟡 `site/404.html`: 70/100

*Get Rates (nou) · 37 linii · 1 KB · 6 linkuri · 0 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 14/22 |
| Conținut | 14/23 |
| On-page | 16/20 |
| Performanță (estimat static) | 10/10 |
| Pregătire AI | 4/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (26 car.): `Page Not Found | Get Rates`
- Meta description (49 car.): `The page you were looking for could not be found.`
- Canonical: ❌ lipsește · Robots: `noindex, follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 26 în zona principală / 32 vizibile în total

**Structura titlurilor**

```
H1: Page not found
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Info | Fără canonical — normal pentru o pagină 404 |
| Info | Conținut minim — normal pentru o pagină 404 |
| Mediu | Titlu de 26 caractere (recomandat 30–60) |
| Mediu | Meta description de 49 caractere (recomandat 70–160) |
| Info | Pagina este noindex |
| Verificare manuală | Pagina 404 e corectă: noindex + linkuri înapoi spre site. Nu necesită acțiuni. |

### 🟡 `site/featured.html`: 63/100

*get-rates (live) · 735 linii · 52 KB · 134 linkuri · 3 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 9/22 |
| Conținut | 18/23 |
| On-page | 16/20 |
| Performanță (estimat static) | 3/10 |
| Pregătire AI | 6/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (44 car.): `Hotels Around the Lepante Neighborhood, Nice`
- Meta description (148 car.): `Compare prices on hotels within a 4.9 km (3 mi) radius of the  Lepante Neighborhood in Nice. Search major booking sites at once. Best rate guarantee`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 925 în zona principală / 1334 vizibile în total

**Structura titlurilor**

```
H1: Cheap hotels near Lepante Neighborhood Hotels
    H3: Popular destinations this month
    H3: Find Lepante Neighborhood Hotels
    H3: Featured hotels near Lepante Neighborhood
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Mediu | 21 linkuri javascript:void (necrawlabile) |
| Mediu | <div> dezechilibrat: 203 deschise / 202 închise |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | ga('send',…) fără analytics.js → ReferenceError la click |
| Mediu | Cheie Google Maps expusă în sursă (1×) — restricționează după referrer |
| Mediu | jQuery 1.x (vulnerabilități cunoscute, fără suport) |
| Mediu | Afirmații neverificabile: best rate, guarantee, up to 75% |
| Mediu | 4 scripturi blocante în <head> (fără async/defer) |
| Mediu | 2 imagini fără width/height (risc CLS) |
| Scăzut | Ierarhie de titluri cu salturi: H1→H3 (Popular destinations this month) |
| Scăzut | ID-uri doar numerice: 1, 2, 6, 8 |
| Scăzut | 1 elemente non-<li> direct în <ul>/<ol> |
| Scăzut | Comentarii condiționale IE8/IE9 (moarte) |
| Scăzut | Repetitivitate ridicată (scor 31) |
| Scăzut | 127 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Verificare manuală | H1-ul „Cheap hotels near Lepante Neighborhood Hotels” repetă „Hotels” și nu e natural. |
| Verificare manuală | Pagina de POI e aproape identică cu alte pagini POI din Nice, deci e risc de duplicate și doorway pages. |

### 🟡 `site/nice.html`: 63/100

*get-rates (live) · 872 linii · 74 KB · 241 linkuri · 9 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 9/22 |
| Conținut | 19/23 |
| On-page | 16/20 |
| Performanță (estimat static) | 3/10 |
| Pregătire AI | 5/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (54 car.): `Nice Accommodation  from €15 | Compare Stays in France`
- Meta description (148 car.): `Compare 1,300+ apartments, hotels and b&bs in Nice, France. Accommodation  from €15 a night at Hotel Altair Nice. Search major booking sites at once`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 1614 în zona principală / 2023 vizibile în total

**Structura titlurilor**

```
H1: Compare Hotel rates in Nice from 15 EUR
    H3: Popular destinations this month
    H3: Find Hotels in Nice
      H4: Nice
    H3: Recommended for you in Nice
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Mediu | 42 linkuri javascript:void (necrawlabile) |
| Mediu | <div> dezechilibrat: 218 deschise / 217 închise |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | ga('send',…) fără analytics.js → ReferenceError la click |
| Mediu | Cheie Google Maps expusă în sursă (1×) — restricționează după referrer |
| Mediu | jQuery 1.x (vulnerabilități cunoscute, fără suport) |
| Mediu | Afirmații neverificabile: best rate, guarantee, up to 75% |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Mediu | 7 imagini fără width/height (risc CLS) |
| Scăzut | Ierarhie de titluri cu salturi: H1→H3 (Popular destinations this month) |
| Scăzut | ID-uri doar numerice: 1, 2, 6, 8 |
| Scăzut | 1 elemente non-<li> direct în <ul>/<ol> |
| Scăzut | Comentarii condiționale IE8/IE9 (moarte) |
| Scăzut | Text ascuns după „read more” |
| Scăzut | 173 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Verificare manuală | Titlul „Nice Accommodation  from &euro;15” are spațiu dublu și un preț fix care se învechește. |
| Verificare manuală | Text ascuns după „read more”. |

### 🟡 `site/crindex.html`: 62/100

*check-rates (live) · 1071 linii · 69 KB · 153 linkuri · 3 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 11/22 |
| Conținut | 16/23 |
| On-page | 15/20 |
| Performanță (estimat static) | 4/10 |
| Pregătire AI | 6/10 |
| Imagini | 4/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (42 car.): `Check-Rates.com - Compare Rates for Hotels`
- Meta description (149 car.): `Lowest rate guaranteed for cheap apartments, hostels, bed and breakfast, motels, inns and hotels. Discount up to 80% from 1000 booking sites at once.`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 570 în zona principală / 600 vizibile în total

**Structura titlurilor**

```
    H3: Update your property details
    H3: Get Direct Bookings
H1: Want to find the lowest rate?
    H3: Add your destination and let us give you the hotel rates
        H5: Bangkok
        H5: Vienna
        H5: Dubai
        H5: Kyoto
        H5: Cancun
        H5: Hurghada
    H3: Choose your destination
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Mediu | 13 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: 4, 6, in2, label2, out2 |
| Mediu | <div> dezechilibrat: 122 deschise / 123 închise |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | Conținut modest: ~570 cuvinte în zona principală |
| Mediu | Afirmații neverificabile: guarantee |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Mediu | 3 imagini fără width/height (risc CLS) |
| Scăzut | Ierarhie de titluri cu salturi: primul titlu este H3; H1→H3 (Add your destination and let us give you); H3→H5 (Bangkok) |
| Scăzut | ID-uri doar numerice: 30739, 4, 6, 8 |
| Scăzut | Script AddThis (serviciu închis în 2023) |
| Scăzut | 55 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Info | Pagină check-rates (13 referințe) — altă marcă/domeniu |
| Verificare manuală | Homepage-ul check-rates: titlurile încep cu H3 („Update your property details”), sar la H1, apoi la H5 pentru orașe. |
| Verificare manuală | Domeniu diferit (check-rates.com). Dacă ambele site-uri au același conținut, e nevoie de canonical cross-domain sau de conținut diferențiat. |

### 🟡 `site/hbrandcr.html`: 62/100

*check-rates (live) · 878 linii · 63 KB · 133 linkuri · 22 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 11/22 |
| Conținut | 18/23 |
| On-page | 15/20 |
| Performanță (estimat static) | 2/10 |
| Pregătire AI | 6/10 |
| Imagini | 4/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (46 car.): `Doubletree Hotels in Kyoto | Cheap Hotel Deals`
- Meta description (119 car.): `Find deals on Doubletree hotels and nearby accommodation in Kyoto, for short or extended stays. Lowest rate guaranteed.`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 1115 în zona principală / 1251 vizibile în total

**Structura titlurilor**

```
    H3: Update your property details
    H3: Get Direct Bookings
    H3: Search Doubletree hotels in Kyoto
H1: Doubletree hotels in Kyoto
    H3: Featured Doubletree hotels in Kyoto
    H3: Popular hotels in Kyoto
    H3: See how Kyoto hotels rate
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Mediu | 42 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: 4, 6, Rooms, a_aid2, brandId2 |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | Cheie Google Maps expusă în sursă (1×) — restricționează după referrer |
| Mediu | Afirmații neverificabile: guarantee |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Mediu | 21 imagini fără width/height (risc CLS) |
| Mediu | 1 imagini fără atribut alt |
| Scăzut | Ierarhie de titluri cu salturi: primul titlu este H3; H1→H3 (Featured Doubletree hotels in Kyoto) |
| Scăzut | ID-uri doar numerice: 1, 11, 12, 2, 3, 4, 6, 8 |
| Scăzut | Script AddThis (serviciu închis în 2023) |
| Scăzut | Repetitivitate ridicată (scor 30) |
| Scăzut | 196 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Info | Pagină check-rates (60 referințe) — altă marcă/domeniu |
| Verificare manuală | H1-ul „Doubletree hotels in Kyoto” apare abia după trei H3. Numele corect al mărcii este „DoubleTree by Hilton”. |
| Verificare manuală | Pagina de brand × oraș are foarte puține proprietăți DoubleTree, deci e thin content. |

### 🟡 `site/psearchescr.html`: 62/100

*check-rates (live) · 824 linii · 70 KB · 211 linkuri · 20 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 10/22 |
| Conținut | 20/23 |
| On-page | 15/20 |
| Performanță (estimat static) | 1/10 |
| Pregătire AI | 6/10 |
| Imagini | 4/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (49 car.): `Best Western Hotels Vienna | Reservations & Deals`
- Meta description (136 car.): `Find deals on Best Western hotels in Vienna, for short or extended stays. No hidden fees and easy booking: book today and save up to 80%`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 1388 în zona principală / 1525 vizibile în total

**Structura titlurilor**

```
    H3: Update your property details
    H3: Get Direct Bookings
    H3: Find Best Western Hotels in Vienna
H1: Best Western Hotels in Vienna
    H3: Featured Best Western Hotels in Vienna
    H3: Popular hotels in Vienna
    H3: See how Vienna hotels rate
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Mediu | 43 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: 4, 6, Rooms, a_aid2, brandId2 |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | jQuery 1.x (vulnerabilități cunoscute, fără suport) |
| Mediu | Afirmații neverificabile: guarantee |
| Mediu | 5 scripturi blocante în <head> (fără async/defer) |
| Mediu | 19 imagini fără width/height (risc CLS) |
| Mediu | 1 imagini fără atribut alt |
| Scăzut | Ierarhie de titluri cu salturi: primul titlu este H3; H1→H3 (Featured Best Western Hotels in Vienna) |
| Scăzut | ID-uri doar numerice: 1, 11, 12, 2, 3, 4, 6, 8 |
| Scăzut | Script AddThis (serviciu închis în 2023) |
| Scăzut | 184 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Info | Pagină check-rates (137 referințe) — altă marcă/domeniu |
| Verificare manuală | Unele hoteluri listate ca Best Western în Viena nu mai fac parte din lanț. Informația e învechită și poate induce în eroare. |
| Verificare manuală | Are 5 scripturi blocante în <head>, cele mai multe din toate paginile (YUI calendar + jQuery 1.4.2). |

### 🟡 `site/grcountries.html`: 61/100

*get-rates (live) · 667 linii · 51 KB · 268 linkuri · 4 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 8/22 |
| Conținut | 16/23 |
| On-page | 16/20 |
| Performanță (estimat static) | 4/10 |
| Pregătire AI | 6/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (24 car.): `Places to stay in France`
- Meta description (115 car.): `France hotels, apartments, B&Bs and resorts. Browse travel destinations and find accommodation near top attractions`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 1318 în zona principală / 1780 vizibile în total

**Structura titlurilor**

```
H1: Compare prices on Hotels in France
    H3: Popular destinations this month
    H3: Find Hotels in France
    H3: Destinations in France
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Ridicat | Bloc „Different ways to stay in United Kingdom” pe o pagină despre France |
| Mediu | Titlu de 24 caractere (recomandat 30–60) |
| Mediu | 9 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: in3, out3 |
| Mediu | <div> dezechilibrat: 131 deschise / 130 închise |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | ga('send',…) fără analytics.js → ReferenceError la click |
| Mediu | jQuery 1.x (vulnerabilități cunoscute, fără suport) |
| Mediu | Afirmații neverificabile: best rate, cheapest, guarantee, up to 75% |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Mediu | 3 imagini fără width/height (risc CLS) |
| Scăzut | Ierarhie de titluri cu salturi: H1→H3 (Popular destinations this month) |
| Scăzut | ID-uri doar numerice: 1, 2 |
| Scăzut | 1 elemente non-<li> direct în <ul>/<ol> |
| Scăzut | Comentarii condiționale IE8/IE9 (moarte) |
| Scăzut | 73 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Verificare manuală | Pe pagina Franței apar ambele blocuri: „Different ways to stay in France” și „…in United Kingdom”. |
| Verificare manuală | Greșeli în ghid: „If would be alive”, „croisant”, „Pont du Grant”, „Languedos”, „Rome of Wales”, „George Pampidou”, „1oct. 1962”, „Prix de l ~ Arc”. |
| Verificare manuală | Textul ghidului e tăiat în mijlocul cuvântului acolo unde începe „read more”. |
| Verificare manuală | Paris apare cu „5964 Hotels” în listă, dar cu 1709 hoteluri pe card. „1 Retreats” are plural greșit. |
| Verificare manuală | Linkurile folosesc două formate diferite: `Cheap-Hotels-France-…-g20045_` și `Accommodation-…-g50_`. |

### 🟡 `site/croras.html`: 60/100

*check-rates (live) · 905 linii · 73 KB · 187 linkuri · 22 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 11/22 |
| Conținut | 20/23 |
| On-page | 11/20 |
| Performanță (estimat static) | 2/10 |
| Pregătire AI | 6/10 |
| Imagini | 4/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (49 car.): `Kyoto Hotels, Holiday Rentals & Apartments, Japan`
- Meta description (148 car.): `Accommodation deals in Kyoto, Japan. Compare hotel websites to get hundreds of options such as hotels, holiday rentals and apartments in one search.`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 1628 în zona principală / 1763 vizibile în total

**Structura titlurilor**

```
    H3: Update your property details
    H3: Get Direct Bookings
    H3: Find Hotels in Kyoto
  H2: Kyoto 741 hotels
    H3: Featured Hotels in Kyoto
    H3: Hotels in other cities
    H3: Popular hotels in Kyoto
    H3: See how Kyoto hotels rate
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Nu există H1 |
| Ridicat | Lipsește link rel=canonical |
| Mediu | 45 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: 4, 6, Rooms, a_aid2, brandId2 |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | Cheie Google Maps expusă în sursă (1×) — restricționează după referrer |
| Mediu | Afirmații neverificabile: guarantee |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Mediu | 21 imagini fără width/height (risc CLS) |
| Mediu | 1 imagini fără atribut alt |
| Scăzut | Ierarhie de titluri cu salturi: primul titlu este H3 |
| Scăzut | ID-uri doar numerice: 1, 11, 12, 2, 3, 4, 6, 8 |
| Scăzut | Script AddThis (serviciu închis în 2023) |
| Scăzut | 201 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Info | Pagină check-rates (110 referințe) — altă marcă/domeniu |
| Verificare manuală | Nu există H1: „Kyoto 741 hotels” este H2. |
| Verificare manuală | Cheia Google Maps apare în sursă. |

### 🔴 `site/grbrandcountries.html`: 58/100

*get-rates (live) · 571 linii · 51 KB · 282 linkuri · 3 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 8/22 |
| Conținut | 15/23 |
| On-page | 15/20 |
| Performanță (estimat static) | 4/10 |
| Pregătire AI | 5/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (34 car.): `279+ Best Western Hotels in France`
- Meta description (133 car.): `Browse deals on 279 Best Western Hotels locations in France with our best rate guarantee. Compare options across major booking sites.`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 716 în zona principală / 1180 vizibile în total

**Structura titlurilor**

```
H1: Compare prices on Best Western Hotels in France
    H3: Popular destinations this month
H1: Best Western Hotels in France, France
    H3: Find Best Western Hotels in France
    H3: Destinations in France
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Ridicat | Bloc „Different ways to stay in United Kingdom” pe o pagină despre France |
| Mediu | 2 titluri H1 pe pagină |
| Mediu | 8 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: in3, out3, outline_big |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | ga('send',…) fără analytics.js → ReferenceError la click |
| Mediu | jQuery 1.x (vulnerabilități cunoscute, fără suport) |
| Mediu | Afirmații neverificabile: up to 75% |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Mediu | 2 imagini fără width/height (risc CLS) |
| Scăzut | Ierarhie de titluri cu salturi: H1→H3 (Popular destinations this month); H1→H3 (Find Best Western Hotels in France) |
| Scăzut | ID-uri doar numerice: 1, 11, 12, 2 |
| Scăzut | 1 elemente non-<li> direct în <ul>/<ol> |
| Scăzut | <a> dezechilibrat: 282 deschise / 283 închise |
| Scăzut | Comentarii condiționale IE8/IE9 (moarte) |
| Scăzut | Text ascuns după „read more” |
| Scăzut | 90 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Verificare manuală | Două H1 („Compare prices…” și „Best Western Hotels in France, France”). |
| Verificare manuală | Cifre contradictorii: 279+ în titlu, ancora `27+_…`, Paris 56 față de 60, Nice 6 față de 5, Cannes 4 față de 2, Marseille 4 față de 3. |
| Verificare manuală | Textul despre brand spune „best mid-range hotel brand in **Asia**” pe o pagină despre Franța. |
| Verificare manuală | Lanțuri și parteneri învechiți: Starwood, Venere, Etap, All Seasons, Ctrip. |

### 🔴 `site/countriescr.html`: 57/100

*check-rates (live) · 656 linii · 52 KB · 176 linkuri · 23 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 8/22 |
| Conținut | 20/23 |
| On-page | 11/20 |
| Performanță (estimat static) | 2/10 |
| Pregătire AI | 6/10 |
| Imagini | 4/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (36 car.): `Austria Hotels, Resorts & Apartments`
- Meta description (139 car.): `Accommodation deals across Austria. Compare hotel websites to get hundreds of options such as hotels, resorts and apartments in one search.`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 934 în zona principală / 1064 vizibile în total

**Structura titlurilor**

```
    H3: Update your property details
    H3: Get Direct Bookings
    H3: Find Hotels in Austria
    H3: Destinations in Austria
    H3: Austria Overview
    H3: Recently added properties in Austria
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Critic | Eroare de sintaxă JS: `innerHTML = ;` (blochează scriptul) |
| Ridicat | Nu există H1 |
| Ridicat | Lipsește link rel=canonical |
| Mediu | 25 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: 4, 6, Rooms, a_aid2, brandId2 |
| Mediu | <div> dezechilibrat: 164 deschise / 165 închise |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | Afirmații neverificabile: guarantee |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Mediu | 11 imagini fără width/height (risc CLS) |
| Mediu | 1 imagini fără atribut alt |
| Scăzut | Ierarhie de titluri cu salturi: primul titlu este H3 |
| Scăzut | ID-uri doar numerice: 1, 11, 12, 2, 4, 6, 8 |
| Scăzut | Script AddThis (serviciu închis în 2023) |
| Scăzut | 110 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Info | Pagină check-rates (120 referințe) — altă marcă/domeniu |
| Verificare manuală | Eroare JS critică: `odometer.innerHTML = ;` e o eroare de sintaxă. Oprește tot blocul de script, inclusiv contorul. |
| Verificare manuală | Nu există H1. Toate titlurile sunt H3. |

### 🔴 `site/indexgr.html`: 53/100

*get-rates (live) · 466 linii · 26 KB · 126 linkuri · 0 imagini*

| Categorie | Scor |
|---|---|
| Tehnic | 11/22 |
| Conținut | 9/23 |
| On-page | 15/20 |
| Performanță (estimat static) | 6/10 |
| Pregătire AI | 2/10 |
| Imagini | 5/5 |
| Schema (exclusă) | n/a |

**Meta**

- Title (50 car.): `Get-Rates.com: Search. Compare. Save time & money!`
- Meta description (259 car.): `Up to 75% off on your hotel deal. Discount on over 850k hotels, bed & breakfasts, inns, guest houses, hostels and apartments available in more than 50k destinations. Compare last minute deals from hundreds of travel websites and hotel chains around the world.`
- Canonical: ❌ lipsește · Robots: `index,follow` · lang: `en` · viewport: da · OG tags: 0
- Cuvinte: 131 în zona principală / 510 vizibile în total

**Structura titlurilor**

```
  H2: We save you Up to 75% on your hotel deal. Guaranteed
    H3: Popular destinations this month
H1: Search all hotel deals, in one place.
    H3: Find deals in +100 sites in the time it takes to search one
      H4: Recommended places for you View our hand-picked hotel destinations
```

**Erori și observații**

| Severitate | Problemă |
|---|---|
| Ridicat | Lipsește link rel=canonical |
| Ridicat | Conținut subțire: ~131 cuvinte în zona principală |
| Mediu | Meta description de 259 caractere (recomandat 70–160) |
| Mediu | 8 linkuri javascript:void (necrawlabile) |
| Mediu | ID-uri duplicate: in2, out2 |
| Mediu | _gaq.push() fără ga.js încărcat (cod mort / Universal Analytics retras) |
| Mediu | jQuery 1.x (vulnerabilități cunoscute, fără suport) |
| Mediu | Afirmații neverificabile: guarantee, up to 75% |
| Mediu | 2 scripturi blocante în <head> (fără async/defer) |
| Scăzut | Ierarhie de titluri cu salturi: primul titlu este H2; H1→H3 (Find deals in +100 sites in the time it ) |
| Scăzut | ID-uri doar numerice: 826 |
| Scăzut | Comentarii condiționale IE8/IE9 (moarte) |
| Scăzut | Homepage global afișează blocul „Different ways to stay in United Kingdom” |
| Scăzut | Repetitivitate ridicată (scor 32) |
| Scăzut | 70 atribute style inline |
| Scăzut | Niciun element semantic HTML5 (main/nav/header/footer/article) |
| Verificare manuală | Homepage-ul real get-rates: primul titlu din pagină este un H2 („Up to 75%… Guaranteed”), abia apoi vine H1. |
| Verificare manuală | Meta description are 259 de caractere și va fi tăiată în Google. |
| Verificare manuală | Doar ~130 de cuvinte de conținut propriu. Restul sunt formulare și liste de linkuri. |

---

## Plan de acțiune prioritizat

| Prioritate | Acțiune | Pagini | Cum verifici că a funcționat |
|---|---|---|---|
| Critic | Repară `odometer.innerHTML = ;` | countriescr | Consola browserului nu mai arată SyntaxError |
| Ridicat | Adaugă `rel=canonical` auto-referențial (versiunea desktop, fără parametri) | toate cele 10 pagini live | GSC → Inspectare URL: „canonical declarat” = „canonical ales de Google” |
| Ridicat | Un singur H1 la început. Titlurile din meniu/popup devin `<p>`/`<div>` | toate paginile live | Extensia „HeadingsMap” arată H1 → H2 → H3 fără salturi |
| Ridicat | Blocul „Different ways to stay in …” folosește țara paginii | grcountries, grbrandcountries (+ homepage) | Textul blocului se potrivește cu H1-ul |
| Ridicat | Corectează cifrele contradictorii și textul „Asia” | grbrandcountries, grcountries | Numărul din titlu = suma din listă |
| Mediu | Înlocuiește `javascript:void(0)` cu `<a href>` reale spre paginile hotelurilor | toate paginile live | Screaming Frog găsește paginile de hotel prin crawl |
| Mediu | Scoate `_gaq`/`ga()` și păstrează doar GA4 `gtag` | toate paginile live | Zero erori JS în consolă la click pe butoane |
| Mediu | Elimină „Guaranteed”/„up to 75%” sau leagă-le de o metodologie publicată | toate paginile live + best-western-milan | Nu mai apar în text/meta |
| Mediu | Scurtează meta description la ≤160 de caractere | indexgr | Snippetul din Google nu e tăiat |
| Mediu | Restricționează cheile Maps după HTTP referrer | nice, featured, croras, hbrandcr | Google Cloud Console → cheie cu restricții |
| Mediu | Adaugă `width`/`height` și `loading=lazy` pe imaginile de sub fold | toate paginile live | CLS < 0,1 în PageSpeed |
| Scăzut | Elimină AddThis, comentariile IE și jQuery 1.4.2 | paginile check-rates + get-rates | Mai puține cereri în Network tab |
| Scăzut | Extinde textul paginilor Get Rates noi (about/contact/services) cu date despre operator și metodologie | about, contact, services, index | >300 de cuvinte, entitate juridică vizibilă |
