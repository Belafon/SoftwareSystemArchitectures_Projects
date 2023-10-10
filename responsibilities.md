# Projects (PRO)

## Core features and responsibilities

### Feature: Příhlášení studenta do projektu

Jako student se chci být schopen se přihlásit do projektu, abych mohl pracovat na projektu.

#### Feature breakdown

**Předpoklady:**

- `Student` je přihlášen do systému jako student.

**Normální interakce:**

1. `Student` otevře modul Projekty.
2. `Systém` zobrazí hlavní stránku modulu Projekty.
3. `Student` klikne na tlačítko `Přihlásit se do projektu`.
4. `Systém` zobrazí filtrovací formulář projektů.
5. `Student` vyplní filtrovací formulář projektů.
6. `Student` klikne na tlačítko `Zobrazit`.
7. `Systém` zobrazí seznam projektů, které odpovídají filtrovacímu formuláři.
8. `Student` klikne na požadovalý projekt.
9. `Systém` zobrazí detail projektu.
10. `Student` klikne na tlačítko `Zapsat se`.
11. `Systém` zapíše studenta do projektu.
12. `Systém` zobrazí hlášení s potvrzením zápisu.

**Co se může pokazit:**	

7. Filtrům neodpoovídají žádné projekty. `Systém` zobrazí hlášení, že nebyly nalezeny žádné projekty. `Student` může upravit filtrovací formulář a pokračovat od bodu 6.

#### Responsibilities

##### Získání seznamu projektů

- Tvoraba dotazu na databázi pro získání seznamu projektů podle zadaných filtrů.
- Kontrola chyb v zadání filtrů.

##### Kontrola možnosti zápisu do projektu

- Kontrola, zda kapacita projektu dovoluje zápis dalšího studenta.
- Kontrola, zda student splňuje požadavky projektu.
- Kontrola, zda student již není zapsán do projektu.

---

### Feature:

<!-- The feature described in a form of a user story -->

#### Feature breakdown

<!-- The feature breakdown -->

#### Responsibilities

<!-- A ##### section for each group of responsibilities -->

---

### Feature:

<!-- The feature described in a form of a user story -->

#### Feature breakdown

<!-- The feature breakdown -->

#### Responsibilities

<!-- A ##### section for each group of responsibilities -->

---

### Feature:

<!-- The feature described in a form of a user story -->

#### Feature breakdown

<!-- The feature breakdown -->

#### Responsibilities

<!-- A ##### section for each group of responsibilities -->

---

### Feature:

<!-- The feature described in a form of a user story -->

#### Feature breakdown

<!-- The feature breakdown -->

#### Responsibilities

<!-- A ##### section for each group of responsibilities -->

---

### Feature: Komunikace v rámci týmu

Jako student chci mít možnost komunikovat s lidmi ze svého týmu, abychom si mohli rozdělit práci a domluvit se na podrobnostech.

#### Feature breakdown

**Předpoklady:**

- `Student` je přihlášen do systému jako student.

**Normální interakce:**

1. `Student` otevře modul Projekty.
2. `Systém` zobrazí hlavní stránku modulu Projekty, včetně seznamu projektů, na kterých je student již přihlášen.
3. `Student` vybere kliknutím konkrétní projekt ze seznamu.
4. `Systém` zobrazí detail projektu.
5. `Student` klikne na možnost `Chat`.
6. `Systém` zobrazí chatové okno včetně historie a textového pole na novou zprávu.
7. `Student` napíše do textového pole novou zprávu.
8. `Student` klikne na tlačítko `Odeslat`.
9. `Systém` uloží zprávu do historie.
10. `Systém` odešle upozornění emailem ostatním studentům z týmu o nové zprávě.
11. `Student` zavře chatové okno křížkem.

#### Responsibilities

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
