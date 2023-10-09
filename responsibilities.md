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

### Feature:

<!-- The feature described in a form of a user story -->

#### Feature breakdown

<!-- The feature breakdown -->

#### Responsibilities

<!-- A ##### section for each group of responsibilities -->