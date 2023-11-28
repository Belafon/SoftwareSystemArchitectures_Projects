# Přiřazení zodpovědností ke kontejnerům/komponentám

Soubor je strukturován podle hierarchie kontejnerů/komponentů v C4 modelu.

## Komunikace

### Webová Aplikace Komunikace

#### Správa Chatu

- Aktualizace chatu pro nové zprávy.

#### Cache zpráv

- Uložení nové zprávy do cache

### Server Komunikace

#### Správa zpráv

- Ukončení chatu a smazání historie z databáze po ukončení projektu.

#### Správa chat logů

- Uložení nové zprávy do cache a databáze.

### Databáze Chatů

## Management Projektu

### Webová aplikace Management Projektu

- Zobrazení jenotlivých stránek modulu Projekty.

### Správa projektu

#### Manager notifikaci

- Zobrazení hlášení s potvrzením zápisu studenta do projektu. 

#### Repository projektu

- Ukládání souborů nahraných uživatelem systému.
- Vytvorenie dotazu na databázu na získanie informácií o správnom projekte.
- Správne zobrazenie histórie úprav.

#### Kontrola a Validace

- Kontrola a validace dat před uložením do databáze.

#### Student Gateway

- Zápis studenta do projektu.
- Zobrazení seznamu přihlášených projektů studenta.
- Získání seznamu projektů.
- Kontrola, zda kapacita projektu dovoluje zápis dalšího studenta.
- Kontrola, zda student splňuje požadavky projektu.
- Kontrola, zda student již není zapsán do projektu.

#### Gateway učitele

- Vytvoření nového projektu.
- Oznaceni projektu jako `Obsazený`.
- Získání seznamu projektů.

### Databáze projektu
