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

### Feature: Vypsání témat projektů.

Jako učitel chci mít možnost vypsat témata projektů, aby se studenti mohli přihlásit do nich. (zapsat si ...)

#### Feature breakdown

**Předpoklady:**

- `Učitel` je přihlášen do systému jako učitel.

**Možné stavy projektu**
- Otevřený: `Student` se do projektu může přihlásit.
- Obsazený: Nikdo se nemůže přihlásit do projektu, protože už je potvrzen tým_projekt a aktivně pracují.
- Uzavřený: projekt je vypsán a dá se ho prohlížet, nejde se ale přihlašovat.
- Ukončený: práce nad projektem je již ukončena.
- Neaktivní: nikdo se do projektu nepřihlásil a vypršel čas na přihlášení.

**Normální interakce:**
* 1\. `Učitel` otevře modul Projekty.
* 2\. `Učitel` zmáčkne tlačítko `Vytvořit nový projekt`.
* 3\. Systém zobrazí formulář a `Učitel` vyplní všechny potřebné detaily projektu.
* 4\. `Učitel` potvrdí vytvoření projektu zmáčknutím tlačítka `potvrdit a vytvořit`.
* 5\. Systém ověří, zda projekt už existuje a je otevřený.
* 6\. Jestli neexistuje: <br>
    * a) Systém přidá nový projekt k uzavřeným. <br>
    * b) Systém vrátí, že projekt byl úspěšně vytvořen a nabidne otevřít projekt.<br>
    * c) Jestli `Učitel` chce otevřít projekt.<br>
        * I. Systém přidá projekt k otevřeným.<br>
        * II. Systém vrátí, že projekt byl úspěšně otevře a `Student`i se mohou přihlásit.<br>
        * III. Systém se přepne na hlavní stránku modulu Projekty.<br>
    * d) Jestli nechce:<br>
        * I. `Učitel` zmáčkne tlačítko `Nechat uzavřený` a Systém se přepne na hlavní stránku modulu.
* 7\. Jestli existuje:
     * a) Systém vrátí, že projekt už existuje a jestli `Učitel` chce pokračovat a vytvořit projekt, musí změnit název, ...
        * I. Jestli `Učitel` chybně zadal detaily a popis projektu, který už existuje, zmáčkne `Vrátit se na začátek` nebo `Vrátit se na modul Projekty`.
        * II. Jestli učitel chce pokračovat, změní potřebné detaily projektu a vrátí se na krok 4. 

#### Responsibilities

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

Jako učitel chci prohlížet projekty, abych mohl zkontrolovat práci studentů.

#### Feature breakdown

**Předpoklady:**

- `Učitel` je přihlášen do systému jako učitel.

**Interakce:**

1. `Učitel` otevře modul Projekty.
2. `Systém` zobrazí hlavní stránku modulu Projekty: seznam projektů, u nichž je `Učitel` vedoucím.
3. `Učitel` klikne na požadovaný projekt.
4. `Systém` zobrazí detailní informace o projektu včetně seznamu zapsaných studentů a nahraných souborů.
5. `Učitel` klikne na jeden ze zobrazených souborů:
	-  `Systém` zobrazí soubor a informace o tom kdo a kdy ten soubor nahrál.
6.  `Učitel` klikne na uživatelské jméno studenta:
	-  `Systém` zobrazí profil studenta včetně jeho jména, id, ročníku a času, kdy byl do projektu zapsán.

#### Responsibilities

##### Ukládání dat

- Ukládání souborů nahraných uživatelem systému
- Ukládání informací o nahraných souborech spolu s id uživatele, který soubory nahrál

##### Autorizace

- Systém zobrazuje informace relevantní pro uživatele na základě přihlašovacích údajů

##### Reagování 

- Systém reaguje na kliknutí myší, vhodně zpracovává požadavky a hlásí případné chyby

---

### Feature: Potvrzení týmu projektu učitelem

Jako učitel chci mít možnost označit projekt za `obsazený`. To znamená, že se do projektu již nemůže přihlásit žádný student, tým_projekt je potvrzený a aktivně se na něm pracuje. 

#### Feature breakdown

**Předpoklady:**

- `Učitel` je přihlášen do systému jako učitel.

**Interakce:**

1. `Učitel` otevře modul Projekty.
2. `Systém` zobrazí hlavní stránku modulu Projekty: seznam projektů, u nichž je `Učitel` vedoucím a u každého projektu je uveden jeho stav.
3. `Učitel` klikne na požadovaný projekt se stavem `Otevřený`.
4. `Systém` zobrazí detailní informace o projektu včetně seznamu zapsaných studentů.
5. `Učitel` zkontroluje stav týmu a klikne na tlačítko `Potvrdit tým`.
6. `Systém` změní stav projektu na `Obsazený` a zobrazí hlášení s potvrzením.
#### Responsibilities

##### Databáze responsibilities.
- Vytvoření dotazu na databázi, vracení výsledku, nebo změna dat v databázi.

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
 
---

### Feature: Správa projektov

Ako študent viem svoje riešenie upraviť aspoň 50x a viem si pozrieť všetky svoje odovzdané verzie.

#### Feature breakdown

**Předpoklady:**

- `Student` je prihlásený do systému ako student.

**Normální interakce:**

1.	`Student` otvorí zložku projekty.
2.	`Systém`  zobrazí hlavnú stránku modulu Projekty – všetky projekty, do ktorých je študent prihlásený.
3.	`Student` klikne na projekt, v ktorom chce vykonávať zmeny.
4.	`Systém` zobrazí podrobnosti projektu.
5.	`Student` klikne na tlačidlo upraviť.
6.	`Systém` zobrazí najnovšiu verziu v editovateľnom móde. (V prípade, že chce vytvoriť nové riešenie, zobrazí sa mu novovytvorený prázdny dokument.)
7.	Po skončení úprav `Student` klikne na 
a.	Uložiť zmeny a `Systém`  vytvorí v databáze nový súbor so zaznamenanými zmenami a zobrazí podrobnosti projektu.
b.	Zrušiť a `Systém` zobrazí podrobnosti projektu.
8.	`Student` klikne na zobraziť históriu úprav aby si mohol prezrieť svoje odovzdané riešenia.
9.	`Systém` zobrazí tabuľku, v ktorej bude kto, kedy a čo upravil. Po kliknutí na riadok v tabuľke systém zobrazí vybratú a predchádzajúcu verziu a vyznačí, kde nastali zmeny.
10.	Keď bude odovzdaných 50 verzií, `Student` môže požiadať učiteľa o navýšenie počtu možných odovzdaných riešení.

#### Responsibilities

##### Zobrazenie zoznamu prihlásených projektov študenta

- Vytvorenie dotazu na databázu na získanie zoznamu projektov, do ktorých je študent aktuálne prihlásený.

##### Zobrazenie detailu projektu

- Vytvorenie dotazu na databázu na získanie informácií o správnom projekte.
- Správne zobrazenie histórie úprav.

##### Notifikácie študentov

- Poslanie emailu študentom z tímu o počte zostávajúcich pokusov.


