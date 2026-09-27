# Audit SEO detaliat pe fiecare pagină: `site/`

**Data:** 27.09.2026 · **Pagini analizate:** 16 · **Complement la:** [`seo-audit-site-2026-09-27.md`](seo-audit-site-2026-09-27.md) (scoruri și tabel sumar)

## Cum am făcut auditul

Pe fiecare fișier am rulat scripturile claude-seo care lucrează pe fișiere locale:

| Script | Ce verifică |
|---|---|
| `parse_html.py` | titlu, meta description, robots, canonical, titluri H1–H6, imagini, linkuri, schema, Open Graph, Twitter Cards, hreflang, număr de cuvinte |
| `content_quality.py` | scor de calitate a conținutului (0–100), text de umplutură, tipare AI, repetiție |
| `content_verify.py` | afirmații numerice („4,278 reviews”, „800,000 offers”) și dacă au sursă |
| `metadata_template.py` | pe tot site-ul: titluri și descrieri generate din șablon |

Apoi am citit codul și textul vizibil al fiecărei pagini, pentru verificările pe care scripturile nu le acoperă:
- breadcrumb și HTML invalid;
- linkuri `javascript:`;
- scripturi încărcate de două ori;
- tracking;
- formulare și accesibilitate;
- greșeli de conținut;
- date contradictorii.

Constatările marcate **(manual)** vin din citirea codului. Cele marcate **(script)** vin din rezultatele scripturilor.

**Ce nu acoperă auditul:** Lucrez pe fișiere salvate, nu pe site-urile live. Proxy-ul containerului blochează get-rates.com și check-rates.com, așa că nu am putut verifica:
- headerele HTTP și codurile de răspuns;
- redirecționările;
- `robots.txt` de pe domeniile reale;
- Core Web Vitals;
- randarea JavaScript;
- dacă paginile spre care duc linkurile există.

**Rezultate fals-pozitive eliminate:**
- `content_verify.py` a raportat procente ca „2760%” și „27%” pe paginile check-rates. Sunt lățimi CSS, nu afirmații, așa că le-am ignorat.
- `metadata_template.py` nu a găsit titluri sau descrieri generate din șablon pe niciuna dintre cele 16 pagini (risc „low” pe tot site-ul). Singura observație a fost la `services/`.

---

## Cuprins

**Probleme comune (explicate o singură dată, cu soluția completă)**
- [C1. Lipsește canonical și conținutul e împărțit între `m.` și desktop](#c1)
- [C2. Linkuri `javascript:void(0)`](#c2)
- [C3. Tracking vechi: `_gaq.push` și `ga('send')`](#c3)
- [C4. jQuery 1.4.2, scripturi blocante și DatePicker încărcat de două ori](#c4)
- [C5. Risc XSS la formularul de abonare](#c5)
- [C6. Filtrul de stele: 5 checkbox-uri cu același `name="star2"`](#c6)
- [C7. Afirmații comerciale fără dovadă](#c7)
- [C8. Tag-uri inutile sau lipsă în `<head>`](#c8)
- [C9. Accesibilitate: câmpuri fără etichetă, imagini cu alt greșit](#c9)

**Pagini live get-rates.com**
1. [`indexgr.html`: homepage get-rates](#p-indexgr)
2. [`nice.html`: Nice, orașul](#p-nice)
3. [`featured.html`: POI „Lepante Neighborhood”, Nice](#p-featured)
4. [`grcountries.html`: Franța, țara](#p-grcountries)
5. [`grbrandcountries.html`: Best Western în Franța](#p-grbrandcountries)

**Pagini live check-rates.com**

6. [`crindex.html`: homepage check-rates](#p-crindex)
7. [`croras.html`: Kyoto, orașul](#p-croras)
8. [`hbrandcr.html`: DoubleTree în Kyoto](#p-hbrandcr)
9. [`psearchescr.html`: Best Western în Viena](#p-psearchescr)
10. [`countriescr.html`: Austria, țara](#p-countriescr)

**Pagini Get Rates create de noi**

11. [`best-western-milan.html`](#p-milan)
12. [`index.html`](#p-index)
13. [`about/index.html`](#p-about)
14. [`contact/index.html`](#p-contact)
15. [`services/index.html`](#p-services)
16. [`404.html`](#p-404)

[Plan de acțiune pe tot site-ul](#plan)

---

## Probleme comune

Aceste probleme apar pe mai multe pagini. Le explic aici o singură dată, împreună cu soluția. La fiecare pagină notez doar **câte** apariții are și unde.

<a id="c1"></a>
### C1. Lipsește canonical și conținutul e împărțit între `m.` și desktop

**Pagini:** toate cele 10 pagini live.

**Ce se întâmplă**
- Paginile get-rates sunt versiunea de mobil: logo-ul e „m.get-rates.com”, iar în subsol există un link „Desktop” spre URL-ul fără `m.`.
- Linkurile interne sunt amestecate. Unele sunt relative (se rezolvă pe hostul curent), altele sunt absolute spre `https://m.get-rates.com/...`.
- Paginile check-rates fac același lucru cu `m.check-rates.com` și `check-rates.com`.
- Niciuna nu are `<link rel="canonical">` și nici `rel="alternate"` între versiunea de mobil și cea desktop.

**De ce contează**
- Google vede două URL-uri cu același conținut și alege singur pe care îl indexează.
- Semnalele (linkuri, clickuri) se împart între două hosturi.
- Paginile cu parametri (`?checkin=…`) pot ajunge și ele în index.

**Soluția**

Pe versiunea de mobil (`m.`):
```html
<link rel="canonical" href="https://get-rates.com/Accommodation-Nice-g50_2016.html">
```
Pe versiunea desktop:
```html
<link rel="alternate" media="only screen and (max-width: 640px)"
      href="https://m.get-rates.com/Accommodation-Nice-g50_2016.html">
```

Varianta recomandată pe termen lung este o singură versiune responsive, cu redirect 301 de la `m.` la domeniul principal.

<a id="c2"></a>
### C2. Linkuri `javascript:void(0)`

**Pagini:** toate cele 10 pagini live. Sunt între 8 și 45 pe pagină.

**Ce se întâmplă**
- Numele hotelurilor, prețurile („EUR 133”, „JPY 19,196”), „All properties in …” și „Additional search options” sunt `<a href="javascript:void(0)" onclick="…">`.

**De ce contează**
- Googlebot nu execută `onclick` ca să descopere URL-uri. Paginile de hotel nu primesc link intern din paginile de oraș, deci nu primesc autoritate, și pot rămâne neindexate.
- Agenții AI și cititoarele de ecran nu recunosc aceste elemente ca linkuri.

**Soluția**

Păstrează JavaScript-ul, dar adaugă un URL real:
```html
<a href="/Hotel-Negresco-Nice-h12345.html" onclick="openDeal(12345); return false;">Hotel Negresco</a>
```
Pentru elementele care nu duc nicăieri (butoanele de închidere „×”, „all | none”), folosește `<button type="button">` în loc de `<a>`.

<a id="c3"></a>
### C3. Tracking vechi: `_gaq.push` și `ga('send')`

**Pagini:** toate cele 10. Pe paginile check-rates sunt până la 40 de apeluri pe pagină.

**Ce se întâmplă**
- Paginile încarcă doar GA4 (`gtag.js`). În `onclick` se folosesc însă `_gaq.push([...])` (ga.js, retras din 2012) și `ga('send', …)` (Universal Analytics, retras din iulie 2023).
- `ga()` nu e definit nicăieri, așa că fiecare click pe „I don't have specific dates yet” aruncă `ReferenceError`.
- `_gaq` nu dă eroare doar dacă `JScript01.js`/`common.js` îl definește ca array. Chiar și atunci, datele nu ajung nicăieri.

**De ce contează**
- Nu măsori nimic din interacțiuni: căutări, clickuri pe oferte, abonări.
- O eroare JS într-un handler poate opri restul codului din acel handler.

**Soluția**

Înlocuiește toate apelurile vechi cu GA4:
```js
gtag('event', 'search', { method: 'today_deal' });
```
Apoi șterge `_gaq.push(...)` și `ga('send', ...)`.

<a id="c4"></a>
### C4. jQuery 1.4.2, scripturi blocante și DatePicker încărcat de două ori

**Pagini:** toate paginile get-rates, plus `psearchescr.html`.

**Ce se întâmplă**
- **jQuery 1.4.2** e din 2010 și are vulnerabilități XSS cunoscute (CVE-2011-4969, CVE-2012-6708, CVE-2015-9251, CVE-2019-11358, CVE-2020-11022/11023).
- `JScript01.js`, `common.js` și jQuery se încarcă în `<head>` fără `defer`, deci browserul oprește afișarea paginii până le descarcă.
- `DatePicker_min.js` **și** `DatePicker.js` se încarcă amândouă, adică varianta minificată și cea neminificată a aceluiași cod. Pe `featured.html` perechea apare **de două ori** (4 încărcări).

**Soluția**
- Actualizează la jQuery 3.7 sau elimină-l.
- Pune `defer` pe scripturile din `<head>`.
- Păstrează o singură variantă de DatePicker.

<a id="c5"></a>
### C5. Risc XSS la formularul de abonare

**Pagini:** toate cele 10.

**Ce se întâmplă**
```js
$.post("subscribe.php", data, function(response){ ... $(response).appendTo($(".commentpost")); });
```
Răspunsul serverului e inserat în pagină ca HTML. Dacă `subscribe.php` reflectă vreodată adresa de e-mail introdusă, un atacator poate injecta cod.

**Soluția**

Inserează răspunsul ca text:
```js
$(".commentpost").text(response);
```
Sau, mai bine, `subscribe.php` să întoarcă JSON (`{ok:true}`), iar mesajul să fie construit în JavaScript.

<a id="c6"></a>
### C6. Filtrul de stele: 5 checkbox-uri cu același `name="star2"`

**Pagini:** toate cele 5 pagini get-rates care au filtre (nice, featured, grcountries, grbrandcountries; indexgr nu are filtrul).

**Ce se întâmplă**

Checkbox-urile pentru 2, 3, 4, 5 stele și „Unrated” au **toate** `name="star2"`, deci serverul nu le poate deosebi. Paginile check-rates folosesc corect `star0`–`star5`.

**Soluția**

Folosește `name="star3"`, `star4`, `star5`, `star0`, ca pe check-rates.

<a id="c7"></a>
### C7. Afirmații comerciale fără dovadă

**Pagini:** toate cele 10 pagini live, plus `best-western-milan.html`.

**Ce se întâmplă**

Aceleași site-uri promit cifre diferite:

| Afirmație | Unde |
|---|---|
| „Up to 75%”, „Guaranteed” | get-rates |
| „Save up to 80%”, „Discount up to 80%” | check-rates |
| „Best price anywhere guaranteed!”, „Lowest rate guaranteed” | check-rates |
| „from 1000 booking sites” (meta) vs. „over 100 travel sites” vs. „hundreds of travel sites” vs. „1000s of travel sites” | crindex |
| „850k hotels” (meta) vs. „4,500,000 hotel deals” | indexgr |
| „800,000+ hotels” / „800,000 offers” | check-rates |

Nicăieri nu există o pagină care să explice cum funcționează garanția.

**De ce contează**
- Google Quality Rater Guidelines tratează afirmațiile nesusținute ca semnal de încredere scăzută.
- În UE, Directiva privind practicile comerciale neloiale interzice „garanțiile” fără condiții publicate.
- Motoarele AI (ChatGPT, Perplexity, AI Overviews) evită să citeze surse care se contrazic.

**Soluția**

Alege **o** cifră verificabilă și leag-o de o pagină de metodologie. Dacă nu ai o garanție reală, elimină cuvântul „Guaranteed”.

<a id="c8"></a>
### C8. Tag-uri inutile sau lipsă în `<head>`

**Pagini:** toate cele 10 pagini live.

- `<meta name="keywords">` e ignorat de Google din 2009. Poate fi șters.
- `<meta name="googlebot" content="index,follow">` dublează `robots`. Poate fi șters.
- Comentariile condiționale `<!--[if IE 8]>` / `<!--[if IE 9]>` sunt cod mort, pentru că IE e retras.
- **Lipsește** `<link rel="icon">` (favicon), deci Google afișează o iconiță generică în rezultatele de pe mobil.
- **Lipsesc** Open Graph și Twitter Cards: distribuirile pe Facebook, WhatsApp și X nu au titlu, descriere și imagine controlate.

<a id="c9"></a>
### C9. Accesibilitate: câmpuri fără etichetă, imagini cu alt greșit

**Pagini:** toate cele 10 pagini live.

- Câmpurile de e-mail sunt `type="text"` (ar trebui `type="email"`) și nu au `<label>`. Pe paginile cu formulare de filtre, **28 de câmpuri** n-au etichetă asociată.
- `alt="aright"`, `alt="adown"`, `alt="Downward arrow"` pe iconițe decorative ar trebui să fie `alt=""`.
- Steagurile și iconițele de rating au `alt=""`, ceea ce e corect pentru elemente decorative. Iconițele de rating (`rating4.svg`) poartă însă informație și ar trebui să aibă `alt="4 din 5"`.
- Fotografiile hotelurilor sunt fundaluri CSS (`background: url(...)`), între 6 și 33 pe pagină. Nu apar în Google Images și nu au text alternativ.

---

## Pagini live get-rates.com

<a id="p-indexgr"></a>
## 1. `indexgr.html`: homepage get-rates.com

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Get-Rates.com: Search. Compare. Save time & money!” (50 caractere) ✅ lungime ok. Nu conține niciun cuvânt-cheie („hotel”, „compare hotel prices”) ⚠️ |
| Meta description | **259 caractere** ❌. Google o taie la ~155–160 |
| Meta robots | `index,follow` ✅ |
| **Canonical** | **Lipsește** ❌ |
| H1 | 1: „Search all hotel deals, in one place.” ⚠️ înaintea lui apare un H2 |
| Open Graph / Twitter | Lipsesc ❌ |
| Schema | Niciuna |
| Cuvinte | 510 vizibile, dar **doar ~131 în zona principală** ❌ (restul sunt meniuri și subsol) |
| Calitatea conținutului | 87/100, semnalat **„repetitive”** (repetiție 32, cea mai mare din site) |
| Afirmații fără sursă | **2 din 2**: „4,500,000 hotel deals”, „50,000 destinations” |
| Linkuri | 126: 62 relative, 55 spre `m.get-rates.com`, **8 `javascript:`** |
| Imagini | 0 `<img>`. 6 imagini de fundal CSS |
| Mărime | 26 KB |

### Probleme critice

**1. Homepage-ul are foarte puțin conținut propriu (script + manual)**
- În afara meniurilor, homepage-ul are doar ~130 de cuvinte:
  - un slogan repetat de 3 ori („Up to 75%”);
  - trei beneficii de câte două cuvinte („Search / Compare / Save”);
  - 6 orașe cu preț.
- Pentru homepage-ul unui comparator, Google nu are din ce înțelege ce faci și pentru cine. Nu există text despre:
  - cum funcționează comparația;
  - ce site-uri sunt comparate;
  - cine operează serviciul.
- **Soluția:** adaugă o secțiune de 250–400 de cuvinte „Cum funcționează Get Rates”, cu lista partenerilor, frecvența actualizării prețurilor și un scurt FAQ.

**2. Meta description de 259 de caractere (script)**
```
Up to 75% off on your hotel deal. Discount on over 850k hotels, bed & breakfasts, inns, guest houses,
hostels and apartments available in more than 50k destinations. Compare last minute deals from hundreds
of travel websites and hotel chains around the world.
```
- Se afișează doar primele ~155 de caractere, iar mesajul se oprește la „…available in more”.
- În plus, „850k hotels” contrazice textul paginii („Over **4,500,000** hotel deals”).
- **Propunere (148 car.):** `Compare hotel prices from Booking.com, Expedia, Agoda and 100+ sites in one search. 850,000+ hotels in 50,000 destinations worldwide.`

**3. Lipsește canonical ([C1](#c1))**
- Linkul „Desktop” din subsol duce la `/`, deci există cel puțin `https://get-rates.com/` și `https://m.get-rates.com/` cu același conținut.

### Probleme importante

**4. Ordinea titlurilor (script)**
```
H2: We save you Up to 75% on your hotel deal. Guaranteed     ← primul titlu din pagină
  H3: Popular destinations this month                         ← popup ascuns
H1: Search all hotel deals, in one place.
    H3: Find deals in +100 sites in the time it takes to search one
      H4: Recommended places for you View our hand-picked hotel destinations
```
- Primul titlu văzut de crawler e un H2 cu o afirmație comercială, nu H1-ul.
- H4-ul lipește două texte într-unul singur („…for you View our…”), pentru că subtitlul e în același tag.
- **Soluția:** H1 primul („Compare hotel prices from 100+ sites”). Sloganul devine `<p>`. Titlul popup-ului devine `<p class="h3">`.

**5. Afirmații fără dovadă ([C7](#c7))**
- „Guaranteed” apare ca **link** `javascript:void(0)`, așa că utilizatorul dă click și nu află nimic despre garanție.
- „Book directly from supplier” e fals pentru un metasearch: rezervarea se face pe OTA, nu la hotel.

**6. Prețuri „from EUR 26” fixe în HTML (manual)**
- „Porto from EUR 26”, „Valencia from EUR 26”, „Milan from EUR 53”. Dacă nu sunt actualizate zilnic, devin false.
- **Soluția:** adaugă data („prețuri verificate pe 27.09.2026”) sau încarcă-le dinamic.

**7. Tracking, jQuery, XSS ([C3](#c3), [C4](#c4), [C5](#c5))**
- 4 apeluri `_gaq.push`, jQuery 1.4.2, DatePicker încărcat de 2 ori și două formulare de abonare cu `$(response).appendTo`.

**8. ID-uri duplicate (script)**
- `in2` și `out2` apar de două ori: în căutarea din pagină și în popover. `document.getElementById('in2')` găsește doar primul, deci calendarul din popover poate să nu funcționeze.

### Probleme minore
- Blocul „Different ways to stay in **United Kingdom**” pe homepage-ul global. E o alegere ciudată: pare un rest din șablon.
- Brand inconsistent: „Get-Rates.com” (title), „m.get-rates.com” (logo), „GetRates™” (subsol).
- „Find deals in **+100** sites” ar trebui scris „100+ sites”.
- Lipsesc favicon, OG și Twitter; `keywords` și `googlebot` sunt inutile ([C8](#c8)).

### Priorități pentru această pagină
1. Canonical plus alternate mobil/desktop.
2. Meta description sub 160 de caractere, cu cifre consecvente.
3. H1 primul în pagină, sloganul ca paragraf.
4. Secțiunea „Cum funcționează” (250–400 de cuvinte).
5. Eliminarea lui „Guaranteed” (sau o pagină care explică garanția), eliminarea `_gaq`, jQuery nou.

---

<a id="p-nice"></a>
## 2. `nice.html`: hoteluri în Nice

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Nice Accommodation␣␣from €15 \| Compare Stays in France” (54 car.) ✅ lungime. **Două spații** ⚠️ |
| Meta description | 148 car. ✅ tot cu **dublu spațiu** („Accommodation␣␣from €15”) ⚠️ |
| Meta robots | `index,follow` ✅ |
| **Canonical** | **Lipsește** ❌ |
| H1 | 1: „Compare Hotel rates in Nice from 15 EUR” ✅ unic, dar ordinea e greșită (vezi 4) |
| OG / Twitter | Lipsesc ❌ |
| Cuvinte | 2.023 vizibile, **1.614 în zona principală** ✅ (cel mai mult conținut dintre paginile live) |
| Calitatea conținutului | 95/100, repetiție 29 |
| Afirmații fără sursă | **10 din 13** (77%): toate „Score from X reviews” fără să spună platforma |
| Linkuri | 241: 135 spre `m.get-rates.com`, 62 relative, **42 `javascript:`** |
| Imagini | 9 `<img>`: 2 cu alt gol, **7 fără dimensiuni**. **33 fotografii ca fundal CSS** |
| Scripturi | jQuery 1.4.2, DatePicker ×2, Google Maps |
| Mărime | 74 KB, cea mai mare pagină din site |

### Probleme critice

**1. Descrierile hotelurilor nu corespund hotelurilor (manual)**

Descrierile vin dintr-un feed vechi, iar hotelurile și-au schimbat numele:

| Hotelul listat | Descrierea spune |
|---|---|
| Best Western Plus Hotel Massena Nice | „…the **L Hotel Massena**…” |
| AC Hotel Nice by Marriott | „**The Hotel Elysee Palace** is located…” |
| Hyatt Regency Nice Palais de la Mediterranee | „**The Le Palais**…”, cu articol dublu |
| Boscolo Exedra Nice Autograph Collection A Marriott Lu… | numele e tăiat în titlu |

- Utilizatorul nu știe dacă e același hotel. Google vede conținut contradictoriu.
- **Soluția:** regenerează descrierile din datele actuale sau scrie o descriere scurtă proprie pentru fiecare hotel afișat.

**2. HTML-ul din feed e stricat, cu entități și punctuație pierdute (manual)**
- Le Meridien: „as they say a **34dinner is never second best 34**”. `&#34;` (ghilimele) a devenit „34”.
- Toate descrierile și-au pierdut punctele și virgulele: „…views of Baie des Anges and the nearby sea The Le …”.
- **Soluția:** decodează entitățile (`html.unescape`) și nu elimina punctuația la importul feed-ului.

**3. Date geografice greșite (manual)**

Lista „Tourist attractions near Nice” conține locuri din alte orașe:
- **„Musée d'Art Moderne et Contemporain de Strasbourg — 1.1 km”**: e în Strasbourg, la ~700 km. Muzeul din Nice e MAMAC.
- **„Acropolis Museum — 1.2 km”**: e în Atena. În Nice e „Acropolis” (Palais des Congrès).
- **„Ferenbalm”** apare ca district al orașului Nice și ca reper al hotelului AC Hotel („Ferenbalm (0.2 miles away)”). Ferenbalm e o comună din Elveția.
- „Vieux hotels” e un nume de district trunchiat (corect: „Vieux Nice”).

Aceste erori scad încrederea (E-E-A-T), iar un asistent AI care le citează transmite informații false.

**4. Lipsește canonical ([C1](#c1))**
- „Desktop” duce la `/Accommodation-Nice-g50_2016.html`, iar 135 de linkuri absolute merg spre `m.`.

### Probleme importante

**5. Repere duplicate, care creează pagini POI dublate (manual)**

Aceeași locație apare sub două nume, fiecare cu propria pagină „hotels near”:

| Varianta 1 | Varianta 2 |
|---|---|
| Place Massena | Place Masséna |
| Nice Opéra | Opéra de Nice |
| Nice Acropolis | Palais des Congrès Acropolis |
| Port de Nice | Old Port |
| Nice Ville | Nice Train Station |

Rezultatul sunt **pagini aproape identice care concurează între ele** (canibalizare) și seamănă cu doorway pages. **Soluția:** o singură pagină per reper. Pentru variante, folosește redirect 301 sau canonical.

**6. Prețul din titlu nu e consecvent (manual)**
- Title: „from **€15**”. H1: „from **15 EUR**”. Textul Overview: „start from **11 EUR** at Hotel Altair Nice”. Meta description: „from €15 a night at Hotel Altair Nice”.
- **Soluția:** o singură sursă de adevăr pentru prețul minim, scrisă peste tot la fel.

**7. Ordinea titlurilor (script)**
```
H1: Compare Hotel rates in Nice from 15 EUR
  H3: Popular destinations this month       ← popup, apare înaintea conținutului
  H3: Find  Hotels in Nice                  ← două spații
    H4: Nice
  H3: Recommended for you in Nice
```
- Nu există niciun H2, deci conținutul nu are secțiuni.
- **Propunere de structură:**
  - H2 „Best hotels in Nice”;
  - H2 „Where to stay in Nice: districts and prices”;
  - H2 „Hotels near Nice attractions”.

**8. Lanțuri hoteliere care probabil nu există în Nice (manual)**
- „Days Inn hotels Nice”, „La Quinta hotels Nice”, „Embassy Suites hotels Nice”, „Hampton Inn hotels Nice”, „Riu hotels Nice”, „Starwood hotels Nice” (Starwood nu mai există din 2016).
- „Travelodge hotels Nice” apare **de două ori**.
- Sunt linkuri spre pagini probabil goale: thin content indexabil.
- **Soluția:** afișează doar lanțurile care au cel puțin o proprietate în oraș.

**9. 42 de linkuri `javascript:` ([C2](#c2))**
- Toate cele 9 hoteluri recomandate (numele și prețul) nu sunt linkuri reale, deci paginile de hotel nu primesc link intern.

**10. „Paris 5964 hotels” (manual)**
- 5.964 e numărul de **proprietăți**, nu de hoteluri: aceeași cifră apare ca „5964 properties” pe `grcountries.html`.

### Probleme minore
- „Nice has a good average review score of 8.0 **8.0**”: nota apare de două ori (text și badge), așa că Google o citește dublu.
- Textul de sub „(Read more)” e ascuns. Google îl indexează, dar îi dă mai puțină greutate.
- Eticheta „Ad” la „Quick deals”: dacă sunt linkuri de afiliere, ar trebui să aibă `rel="sponsored"`.
- `<table id="right_main_props">` are `<td>` direct în `<table>`, fără `<tr>` (HTML invalid).
- `<div>` neînchise: 218 deschise, 217 închise.
- Cheia Google Maps (`AIzaSyCiAW…`) e vizibilă în sursă. Restricționeaz-o după domeniu în Google Cloud Console.
- Filtru de stele cu `name="star2"` pe 5 checkbox-uri ([C6](#c6)).

### Ce e bine pe această pagină
- Paragraful „Nice Overview” are date concrete: prețuri medii pe districte, tipuri de proprietăți, hotelul cel mai bine cotat. **Este exact tipul de text pe care AI Overviews și Perplexity îl citează.** Merită păstrat și extins, după ce se corectează datele greșite de mai sus.

### Priorități pentru această pagină
1. Canonical.
2. Corectarea descrierilor (numele hotelurilor și entitățile `&#34;`).
3. Eliminarea reperelor greșite (Strasbourg, Atena, Ferenbalm) și unificarea reperelor duplicate.
4. Structură H2 și linkuri reale spre hoteluri.
5. Un singur preț minim, consecvent.

---

<a id="p-featured"></a>
## 3. `featured.html`: hoteluri lângă „Lepante Neighborhood”, Nice

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Hotels Around the Lepante Neighborhood, Nice” (44 car.) ✅ |
| Meta description | 148 car. ✅ **dublu spațiu** („of the␣␣Lepante”), se termină cu „Best rate guarantee” fără punct ⚠️ |
| Meta robots | `index,follow` ✅ |
| **Canonical** | **Lipsește** ❌ |
| H1 | „Cheap hotels near Lepante Neighborhood **Hotels**” ⚠️ cuvântul „Hotels” e repetat |
| Cuvinte | 1.334 vizibile / 925 în zona principală |
| Calitatea conținutului | 95/100, semnalat **„repetitive”** (31) |
| Afirmații fără sursă | **6 din 8**: numerele de recenzii, „built in 1990”, „154,676 reviews” |
| Linkuri | 134: 62 relative, 50 spre `m.`, **21 `javascript:`** |
| Imagini | 3 `<img>`: `alt="aright"`, 1 alt gol, 2 fără dimensiuni. 24 fundaluri CSS |
| Scripturi | **DatePicker încărcat de 4 ori** (min + full, de două ori) ❌, jQuery 1.4.2, Google Maps |

### Probleme critice

**1. Pagina e aproape identică cu `nice.html` și cu alte pagini POI (manual)**
- Hotelurile listate sunt la 0,1–0,4 km de „Lepante”. Aceleași hoteluri apar și pe paginile pentru „Nice Train Station”, „Nice Ville” și „Boutique de l'homme moderne”, care sunt toate la 0,3–0,5 km.
- Textul fiecărui hotel e descrierea standard din feed, aceeași pe sute de alte site-uri de rezervări.
- Singurul text propriu e titlul. Nu există nimic despre cartierul Lepante: ce e, de ce ai sta acolo, cât de departe e de plajă sau de gară.
- Google clasifică astfel de pagini drept **doorway pages**. Riscul e o penalizare manuală sau ca întregul site să fie considerat conținut de valoare scăzută.
- **Soluția:**
  - fie adaugi 150–300 de cuvinte despre cartier (transport, distanțe, pentru cine e potrivit, preț mediu față de restul orașului);
  - fie pui `noindex` pe paginile POI care au peste 80% din hoteluri în comun cu pagina orașului.

**2. Descrieri greșite (manual)**
- **Hotel Miron** e descris ca „**The Hotel Marly S** is perfectly located…”, adică alt hotel.
- „just 30 metres **32 yards**”: parantezele s-au pierdut.
- „Massna Square”: lipsește „é” (corect: Masséna).
- „It **s**”, „hotel **s** guestrooms”: apostrofurile au fost șterse din tot textul.
- Descrierea Best Western New York se oprește la „…for those who **nee...**”.

**3. Lipsește canonical ([C1](#c1))**
- „Desktop” duce la `/Lepante-Neighborhood-nearby-13465.html`.

### Probleme importante

**4. H1 cu cuvânt repetat și „Cheap” (manual)**
- „Cheap hotels near Lepante Neighborhood Hotels”. Șablonul adaugă „Hotels” după un nume de POI care nu are nevoie de el.
- Nu există H2. Titlurile trec direct de la H1 la H3 („Popular destinations this month”, un popup).
- **Propunere H1:** „Hotels near Lepante, Nice: compare prices”.

**5. Scripturi încărcate de patru ori (manual)**
```html
<script src="scripts/calendar/DatePicker_min.js"></script>
<script src="scripts/calendar/DatePicker.js"></script>
... (în altă parte a paginii, aceleași două încă o dată)
```
- 4 descărcări pentru același cod, plus riscul ca handler-ele să fie legate de două ori, iar calendarul să se deschidă dublu.

**6. Tracking ([C3](#c3))**
- 19 apeluri `_gaq.push`, plus `ga('send')` pe checkbox-ul „no dates”, care aruncă `ReferenceError` la click.

**7. Breadcrumb invalid (manual)**
```html
<li>…Nice<span>1,354 results</span></a></li> &#10095; <div>Lepante Neighborhood</ol>
```
- `<div>` e pus direct în `<ol>` și nu e închis. Separatorul `&#10095;` e text între `<li>`-uri, iar HTML-ul valid nu permite text direct într-un `<ol>`.

### Probleme minore
- `<table id="right_main_props">` fără `<tr>`.
- `<div>`: 203 deschise, 202 închise.
- Filtru de stele `star2` ×5 ([C6](#c6)).
- Cheia Google Maps e în sursă.
- Iconița de rating are `alt=""`, deci informația „4/5” nu e accesibilă.

### Priorități
1. Decide dacă paginile POI rămân indexate. Dacă da, adaugă text unic despre cartier.
2. Canonical.
3. Corectarea descrierilor (Miron/Marly, apostrofuri, text tăiat).
4. Eliminarea încărcărilor duble de scripturi.
5. H1 fără repetiție, plus un H2.

---

<a id="p-grcountries"></a>
## 4. `grcountries.html`: cazare în Franța (pagina de țară)

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Places to stay in France” (**24 car.**) ⚠️ prea scurt, fără „hotels”, fără brand |
| Meta description | 115 car. ✅. Se termină fără punct |
| Meta robots | `index,follow` ✅ |
| **Canonical** | **Lipsește** ❌ |
| H1 | 1: „Compare prices on Hotels in France” ✅ |
| Cuvinte | 1.780 vizibile, **1.318 în zona principală** ✅ (are ghid de țară) |
| Calitatea conținutului | 90/100, repetiție 24 |
| Afirmații fără sursă | 1/1 („62,483 results”) |
| Linkuri | 268: 174 spre `m.`, 84 relative, 9 `javascript:` |
| Imagini | 4 `<img>`, 3 fără dimensiuni. 16 fundaluri CSS |

### Probleme critice

**1. Bloc despre altă țară (manual)**
- Pagina are **două** blocuri de tipuri de cazare: „Different ways to stay in **France**” și, în subsol, „Different ways to stay in **United Kingdom**”, cu linkuri spre paginile UK.
- Pentru Google e un semnal că șablonul e defect. Pentru utilizator e confuz.
- **Soluția:** elimină blocul UK sau alimentează-l cu datele țării curente.

**2. Ghidul Franței are greșeli de fapt și de scriere (manual)**

| În text | Corect |
|---|---|
| „If would be alive” | „It would be…” |
| „croisant” | „croissant” |
| „Pont du **Grant**” | „Pont du **Gard**” |
| „Languedo**s**” | „Languedo**c**” |
| Nîmes, „Rome of **Wales**” | „Rome of **France**”: porecla Nîmes-ului |
| „Maison Carre” | „Maison Carrée” |
| „George **Pampidou**” | „Georges **Pompidou**” |
| „1oct. 1962” | „1 Oct. 1962” |
| „Prix de l ~ Arc” | „Prix de l'Arc de Triomphe” |

- Ghidul e singurul conținut editorial de pe pagină. Greșelile de nume proprii îl fac necitabil pentru AI și scad scorul E-E-A-T.

**3. Textul e tăiat în mijlocul cuvântului la „read more” (manual)**
- Partea vizibilă se termină cu „…still” / „ins”, iar restul e în blocul ascuns. Oricine citește doar partea vizibilă vede un cuvânt rupt.
- **Soluția:** taie la final de propoziție sau de paragraf.

**4. Lipsește canonical ([C1](#c1))**
- „Desktop” duce la `/Accommodation-France-g50.html`.

### Probleme importante

**5. Cifre contradictorii (manual)**
- Lista „Destinations” spune „Paris **5964 Hotels**”, iar cardul Paris spune „**1709** hotels”. 5.964 este numărul de proprietăți.
- „**1 Retreats**”, „**1 vacation rentals**”: pluralul e greșit la valoarea 1.

**6. Două formate de URL pentru aceleași destinații (manual)**
- `Cheap-Hotels-France-…-g20045_…` și `Accommodation-…-g50_…` apar amestecate. Dacă formatul vechi nu mai există, sunt linkuri spre 404. Dacă există, sunt duplicate.
- **Soluția:** un singur format, cu redirect 301 de la cel vechi.

**7. Titlu prea scurt (script)**
- **Propunere (55 car.):** `Hotels in France: Compare 62,000+ Places to Stay | Get Rates`.

### Probleme minore
- Breadcrumb: `<div>France<span>62,483 results</span></ol>`, cu `<div>` neînchis în `<ol>`.
- `<div>`: 131 deschise, 130 închise. ID-uri duplicate `in3` și `out3`.
- „Find␣␣Hotels in France”: dublu spațiu în H3.
- Iconița „Country guide icon” fără dimensiuni.
- [C3](#c3)–[C9](#c9) se aplică integral.

### Priorități
1. Eliminarea blocului UK.
2. Corectarea ghidului (tabelul de mai sus) și a tăieturii „read more”.
3. Canonical.
4. Consecvența cifrelor și un singur format de URL.
5. Titlu mai lung, cu cuvânt-cheie.

---

<a id="p-grbrandcountries"></a>
## 5. `grbrandcountries.html`: Best Western în Franța

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „279+ Best Western Hotels in France” (34 car.) ✅ |
| Meta description | 133 car. ✅. Conține „best rate guarantee” ⚠️ |
| **Canonical** | **Lipsește** ❌ |
| H1 | **2** ❌: „Compare prices on Best Western Hotels in France” și „Best Western Hotels in France, **France**” |
| Cuvinte | 1.180 vizibile / 716 în zona principală |
| Calitatea conținutului | 92/100, repetiție 29 |
| Linkuri | **282**: 210 spre `m.`, 62 relative, 8 `javascript:` |
| Imagini | 3 `<img>`. Logo-ul Best Western fără dimensiuni |

### Probleme critice

**1. Două H1, iar al doilea repetă „France” (script + manual)**
- „Best Western Hotels in France, France”: șablonul pune `{oraș}, {țară}`, iar pentru pagina de țară orașul e tot „France”.
- **Soluția:** un singur H1. Al doilea devine H2 „About Best Western in France”.

**2. Cifrele nu se potrivesc (manual)**

| Unde | Valoare |
|---|---|
| Title, meta | **279**+ Best Western |
| Ancora internă | `name="27+_Best_Western_Hotels_in_France"` (**27**) |
| Breadcrumb | „Best Western France: **62,483 all hotels**” (totalul tuturor hotelurilor din Franța, nu al celor Best Western) |
| Paris | listă: **56** · card: **60** best western |
| Nice | listă: **6** · card: **5** |
| Cannes | listă: **4** · card: **2** |
| Marseille | listă: **4** · card: **3** |

- Suma orașelor listate e ~120, nu 279. Pentru un utilizator sau pentru un sistem AI care verifică, pagina se contrazice singură.

**3. Textul despre brand e greșit (manual)**
- „Voted as the best mid-range hotel brand **in Asia**”, pe o pagină despre Franța, fără sursă.
- „the largest hotel company operating under a single brand name several independently operated hotels” e o frază agramată.

**4. Lipsește canonical ([C1](#c1))**
- Breadcrumb-ul „Best Western France” și linkul „Desktop” duc amândouă la `/Best-Western-Hotels-France-bw-50.html`, adică la aceeași pagină în varianta desktop.

### Probleme importante

**5. Bloc „Different ways to stay in United Kingdom” pe pagina Franței (manual)**
- 9 linkuri spre paginile de tipuri de cazare din UK.

**6. Parteneri și lanțuri învechite (manual)**
- „**Starwood** hotels France”: Starwood a fost cumpărat de Marriott în 2016.
- „**Embassy Suites** France”: probabil 0 hoteluri, deci pagină goală.
- Printre site-urile căutate apare **Venere** (închis în 2015–2016), iar în „How it Works” scrie **Ctrip.com** (azi Trip.com).
- Lanțurile „**Etap**” și „**All Seasons**” au fost redenumite ibis budget și ibis Styles în 2011–2012.

**7. Breadcrumb invalid (manual)**
```html
<li><a href="/"><img …></a> <div …><a href="chains.html">Hotel Chains</a></div></a></li>
```
- Un `</a>` în plus, `<div>` în `<li>` în `<ol>`, iar la final `<div> Best Western Hotels<span>279+ results</span></ol>` rămâne neînchis.

**8. Tracking ([C3](#c3))**
- `ga('send', …)` pe checkbox-ul „no dates” aruncă `ReferenceError`. Plus 4 × `_gaq.push`.

### Probleme minore
- ID-uri duplicate: `in3`, `out3`, `outline_big`. ID-uri doar numerice: `1`, `2`, `11`, `12`.
- „Find␣␣Best Western Hotels in France”: dublu spațiu. „Hotels Chains:” în loc de „Hotel chains:”.
- „luxury collection&reg;” scris cu minuscule. „1 comfort inns”, „1 concorde hotels”: plural la 1.
- Textul despre brand e ascuns după „read more”.

### Priorități
1. Un singur H1, fără „France, France”.
2. Cifre consecvente (279 peste tot sau numărul real).
3. Corectarea textului despre brand („Asia”).
4. Canonical și eliminarea blocului UK.
5. Actualizarea lanțurilor și partenerilor.

---

## Pagini live check-rates.com

> Aceste 5 pagini sunt de pe **check-rates.com**, un domeniu diferit de get-rates.com. Au același tip de conținut ca get-rates. Dacă ambele site-uri aparțin aceluiași operator, **conținutul duplicat între domenii** e o problemă în sine: Google alege o singură versiune, iar cealaltă nu mai apare în rezultate. Soluția e fie conținut diferit pe fiecare domeniu, fie `rel=canonical` cross-domain spre versiunea principală.

<a id="p-crindex"></a>
## 6. `crindex.html`: homepage check-rates.com

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Check-Rates.com - Compare Rates for Hotels” (42 car.) ✅ |
| Meta description | 149 car. ✅. Conține „Lowest rate guaranteed”, „Discount up to 80% from **1000** booking sites” ⚠️ |
| **Canonical** | **Lipsește** ❌ |
| H1 | 1: „Want to find the lowest rate?” ⚠️ întrebare, fără cuvânt-cheie |
| Cuvinte | 600 vizibile / 570 în zona principală |
| Calitatea conținutului | 97/100 |
| Afirmații fără sursă | **31 din 31**, printre care „800,000 offers”. Cele în procente sunt CSS, fals-pozitive |
| Linkuri | 153: **129 relative**, 7 spre `m.`, 13 `javascript:`, 3 AddThis |
| Imagini | 3 (Facebook, Twitter, Email), fără dimensiuni |

### Probleme critice

**1. Cifrele se contrazic între ele (manual)**

| Unde | Afirmație |
|---|---|
| Meta description | „from **1000** booking sites” |
| Pagină | „Compare over **100** travel sites” |
| Subsol | „searching **hundreds** of travel sites” |
| Subsol | „Compare **1000s** of travel sites on the go” |
| Pagină | „over **800,000** offers” / „**800,000+** hotels” |
| Pagină | „Save up to **80%**” vs get-rates „up to **75%**” |

- Patru cifre diferite pentru același lucru, pe aceeași pagină. Motoarele AI nu citează o sursă care se contrazice. Pentru utilizator e un semnal de marketing neverificat.

**2. „Guaranteed” ca promisiune fără conținut ([C7](#c7))**
- „We'll find you great deals from thousands of travel sites. **Guaranteed**” e un link `javascript:void(0)` care nu duce nicăieri.
- „Best price anywhere guaranteed!” și „No booking fee or markup!”: pentru un metasearch, taxele sunt ale site-ului pe care rezervi, nu ale comparatorului, deci promisiunea e înșelătoare.

**3. Lipsește canonical (C1)**
- Linkurile sunt amestecate: `check-rates.com`, `m.check-rates.com` și relative.

### Probleme importante

**4. Ierarhia titlurilor (script)**
```
H3: Update your property details      ← popup pentru hotelieri, primul titlu din pagină
H3: Get Direct Bookings               ← popup
H1: Want to find the lowest rate?
  H3: Add your destination and let us give you the hotel rates
        H5: Bangkok   H5: Vienna   H5: Dubai   H5: Kyoto   H5: Cancun   H5: Hurghada
  H3: Choose your destination
```
- Două H3 din popup-uri sunt înaintea H1. De la H3 se sare la H5, fără H4.
- **Soluția:**
  - H1 „Compare hotel prices from 100+ booking sites”;
  - orașele ca H3 sub un H2 „Most popular destinations this week”;
  - popup-urile cu `<p>` în loc de H3.

**5. Destinații care nu duc nicăieri (manual)**
- În „Choose your destination” apar țări fără niciun oraș dedesubt: Germany, Netherlands, Argentina, Brazil, Chile, Dominican Republic, Peru, New Zealand, Bahrain, Lebanon, Oman, Qatar, Kuwait, Saudi Arabia.
- **Syria** e listată ca destinație turistică. Nu e o problemă SEO, dar pare neîngrijit.

**6. Pagina pentru hotelieri e amestecată cu cea pentru turiști (manual)**
- „Update your property details” și „Get Direct Bookings” sunt texte B2B pentru hoteluri, în homepage-ul pentru turiști, înaintea H1-ului.
- **Soluția:** mută-le pe o pagină `/for-hotels/` separată.

**7. Datele sunt vechi (manual)**
- „Prices updated on: **Wed Sep 23**, 2026”, în timp ce celelalte pagini check-rates spun „Sun Sep 27”. Homepage-ul are prețuri cu 4 zile mai vechi.

### Probleme minore
- AddThis (`api.addthis.com`, 3 linkuri): serviciul s-a închis în mai 2023, deci scriptul și butoanele nu mai funcționează.
- ID-uri duplicate `in2`, `out2`, `label2`. ID-uri doar numerice (`30739`, `4`, `6`, `8`).
- `<div>`: 122 deschise, 123 închise.
- Brand inconsistent: „Check-Rates.com”, „CheckRates”, „check rates”, „Check-rates.com” și, rămase din alt proiect, „**getRates**” și „**Get Rates**” în cod.
- 13 × `_gaq.push`, e-mail `type="text"` fără `<label>`, `$(response).appendTo` ([C3](#c3), [C5](#c5), [C9](#c9)).

### Priorități
1. O singură cifră pentru numărul de site-uri, plus pagina „How it works” cu lista partenerilor.
2. Eliminarea lui „Guaranteed” și a lui „No booking fee or markup”, sau explicarea lor.
3. Canonical și decizia despre relația cu get-rates.com.
4. H1 cu cuvânt-cheie și popup-urile B2B scoase din fluxul de titluri.
5. Eliminarea AddThis.

---

<a id="p-croras"></a>
## 7. `croras.html`: hoteluri în Kyoto

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Kyoto Hotels, Holiday Rentals & Apartments, Japan” (49 car.) ✅ |
| Meta description | 148 car. ✅ |
| **Canonical** | **Lipsește** ❌ |
| **H1** | **Nu există** ❌. „Kyoto 741 hotels” e H2 |
| Cuvinte | 1.763 vizibile / **1.628 în zona principală** ✅ |
| Calitatea conținutului | 96/100 |
| Afirmații fără sursă | 3 din 11 („469,380 reviews” ×2, „4,113 reviews”) |
| Linkuri | 187: 104 spre `m.check-rates.com`, 32 relative, **45 `javascript:`** |
| Imagini | 22 `<img>`, **21 fără dimensiuni**, 1 fără alt, 2 cu alt gol |
| Scripturi | Google Maps cu cheia `AIzaSyAwR9…` vizibilă |

### Probleme critice

**1. Nu există H1 (script)**
```
H3: Update your property details   ← popup
H3: Get Direct Bookings            ← popup
H3: Find Hotels in Kyoto
H2: Kyoto 741 hotels               ← cel mai important titlu, dar H2
  H3: Featured␣␣Hotels in Kyoto    ← dublu spațiu
  H3: Hotels in other cities
  H3: Popular hotels in Kyoto
  H3: See how Kyoto hotels rate
```
- H1 e cel mai puternic semnal on-page despre subiectul paginii.
- **Soluția:** `<h1>Kyoto Hotels: Compare 741 Places to Stay</h1>`.

**2. Cifrele din „Overview” contrazic blocul de tipuri de cazare (manual)**

| Tip | Bloc „Different ways to stay” | Paragraf Overview |
|---|---|---|
| Holiday Rentals | 78 | **81** |
| Apartments | 74 | **79** |
| B&Bs | 49 | **53** |
| Inns | 44 | **46** |
| Nota medie | „8.7” (sus) | „**8.8** out of 10” (jos) |

- Paragraful de Overview e cel mai citabil text de pe pagină, dar cifrele lui nu se potrivesc cu restul paginii.
- **Soluția:** toate numerele să vină din aceeași interogare, rulată în același moment.

**3. Lipsește canonical ([C1](#c1))**

### Probleme importante

**4. 45 de linkuri `javascript:` ([C2](#c2))**
- Cele 9 hoteluri „Featured” (numele și prețul) nu sunt linkuri reale.

**5. „Popular searches” irelevante pentru Kyoto (manual)**
- „**Formule 1** hotels Kyoto”, „**Macdonald** hotels Kyoto”, „**Premier Inn** hotels Kyoto”, „**NH** hotels Kyoto”, „**Accor** hotels Kyoto”. Formule 1 și Macdonald nu există în Japonia.
- Aceeași listă de 17 căutări apare identic pe **toate** paginile check-rates („…Vienna”, „…Kyoto”). E un bloc de linkuri interne generat din șablon, pe care Google îl poate trata ca spam de linkuri.

**6. Promovezi un hotel cu nota 5.1 la „Popular hotels” (manual)**
- „Ryokan Ohto — **Mediocre 5.1**” e primul hotel din „Popular hotels in Kyoto”. Pentru utilizator e o recomandare slabă.
- „Kyo Kichinoya/S. Modern kyomachiya **# Free parking**”: numele hotelului conține text de marketing din feed.

**7. Distanțe inconsecvente (manual)**
- Rihga Gran Kyoto: „(**3.3** km from Kyoto center)” în antet, dar „**3.4** km from the centre” în descriere.

**8. Imagini (script)**
- 21 din 22 de imagini nu au `width`/`height`, deci pagina „sare” la încărcare (CLS).
- Iconițele de stele au alt descriptiv („3-star hotel in Kyoto”), ceea ce e bine. Iconița de rating (`rating41234.svg`) are alt gol, iar `ico_expand.png` nu are deloc atribut `alt`.

### Probleme minore
- „8.7 **8.7**”: nota apare de două ori.
- „1 **hotels**”, „1 Four Points”, „1 Four Seasons” sunt probleme de plural.
- „Hotels in other cities” listează Nagoya, Kanazawa, Kobe, dar **nu Osaka și Tokyo**, deși Osaka e la 42 km.
- `<table>` cu `<td>` fără `<tr>`. ID-uri duplicate (`4`, `6`, `Rooms`, `a_aid2`, `brandId2`).
- AddThis, 40 × `_gaq.push`, 201 atribute `style` inline.
- Cheia Google Maps e vizibilă în sursă. Restricționeaz-o după domeniu.

### Ce e bine
- Paragraful de Overview („Kyoto has 741 hotels listed, from 1-star properties at around 2,182 JPY…”) e un exemplu bun de conținut **citabil de AI**: are cifre, date și comparații. După corectarea cifrelor, poate fi folosit ca model pentru toate paginile de oraș.

### Priorități
1. Adaugă H1.
2. Aliniază cifrele din Overview cu restul paginii.
3. Canonical.
4. Linkuri reale spre hoteluri.
5. Elimină „Popular searches” generic sau filtrează-l pe lanțurile existente în oraș.

---

<a id="p-hbrandcr"></a>
## 8. `hbrandcr.html`: DoubleTree în Kyoto

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Doubletree Hotels in Kyoto \| Cheap Hotel Deals” (46 car.) ⚠️ numele mărcii e scris greșit, „Cheap” la hoteluri de 4 stele |
| Meta description | 119 car. ✅. „Lowest rate guaranteed” ⚠️ |
| **Canonical** | **Lipsește** ❌ |
| H1 | 1: „Doubletree␣␣hotels in Kyoto”, dar **după 3 H3** ⚠️ |
| Cuvinte | 1.251 / 1.115 |
| Calitatea conținutului | 96/100, **„repetitive”** (30) |
| Linkuri | 133, dintre care **42 `javascript:`** |
| Imagini | 22, **21 fără dimensiuni** |

### Probleme critice

**1. Pagină subțire: doar 2 hoteluri DoubleTree, restul sunt din alt oraș (manual)**
- Pagina are exact **2** hoteluri DoubleTree. Apoi scrie: „We couldn't find more Hotels in Kyoto, but here are a few other options in nearby cities” și listează **6 hoteluri din Otsu**, care nu sunt DoubleTree.
- Blocurile „Destinations nearby”, „Airports”, „Property types”, „Popular searches” și „Popular hotels” sunt **identice** cu cele de pe `croras.html`.
- Aproape tot conținutul e duplicat, iar subiectul real (2 hoteluri) ocupă câteva rânduri. E un exemplu clasic de pagină programatică subțire.
- **Soluția:**
  - pentru combinațiile brand × oraș cu sub 3 hoteluri, pune `noindex,follow` sau
  - redirecționează spre pagina orașului, filtrată pe brand.

**2. Descrieri greșite (manual)**
- Reiah Hotel Ohtsu Ishiyama: „is located **in Kyoto**”, deși hotelul e în Otsu (11,9 km).
- Calendar Hotel: „only **1.9 km** from the centre”, deși antetul spune „**8.3 km** from Kyoto”. Centrul la care se referă descrierea e al orașului Otsu, dar nu se precizează.
- Lake Biwa Otsu Prince Hotel: „All **540** at this 3-star property” (lipsește „rooms”) și „Discover all that **Kyoto** has to offer with **Otsu** Prince Hotel”.
- Hotel Tetora: „a few **minuets** walk”.

**3. Lipsește canonical ([C1](#c1))**

### Probleme importante

**4. Numele mărcii e scris greșit (manual)**
- Numele oficial e **DoubleTree by Hilton**. Pagina scrie „Doubletree” în title, H1 și meta, iar cardurile scriu corect „DoubleTree by Hilton”.
- **Propunere de titlu:** `DoubleTree by Hilton Kyoto: Compare 2 Hotels | Check-Rates`.

**5. „Cheap Hotel Deals” în titlu (manual)**
- DoubleTree e un brand upscale de 4 stele, cu prețuri de 17.000–20.000 JPY pe noapte. „Cheap” nu corespunde intenției de căutare și poate crește rata de revenire în rezultate (pogo-sticking).

**6. Ordinea titlurilor (script)**
- 3 H3 (popup-urile pentru hotelieri și „Search Doubletree hotels”) apar înaintea H1. Nu există niciun H2.

### Probleme minore
- „Kyoto has a great average review score of 8.7 8.7”: nota e a **orașului**, nu a hotelurilor DoubleTree (care au 9.0 și 8.7).
- „Popular searches” conține „Doubletree hotels Kyoto”, adică un link spre pagina curentă.
- „1 hotels”: plural greșit.
- Iconițele de stele au `alt="4-star hotel in "`: orașul lipsește din alt, pentru că variabila e goală.
- AddThis, 31 × `_gaq`, ID-uri duplicate, `<td>` fără `<tr>`, cheia Maps în sursă.

### Priorități
1. `noindex` sau redirect pentru combinațiile brand × oraș cu sub 3 hoteluri.
2. Canonical.
3. Numele corect al mărcii în title și H1, fără „Cheap”.
4. Corectarea descrierilor care spun Kyoto în loc de Otsu.
5. H1 primul și H2 pentru secțiuni.

---

<a id="p-psearchescr"></a>
## 9. `psearchescr.html`: Best Western în Viena

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Best Western Hotels Vienna \| Reservations & Deals” (49 car.) ✅ |
| Meta description | 136 car. ✅. „No hidden fees… save up to **80%**” ⚠️ |
| **Canonical** | **Lipsește** ❌ |
| H1 | 1: „Best Western Hotels in Vienna”, dar **după 3 H3** ⚠️ |
| Cuvinte | 1.525 / 1.388 ✅ |
| Calitatea conținutului | 96/100 |
| Afirmații fără sursă | „749,395 reviews” |
| Linkuri | 211: 131 spre `m.check-rates.com`, **43 `javascript:`** |
| Imagini | 20, **19 fără dimensiuni** |
| Scripturi | **5 blocante în `<head>`**, cele mai multe din site: `common.js`, jQuery 1.4.2, `yahoo-dom-event.js`, `calendar-min.js`, `BoxCalendar.js` |

### Probleme critice

**1. Majoritatea hotelurilor „Best Western” nu mai sunt Best Western (manual)**

Numele din listă și descrierea spun lucruri diferite:

| Numele afișat | Descrierea spune |
|---|---|
| Boutique Hotel **Piano Nobile** | „**Best Western Hotel-Pension Arenberg** is located…”, adică un alt hotel, cu alt nume |
| Schlosshotel Romischer Kaiser | „The **Best Western Premier**…” |
| Boutique Hotel Das Tigra | „the **BEST WESTERN** Hotel Das Tigra…” |
| Hotel Kaiserhof Wien | „The **BEST WESTERN PREMIER** Kaiserhof Wien…” |
| Hotel Beethoven Wien | „The **Best Western** Hotel Beethoven…” |
| The Harmonie Vienna | „the **BEST WESTERN** Hotel Harmonie…” |

- Doar 2 din cele 8 hoteluri afișate au „Best Western” în nume: **Plus Hotel Arcadia** și **Plus Celebrity Suites**.
- Celelalte 6 au părăsit lanțul, iar numele actuale nu mai conțin „Best Western”. Pagina le prezintă totuși ca Best Western.
- Pentru cineva care caută „Best Western Vienna” (de exemplu, pentru punctele Best Western Rewards), informația e **greșită și poate produce reclamații**.
- **Soluția:** filtrează după `brand_id` actual, nu după descrierea istorică. Dacă rămân doar 2 hoteluri, aplică regula de la [hbrandcr](#p-hbrandcr): `noindex` sub 3 hoteluri.

**2. Prețul mediu e „0 EUR” (manual)**
- „**0 EUR** is the avg. rate/night this week in Vienna”: o valoare lipsă e afișată ca zero. Google poate prelua textul în snippet.
- **Soluția:** ascunde propoziția când valoarea e 0 sau lipsește.

**3. Breadcrumb cu „Vienna” de trei ori (manual)**
- „Home > Austria > Vienna > Vienna > Vienna Best Western Hotels”: nivelurile regiune, district și oraș au același nume.
- **Soluția:** comprimă nivelurile identice: „Home > Austria > Vienna > Best Western”.

**4. Lipsește canonical ([C1](#c1))**

### Probleme importante

**5. Greșeli în nume proprii (manual)**
- „Palais **Leichtenstein**” ar trebui „Palais **Liechtenstein**”.
- „**Stephanzplatz**” ar trebui „**Stephansplatz**”.
- „Rudolfsheim-**Funfh**” e trunchiat: corect „Rudolfsheim-**Fünfhaus**”.
- „Wahring”, „Dobling”, „Schonbrunn”, „Romischer” au umlauturile pierdute (ar trebui „Währing”, „Döbling”, „Schönbrunn”, „Römischer”). Google înțelege ambele forme, dar textul pare neîngrijit.

**6. Repere duplicate (manual)**
- „Stephansdom” / „St. Stephen's Cathedral” / „Stephansplatz”, „Schoenbrunn Palace” / „Schonbrunn Palace”, „Schloss Belvedere” / „Belvedere Palace”, „Westbahnhof Train Station” / „Wien Westbahnhof”. Fiecare pereche creează pagini POI duplicate.
- „**Sudbahnhof**”: gara Wien Südbahnhof a fost demolată în 2009 și înlocuită de Wien Hauptbahnhof.

**7. Lanțuri învechite în „Hotel brands” (manual)**
- Starwood (Marriott din 2016), Etap (ibis budget din 2011), Suitehotel (Novotel Suites din 2011), „Srs-Worldhotels”.
- „Popular searches”: Formule 1, Macdonald, Premier Inn, Choice în Viena. Este același bloc ca pe Kyoto.

**8. Performanță (script)**
- 5 scripturi blocante în `<head>`, dintre care YUI (`yahoo-dom-event.js`), o bibliotecă abandonată din 2014, și jQuery 1.4.2.
- 19 imagini fără dimensiuni.

### Probleme minore
- „Vienna has a very good average review score of 8.4 **8.4**”: nota e dublată.
- „Featured␣␣Best Western Hotels in Vienna”: dublu spațiu.
- „1 Relais”, „1 hotels”: plural.
- „Boutique Hotel Piano Nobile - am S…”: numele e tăiat în titlul cardului.
- „4.2/5 From 749,395 reviews, 84.8% of users recommended”: nu spune sursa recenziilor.
- AddThis, 37 × `_gaq`, ID-uri duplicate, `<td>` fără `<tr>`.

### Priorități
1. Scoate hotelurile care nu mai sunt Best Western.
2. Ascunde „0 EUR” când prețul lipsește.
3. Comprimă breadcrumb-ul.
4. Canonical.
5. Corectează numele proprii și unifică reperele duplicate.
6. Elimină YUI și jQuery vechi.

---

<a id="p-countriescr"></a>
## 10. `countriescr.html`: hoteluri în Austria (pagina de țară)

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Austria Hotels, Resorts & Apartments” (36 car.) ✅ |
| Meta description | 139 car. ✅ |
| **Canonical** | **Lipsește** ❌ |
| **H1** | **Nu există** ❌. Toate titlurile sunt H3 |
| Cuvinte | 1.064 / 934 |
| Calitatea conținutului | 96/100, repetiție 29 |
| Linkuri | 176: 114 spre `m.check-rates.com`, 25 `javascript:`, 3 AddThis |
| Imagini | 23: 12 steaguri cu alt gol (corect), 1 fără alt, 11 fără dimensiuni |

### Probleme critice

**1. Eroare de sintaxă JavaScript (manual)**
```js
odometer.innerHTML = ;
```
- Asta e un **SyntaxError**, iar browserul nu execută **deloc** blocul `<script>` care o conține. Contorul „4,980,000 deals” nu pornește, și nici codul din același bloc.
- Probabil server-side-ul n-a completat valoarea (`odometer.innerHTML = <?= $count ?>;` cu `$count` gol).
- **Soluția:** `odometer.innerHTML = <?= (int)$count ?>;`. Cast-ul la `int` scrie `0` în loc de gol.

**2. Nu există H1 (script)**
```
H3: Update your property details
H3: Get Direct Bookings
H3: Find Hotels in Austria
H3: Destinations in Austria
H3: Austria Overview
H3: Recently added properties in Austria
```
- Șase H3 la același nivel, fără niciun H1 sau H2. Google nu are un titlu principal.
- **Soluția:**
  - `<h1>Hotels in Austria: Compare 5,963 Places to Stay</h1>`;
  - H2 pentru „Destinations”, „Regions”, „Places of interest”.

**3. Lipsește canonical ([C1](#c1))**

### Probleme importante

**4. Cifre care nu se potrivesc (manual)**
- Textul spune „We recently found **5963 hotels** in Austria”, dar blocul „Different ways to stay” spune „**3924 Hotels**”. 5.963 e totalul tuturor proprietăților, adică suma regiunilor (114 + 347 + 1304 + 600 + 2097 + 384 + 338 + 287 + 492).
- „**4,980,000** deals from 1000s of travel sites” e o afirmație fără sursă.

**5. Text de șablon cu keyword stuffing (manual)**
- Paragraful „Looking for great deals on Austria hotels?…” are ~180 de cuvinte și repetă „**Austria**” de **11 ori** (dintre care „Austria hotel(s)” de 5 ori):
  > „A hotel in Austria is easy to find… a great selection of Austria hotels… the best Austria hotel for your needs… reserve Austria hotels… your Austria hotel reservation…”
- Acesta e textul-tip pe care Google îl consideră scris pentru motoare de căutare, nu pentru oameni. Același paragraf, cu altă țară, apare pe toate paginile de țară check-rates.
- **Soluția:** înlocuiește-l cu un paragraf cu date, ca Overview-ul de pe `croras.html` (prețuri medii pe regiuni, cele mai bine cotate stațiuni de schi, sezonalitate).

**6. Repere duplicate și învechite (manual)**
- „Stephansdom” / „St. Stephen's Cathedral”, „Schoenbrunn Palace” / „Schonbrunn Palace”, „Schloss Belvedere” / „Belvedere Palace”, „Westbahnhof Train Station” / „Wien Westbahnhof”.
- „**Sudbahnhof**” nu mai există din 2009.
- „**Casino Stadion Ledenitzen Oberaichwald**” e un nume fără sens, rezultat din două repere lipite.

**7. Linkuri `javascript:` spre proprietăți (manual)**
- „Recently added properties” (Hotel Altpradl, Anja Appartmenthaus etc.) și meniurile „Regions”, „Cities”, „Places of interest”, „Property types” folosesc `javascript:void(0)`.

### Probleme minore
- Imagini: `ico_expand.png` fără alt, `alt="aright"`, iconițele din subsol fără dimensiuni.
- ID-uri duplicate: `4`, `6`, `Rooms`, `a_aid2`, `brandId2`.
- `<div>`: 164 deschise, 165 închise.
- AddThis, 7 × `_gaq.push`, 110 atribute `style` inline.
- Meniul „Hotels Apartments B&Bs … Inns Retreats…”: „…” e un item de meniu fără sens pentru crawler.

### Priorități
1. **Repară `odometer.innerHTML = ;` astăzi.**
2. H1 și H2.
3. Canonical.
4. Înlocuiește paragraful de keyword stuffing cu conținut bazat pe date.
5. Cifre consecvente (hoteluri vs. proprietăți).
6. Unifică reperele duplicate.

---

## Pagini Get Rates create de noi

Aceste pagini au fost scrise în această sesiune, așa că problemele sunt puține. Explic totuși fiecare observație.

<a id="p-milan"></a>
## 11. `best-western-milan.html`: landing page Best Western Milan

### Ce au găsit scripturile

| Verificare | Rezultat |
|---|---|
| Titlu | „Best Western Milan Hotel Deals \| Compare & Save up to 75% \| Get Rates” (**69 car.**) ⚠️ |
| Meta description | 150 car. ✅ |
| Robots | `index, follow, max-snippet:-1, max-image-preview:large` ✅ |
| Canonical | ✅ auto-referențial |
| H1 | 1: „Best Western Milan: Compare Hotel Deals and Rates” ✅ |
| Titluri | H1 → 4 × H2, fără salturi ✅ |
| Cuvinte | 931 / 900 ✅ |
| Calitatea conținutului | **97/100** (cel mai bun scor din site) |
| Afirmații fără sursă | 1 din 7: „1,910 reviews” |
| Linkuri | 11, niciun `javascript:` ✅ |
| Schema | 0 (intenționat) |

### Probleme importante

**1. Titlul are 69 de caractere (script)**
- Google afișează ~580 px (≈ 55–60 de caractere), așa că „| Get Rates” va fi tăiat.
- **Propunere (54 car.):** `Best Western Milan: Compare Hotel Deals | Get Rates`. „Save up to 75%” poate rămâne în meta description, cu o condiție (vezi 2).

**2. „Save up to 75%” (manual, [C7](#c7))**
- E o cifră preluată de pe site-ul live, dar pagina nu arată nicăieri o economie de 75%. Tabelul de prețuri arată diferențe de 4–8% între site-uri (de exemplu, €63 vs €68).
- **Soluția:** scoate cifra sau înlocuiește-o cu ceva ce pagina chiar demonstrează: „Compare 3 booking sites in one search”.

**3. Tabelul de prețuri e ilustrativ (manual)**
- Prețurile sunt marcate ca exemplu. În producție, **trebuie** alimentate cu date reale sau însoțite de data verificării. Altfel, un tabel de prețuri inventat e o afirmație falsă, iar motoarele AI îl pot cita ca fapt.

**4. „1,910 reviews” fără sursă (script)**
- Adaugă platforma: „1,910 reviews on Booking.com”.

### Minore
- Nu există imagini. O fotografie a unui hotel (cu `alt`, `width`, `height` și `loading="lazy"`) ar ajuta la Google Images și ar face pagina mai atractivă.
- Pagina există doar pe domeniul nou. Dacă get-rates.com are deja `/Best-Western-Hotels-Milan-bw-36_340.html`, cele două pagini concurează pe același cuvânt-cheie. Decide care e principala și pune canonical din cealaltă.

---

<a id="p-index"></a>
## 12. `index.html`: pagina de start Get Rates (nouă)

| Verificare | Rezultat |
|---|---|
| Titlu | „Get Rates \| Practical Services, Clearly Explained” (49) ✅ lungime |
| Meta description | 136 ✅ |
| Canonical, OG, Twitter, favicon, lang, viewport | ✅ toate prezente |
| H1 → H2 → H3 | ✅ ierarhie corectă |
| Cuvinte | **135** ⚠️ |
| Calitatea conținutului | 79/100 |

### Problema principală: conținutul nu descrie ce face Get Rates (manual)
- Pagina a fost creată ca schelet generic („Consultation / Delivery / Support”). Get Rates e însă un **comparator de prețuri pentru hoteluri**, iar pagina nu menționează nicăieri hoteluri, prețuri sau comparații.
- Titlul „Practical Services, Clearly Explained” nu se potrivește cu nicio căutare reală.
- **Soluția:** rescrie homepage-ul pe modelul `best-western-milan.html`:
  - H1 „Compare hotel prices from 100+ booking sites”;
  - cum funcționează;
  - destinații populare;
  - FAQ.
  Țintește 400–600 de cuvinte.

---

<a id="p-about"></a>
## 13. `about/index.html`

| Verificare | Rezultat |
|---|---|
| Titlu | „About Get Rates \| Who We Are and How We Work” (44) ✅ |
| Meta description | 101 ✅ |
| Tehnic | ✅ complet (canonical, OG, lang, ierarhie H1 → H2 → H3) |
| Cuvinte | **111** ⚠️ |

### Problema principală: lipsesc semnalele de încredere (manual)
- Pagina „About” e locul unde Google (E-E-A-T) și utilizatorii caută răspuns la „cine e în spatele site-ului?”. Acum are 3 principii generice („Clarity first”, „Respect for your time”, „Easy to reach”).
- **Ce lipsește:**
  - numele firmei care operează site-ul și țara;
  - de când funcționează;
  - de unde vin prețurile (API-uri de la OTA-uri, parteneriate de afiliere);
  - cum câștigi bani (comision de afiliere). Transparența asta e cerută și de Google, și de legislația UE;
  - o persoană de contact sau echipa.

---

<a id="p-contact"></a>
## 14. `contact/index.html`

| Verificare | Rezultat |
|---|---|
| Titlu | „Contact Get Rates \| Get a Free Consultation” (43) ✅ lungime |
| Meta description | 111 ✅ |
| Tehnic | ✅ complet |
| Cuvinte | **73** ⚠️ |

### Probleme (manual)
1. **Nu există date de contact reale:** nici e-mail, nici adresă, nici entitate juridică. O pagină de contact fără contact e un semnal negativ de încredere.
2. **„Get a Free Consultation” și „written quote”** vin din scheletul generic. Un comparator de hoteluri nu oferă consultanță, așa că textul nu corespunde serviciului.
3. **„We reply to every enquiry within one business day”** e o promisiune. Păstreaz-o doar dacă o poți respecta.

---

<a id="p-services"></a>
## 15. `services/index.html`

| Verificare | Rezultat |
|---|---|
| Titlu | „Services \| Get Rates” (**20 car.**) ⚠️ |
| Meta description | 136 ✅, dar `metadata_template.py` a semnalat „**brand_suffix_in_description**” ⚠️ |
| Tehnic | ✅ complet |
| Cuvinte | **165** ⚠️ |

### Probleme
1. **Titlu prea scurt și fără cuvânt-cheie (script).** „Services” nu corespunde niciunei căutări. **Propunere:** `Hotel Price Comparison: How Get Rates Works`.
2. **Numele mărcii în meta description (script, `metadata_template.py`).** „…support from **Get Rates**”: scriptul notează că brandul e deja în titlu și ocupă inutil spațiu în snippet.
3. **Conținut generic (manual).** Aceleași trei servicii ca pe homepage (Consultation / Delivery / Support), care nu au legătură cu compararea prețurilor la hoteluri. Pagina ar trebui să explice serviciile reale:
   - căutarea în mai multe OTA-uri;
   - alertele de preț;
   - newsletterul cu oferte.

---

<a id="p-404"></a>
## 16. `404.html`

| Verificare | Rezultat |
|---|---|
| Titlu | „Page Not Found \| Get Rates” (26) ✅ ok pentru 404 |
| Meta description | 49 car. ✅ ok pentru 404 |
| Robots | `noindex, follow` ✅ **corect** |
| Canonical | lipsește ✅ **corect** pentru 404 |
| Cuvinte | 26. `content_quality.py` semnalează „thin-content”, ceea ce e normal |

**Nu are probleme.** Singura recomandare: adaugă un câmp de căutare și 3–5 linkuri spre destinații populare. Utilizatorul care ajunge pe un URL greșit poate continua să caute în loc să plece.

Important: pe server, această pagină trebuie servită cu **cod HTTP 404**, nu 200. Nu am putut verifica acest lucru din fișier.

---

<a id="plan"></a>
## Plan de acțiune pe tot site-ul

| # | Prioritate | Acțiune | Pagini | Cum verifici |
|---|---|---|---|---|
| 1 | **Critic** | Repară `odometer.innerHTML = ;` | countriescr | Consola nu mai arată SyntaxError |
| 2 | **Critic** | Scoate hotelurile care nu mai sunt Best Western | psearchescr (și toate paginile de brand) | Fiecare hotel listat are numele brandului în numele actual |
| 3 | **Ridicat** | Canonical + alternate mobil/desktop (sau un site responsive cu 301) | toate cele 10 live | GSC → Inspectare URL: canonical ales = canonical declarat |
| 4 | **Ridicat** | H1 unic, primul titlu din pagină; popup-urile fără H3 | toate cele 10 live | Extensia HeadingsMap: H1 → H2 → H3, fără salturi |
| 5 | **Ridicat** | Corectează datele greșite: repere din alte orașe, descrieri ale altor hoteluri, „Asia”, blocul UK, „0 EUR” | nice, featured, grcountries, grbrandcountries, hbrandcr, psearchescr | Căutare în HTML după „Strasbourg”, „Acropolis Museum”, „Ferenbalm”, „Asia”, „United Kingdom”, „0 EUR” = 0 rezultate |
| 6 | **Ridicat** | `noindex` pe pagini brand × oraș cu sub 3 hoteluri și pe paginile POI fără text unic | hbrandcr, featured (și tipul lor) | GSC → Pagini: scad „Crawled – currently not indexed” |
| 7 | **Ridicat** | Cifre consecvente între titlu, text și blocuri | toate cele 10 live | Un singur număr per metrică pe fiecare pagină |
| 8 | Mediu | `<a href>` reale în loc de `javascript:void(0)` | toate cele 10 live | Screaming Frog găsește paginile de hotel prin crawl |
| 9 | Mediu | Elimină `_gaq`/`ga()`, păstrează doar GA4 | toate cele 10 live | Zero erori în consolă, evenimentele apar în GA4 DebugView |
| 10 | Mediu | Elimină „Guaranteed”, „80%”/„75%”, „No booking fee”, sau publică o pagină cu condițiile | toate paginile live + milan | Nu mai apar sau duc la o pagină de condiții |
| 11 | Mediu | Unifică reperele duplicate (Masséna, Belvedere, Stephansdom…) cu 301 | nice, psearchescr, countriescr | O singură pagină per reper |
| 12 | Mediu | jQuery 3.7 (sau fără), `defer`, un singur DatePicker, fără YUI | toate paginile live | Lighthouse: „Eliminate render-blocking resources” dispare |
| 13 | Mediu | `$(response).text()` în loc de `.appendTo()` | toate cele 10 live | Test: un răspuns `<img onerror=alert(1)>` nu se execută |
| 14 | Mediu | Rescrie homepage/about/contact/services pentru comparatorul de hoteluri | paginile noi | >300 de cuvinte, operatorul și contactul vizibile |
| 15 | Scăzut | Favicon, OG/Twitter; scoate `keywords`, `googlebot`, IE conditionals, AddThis | toate cele 10 live | Previzualizare corectă în Facebook Sharing Debugger |
| 16 | Scăzut | `width`/`height` pe imagini, `alt=""` pe iconițe decorative, `type="email"` + `<label>` | toate cele 10 live | Lighthouse Accessibility > 90, CLS < 0,1 |
| 17 | Scăzut | Filtrul de stele: `star3`/`star4`/`star5`/`star0` | paginile get-rates cu filtre | Filtrul pe 4 stele întoarce doar 4 stele |

**Ordinea recomandată:**
1. Punctele 1–2 (erori care afectează utilizatorii acum).
2. Punctele 3–4 (fundația de indexare).
3. Punctele 5–7 (încrederea în conținut).
4. Restul.

Punctele 3, 4, 8 și 9 sunt modificări **de șablon**: le faci o dată și se propagă pe toate paginile generate.
