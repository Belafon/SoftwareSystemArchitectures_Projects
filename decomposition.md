<!-- markdownlint-disable MD024 -->
# 3rd practicals - Decomposition

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

  - Zobraz notifikaci studentovi o aktivitě v chatu
  - Vytvoř email podle template a nahraď proměnné
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

  - Zobraz notifikaci studentovi o aktivitě v chatu
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
