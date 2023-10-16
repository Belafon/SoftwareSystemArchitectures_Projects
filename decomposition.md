# Decomposition

## Responsibilities

### Feature: Příhlášení studenta do projektu

##### Uživatelské rozhraní

- Zobrazení jenotlivých stránek modulu Projekty.

##### Získání seznamu projektů

- Tvoraba dotazu na databázi pro získání seznamu projektů podle zadaných filtrů.
- Kontrola chyb v zadání filtrů.

##### Kontrola možnosti zápisu do projektu

- Kontrola, zda kapacita projektu dovoluje zápis dalšího studenta.
- Kontrola, zda student splňuje požadavky projektu.
- Kontrola, zda student již není zapsán do projektu.

##### Zápis studenta do projektu

- Zápis do databáze o zápisu studenta do projektu.

##### Zobrazení hlášení s potvrzením zápisu

- Zobrazení hlášení s potvrzením zápisu.

---

### Feature: Vypsání témat projektů

##### Databázové responsibilities.
- Vytvoření dotazu na databázi a vracení výsledku.
- Vložení nových dat do databáze a vracení výsledků o úspěšnosti akce(??).

##### Data Analysis responsibilities.
- Analýza výsledku.
- Na základě výsledků nabízení určitých možností, jak pokračovat.

##### ???? responsibilities.
- Uložení dat do nějaké cachi, než se rozhodne kam je dát.

---

### Feature: Prohlížení projektů učitelem

##### Ukládání dat

- Ukládání souborů nahraných uživatelem systému
- Ukládání informací o nahraných souborech spolu s id uživatele, který soubory nahrál

##### Autorizace

- Systém zobrazuje informace relevantní pro uživatele na základě přihlašovacích údajů

##### Reagování 

- Systém reaguje na kliknutí myší, vhodně zpracovává požadavky a hlásí případné chyby

---

### Feature: Potvrzení týmu projektu učitelem

##### Zobrazení seznamu přihlášených projektů studenta

- Vytvoření dotazu na databázi pro získání seznamu projektů, na kterých je student aktuálně přihlášený.

##### Zobrazení detailu projektu

- Vytvoření dotazu na databázi pro získání informací o správném projektu.

##### Managment historie chatu

- Uložení nové zprávy do databáze.
- Aktualizace chatu pro nové zprávy.
- Ukončení chatu a smazání historie po ukončení projektu.

##### Notifikace studentů

- Poslání emailu studentům z týmu o aktivitě v chatu.

---

### Feature: Komunikace v rámci týmu

##### Zobrazení seznamu přihlášených projektů studenta

- Vytvoření dotazu na databázi pro získání seznamu projektů, na kterých je student aktuálně přihlášený.

##### Zobrazení detailu projektu

- Vytvoření dotazu na databázi pro získání informací o správném projektu.

##### Managment historie chatu

- Uložení nové zprávy do databáze.
- Aktualizace chatu pro nové zprávy.
- Ukončení chatu a smazání historie po ukončení projektu.

##### Notifikace studentů

- Poslání emailu studentům z týmu o aktivitě v chatu.

---

### Feature: Správa projektov

##### Zobrazenie zoznamu prihlásených projektov študenta

- Vytvorenie dotazu na databázu na získanie zoznamu projektov, do ktorých je študent aktuálne prihlásený.

##### Zobrazenie detailu projektu

- Vytvorenie dotazu na databázu na získanie informácií o správnom projekte.
- Správne zobrazenie histórie úprav.

##### Notifikácie študentov

- Poslanie emailu študentom z tímu o počte zostávajúcich pokusov.

---

## First decomposition

○ Coincidental
○ Primitive data – related by manipulating the same kind of primitive data
○ Temporal – related by timing dependencies, such as being executed simultaneously
○ Procedural – related by executing in a particular order but without direct communication
○ Communication – related by communication chain contributing to some shared output
○ Sequential – related by interaction where the output of one is the input of the other
○ Information – related by operation on the same business entity
○ Functional – inseparable as they contribute to a single well-defined function

## Second decomposition