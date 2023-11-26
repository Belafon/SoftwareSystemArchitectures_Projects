### component "WebSocket Server" "Zajišťuje komunikaci s webovou aplikací"
- Zobrazení notifikace studentům z týmu o aktivitě v chatu.

### component "Správa chat logů" 
- Managment historie chatu - Uložení nové zprávy do databáze.

### component "Manager notifikaci" "Posila notifikaci studentovi"  
- Zobrazení hlášení s potvrzením zápisu studenta do projektu 
- Aktualizace chatu pro nové zprávy
- Ukončení chatu a smazání historie po ukončení projektu.


### component "Repository projektu" "Persists projekty v repositorii. Definuje rozhrani pro cteni a vytvareni projektu a poskytuje implmentaci rozhrani."
- Ukládání dat - Ukládání souborů nahraných uživatelem systému
- Zobrazenie detailu projektu - Vytvorenie dotazu na databázu na získanie informácií o správnom projekte
- Správne zobrazenie histórie úprav.

### component "Kontrola a Validace" "Provedeni kontroly a validace dat"
Kontrola a validace dat - Kontrola a validace dat před uložením do databáze

### component "Student Gateway" "Definuje rozhrani pro zapsani studentu do projektu a poskytuje implementaci rozhrani."
- Zápis studenta do projektu
- Zobrazení seznamu přihlášených projektů studenta
- Získání seznamu projektů
- Kontrola možnosti zápisu do projektu - 
  - Kontrola, zda kapacita projektu dovoluje zápis dalšího studenta.
  - Kontrola, zda student splňuje požadavky projektu.
  - Kontrola, zda student již není zapsán do projektu.

### component "Gateway ucitele" "Definuje rozhrani pro vypsani projektu a poskytuje implementaci rozhrani."
- Vytvoření nového projektu
- Oznaceni projektu jako `Obsazený`
- Získání seznamu projektů


### container "Management projektu pro studenty HTML" "Funkcionalita pro managaovani projektu studenty ve webovem prohlizeci" "HTML+JavaScript" "Web Front-End"
- Uživatelské rozhraní, Zobrazení jenotlivých stránek modulu Projekty.

### container "Management projektu pro ucitele HTML" "Funkcionalita pro managaovani projektu uciteli ve webovem prohlizeci" "HTML+JavaScript" "Web Front-End"
- Uživatelské rozhraní, Zobrazení jenotlivých stránek modulu Projekty.

### component "Cache zpráv" "Cachování zpráv pro rychlejší zobrazení a kontrola aktuálnosti dat"
- Uložení nové zprávy do cache (na straně klienta)