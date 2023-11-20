<!-- markdownlint-disable MD024 -->
# 3rd practicals - Decomposition

## Responsibilities

### Feature: Příhlášení studenta do projektu

#### Uživatelské rozhraní

- Zobrazení jenotlivých stránek modulu Projekty.

#### Získání seznamu projektů

- Tvoraba dotazu na databázi pro získání seznamu projektů podle zadaných filtrů.
- Kontrola chyb v zadání filtrů.

#### Kontrola možnosti zápisu do projektu

- Kontrola, zda kapacita projektu dovoluje zápis dalšího studenta.
- Kontrola, zda student splňuje požadavky projektu.
- Kontrola, zda student již není zapsán do projektu.

#### Zápis studenta do projektu

- Zápis do databáze o zápisu studenta do projektu.

#### Zobrazení hlášení s potvrzením zápisu

- Zobrazení hlášení s potvrzením zápisu.

---

### Feature: Vypsání témat projektů

#### Databázové responsibilities

- Vytvoření dotazu na databázi a vracení výsledku.
- Vložení nových dat do databáze a vracení výsledků o úspěšnosti akce(??).

#### Data Analysis responsibilities

- Analýza výsledku.
- Na základě výsledků nabízení určitých možností, jak pokračovat.

#### ???? responsibilities

- Uložení dat do nějaké cachi, než se rozhodne kam je dát.

---

### Feature: Prohlížení projektů učitelem

#### Ukládání dat

- Ukládání souborů nahraných uživatelem systému
- Ukládání informací o nahraných souborech spolu s id uživatele, který soubory nahrál

#### Autorizace

- Systém zobrazuje informace relevantní pro uživatele na základě přihlašovacích údajů

#### Reagování

- Systém reaguje na kliknutí myší, vhodně zpracovává požadavky a hlásí případné chyby

---

### Feature: Potvrzení týmu projektu učitelem

#### Zobrazení seznamu přihlášených projektů studenta

- Vytvoření dotazu na databázi pro získání seznamu projektů, na kterých je student aktuálně přihlášený.

#### Zobrazení detailu projektu

- Vytvoření dotazu na databázi pro získání informací o správném projektu.

#### Managment historie chatu

- Uložení nové zprávy do databáze.
- Aktualizace chatu pro nové zprávy.
- Ukončení chatu a smazání historie po ukončení projektu.

#### Notifikace studentů

- Poslání emailu studentům z týmu o aktivitě v chatu.

---

### Feature: Komunikace v rámci týmu

#### Zobrazení seznamu přihlášených projektů studenta

- Vytvoření dotazu na databázi pro získání seznamu projektů, na kterých je student aktuálně přihlášený.

#### Zobrazení detailu projektu

- Vytvoření dotazu na databázi pro získání informací o správném projektu.

#### Managment historie chatu

- Uložení nové zprávy do databáze.
- Aktualizace chatu pro nové zprávy.
- Ukončení chatu a smazání historie po ukončení projektu.

#### Notifikace studentů

- Poslání emailu studentům z týmu o aktivitě v chatu.

---

### Feature: Správa projektov

#### Zobrazenie zoznamu prihlásených projektov študenta

- Vytvorenie dotazu na databázu na získanie zoznamu projektov, do ktorých je študent aktuálne prihlásený.

#### Zobrazenie detailu projektu

- Vytvorenie dotazu na databázu na získanie informácií o správnom projekte.
- Správne zobrazenie histórie úprav.

#### Notifikácie študentov

- Poslanie emailu študentom z tímu o počte zostávajúcich pokusov.

---

## Notes

### First decomposition

- Coincidental
- Primitive data – related by manipulating the same kind of primitive data
- Temporal – related by timing dependencies, such as being executed simultaneously
- Procedural – related by executing in a particular order but without direct communication
- Communication – related by communication chain contributing to some shared output
- Sequential – related by interaction where the output of one is the input of the other
- Information – related by operation on the same business entity
- Functional – inseparable as they contribute to a single well-defined function

### Second decomposition

- Consider also cohesion based on the technical layer of responsibilities
  - Presentation logic
  - Application logic
  - Domain (business) logic
  - Persistence (database) logic
- It is possible that you will discover new responsibilities

### Homework

- Finish the second decomposition
- Document it in the form of a list of modules, optionally with submodules and their assigned responsibilities
- Distinguish runtime entities/applications/services
- Use disagreements within the team to create a variant decomposition design

---

## Decomposition

### First variant

#### Chat log

- Přijmi zprávu odeslanou studentem do jeho týmového chatu
- Pravidelně předej aktualizovaný chat log databázi
- Odešli zprávu do chatu týmu
- Ukonči chat a smaž historii po ukončení projektu
- Zobraz chat log
- Konstatně hlídej, zda nepřišla nová zpráva do chatu
- Po hodině nezobrazení chatu, odešli upozornění o nové zprávě

#### Notifikace

- Emailová
  - Odeštli email studentovi o aktivitě v chatu
  - Vytvoř email podle template a nahraď proměnné
- Systémová
  - Zobraz zprávu o úspěšném zápisu do projektu
  - Zobraz chybovou zprávu o neúspěšném zápisu do projektu
  - Zobraz chybovou hlášku

#### Databáze

- Kontrola SQL injection
- Tvorba dotazu na databázi z předaných parametrů (filtrů)
- Zápis studenta do projektu
- Získání seznamu projektů

#### Uživatelské rozhraní

- Zobrazení jenotlivých stránek modulu Projekty
- Zobrazení seznamu projektů
- Zobrazení chatu

#### Kontorla

- Kontrola, zda kapacita projektu dovoluje zápis dalšího studenta
- Kontrola, zda student splňuje požadavky projektu
- Kontrola, zda student již není zapsán do projektu

#### Statistické reporty

---

### Second variant

#### Chat log

- Přijmi zprávu odeslanou studentem do jeho týmového chatu
- Pravidelně předej aktualizovaný chat log cache
- Odešli zprávu do chatu týmu
- Ukonči chat a smaž historii po ukončení projektu
- Zobraz chat log
- Konstatně hlídej, zda nepřišla nová zpráva do chatu
- Po hodině nezobrazení chatu, odešli upozornění o nové zprávě

#### Chat uživatelské rozhraní

- Zobrazení chatu

#### Chat cache

- Přijmi aktualizovaný log chat
- Načti historii chatu z databáze
- Ulož historii do databáze
  
#### Notifikace

- Emailová
  - Odeštli email studentovi o aktivitě v chatu
  - Vytvoř email podle template a nahraď proměnné
- Systémová
  - Zobraz zprávu o úspěšném zápisu do projektu
  - Zobraz chybovou zprávu o neúspěšném zápisu do projektu
  - Zobraz chybovou hlášku

#### Databáze

- Kontrola SQL injection
- Tvorba dotazu na databázi z předaných parametrů (filtrů)
- Zápis studenta do projektu
- Získání seznamu projektů

#### Uživatelské rozhraní

- Zobrazení jenotlivých stránek modulu Projekty
- Zobrazení seznamu projektů

#### Kontorla

- Kontrola, zda kapacita projektu dovoluje zápis dalšího studenta
- Kontrola, zda student splňuje požadavky projektu
- Kontrola, zda student již není zapsán do projektu

#### Statistické reporty
