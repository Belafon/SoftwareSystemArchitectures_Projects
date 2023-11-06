workspace "NSWI130" {

    model {
    
        properties {
            "structurizr.groupSeparator" "/"
        }
        pro = softwareSystem "Projekty" {
            komunikace = container "Komunikace" "" "" {
                group "Presentation Layer"  {
                    chatUI = component "Chat User Interface" "Zobrazení okénka chatu"
                    notificationUI = component "Chat Notifications User Interface" "Zobrazení notifikací"
                }
                group "Business Layer"  {
                    kontrolaZprav = component "Kontrola zpráv"
                    startChatu = component "Zobrazení správného chatu pro tým"
                }
                group "Persistence Layer"  {
                    chatCache = component "Cachování zpráv"
                    chatLog = component "Chat log"
                }
            }
            
            managmentProjektu = container "Správa projektů" "" "" {
                group "Presentation Layer"  {
                    group "Zobrazení stránky projektu pro učitele" {
                        formular = component "Zobrazení formuláře pro založení projektu"
                    }
                    group "Zobrazení stránky projektu pro studenta" {
                         seznamPrihlasenychProjektu = component "Zobrazení seznamu přihlášených projektů "
                    }
                    detailProjektuUI = component "Zobrazení detailu projektu"
                    vyhledaniProjektuUI = component "Vyhledání projektů podle podmínek"
                    systemNotificationsUI = component "Zobrazení systémových notifikací"
                }
                group "Business Layer"  {
                    tvorbaDotazu = component "Tvorba dotazů na databázi"
                    group "Kontroly" {
                        kontrolaSouboru = component "Kontrola souborů" "Kontrola formátu a správnosti vkládaných souborů"
                        kontrolaFiltru = component "Kontrola Filtru" "Kontrola chyb ve vyplněných filtrech"
                        kontrolaPodminek = component "Kontrola Podmínek" "Kontrola splnění podmínek pro přihlášení do projektu"
                        kontrolaSpravnehoZobrazeni = component "Kontrola Zobrazení" "Kontrola zobrazení správných informacií"
                    }
                }
                group "Persistence Layer"  {
                    praceSDatabazi = component "Práce s databází"
                }
            }
            db = container "Databáze" "Ukládá data" "" "Database"
            chatDabataze = container "Chat Databáze" "Záloha chatu"
            kontrola = container "Kontrola" "Kontrola sql injection" ""
            
        }
        
        student = person "Student"
        ucitel = person "Teacher"
            

        chatLog -> chatCache "Zaloguje zprávu do Cache"
        chatCache -> kontrolaZprav "Odešle zprávu na kontrolu"
        startChatu -> chatUI "Aktualizuje chatové okno"
        startChatu -> notificationUI "Pošle notifikaci"
        
        kontrolaZprav -> chatDabataze "Odešle zprávu cachi mažéru"
        chatDabataze -> startChatu "posílá zprávy na zobrazení"
        
    


        managmentProjektu -> komunikace "Inicializuje chatovací místnost pro nový projekt"
        managmentProjektu -> db "Ukládá a načítá data projektu"
        komunikace -> kontrola "Kontroluje správnost zpráv v chatu"
        tvorbaDotazu -> kontrola "Kontroluje správnost sql dotazu"
        kontrolaZprav -> kontrola "Kontroluje správnost zpráv v chatu"
    
        kontrolaSouboru -> tvorbaDotazu "Pošle soubor na vytvoření dotazu"
        kontrolaFiltru -> kontrolaPodminek "Pošle správně vyplnené pole filtru na kontrolu podmínek"
        kontrolaPodminek -> tvorbaDotazu "Pošle informace na tvorbu dotazu"
        kontrola -> praceSDatabazi "Pošle hotový příkaz na databázi"
        vyhledaniProjektuUI -> kontrolaFiltru "Pošle filtry na kontrolu"
        seznamPrihlasenychProjektu -> tvorbaDotazu "Pošle informace na vytvoření dotazu"
        detailProjektuUI -> tvorbaDotazu "ošle informace na vytvoření dotazu"
        praceSDatabazi -> kontrolaSpravnehoZobrazeni
        kontrolaSpravnehoZobrazeni -> detailProjektuUI
        kontrolaSpravnehoZobrazeni -> seznamPrihlasenychProjektu
        kontrolaSpravnehoZobrazeni -> systemNotificationsUI
        kontrolaSpravnehoZobrazeni -> vyhledaniProjektuUI

    
        ucitel -> detailProjektuUI "Spravuje projekty"
        ucitel -> formular "Vytváří nový projekt"

        student -> detailProjektuUI "Přihlašuje se do nového projektu."
        student -> detailProjektuUI "Edituje projekt"
        systemNotificationsUI -> student "Zobrazuje notifikace o potvrzení přihlášení do projektu, nebo změny souboru"
        systemNotificationsUI -> ucitel "Zobrazuje notifikace o potvrzení vytvoření projektu"

        student -> chatUI "Píše zprávy do společného chatu projektu"
        chatUI -> student "Zobrazuje zprávy z chatu"
        ucitel -> chatUI "Píše zprávy do společného chatu projektu"
        chatUI -> ucitel "Zobrazuje zprávy z chatu"    
        notificationUI -> student "Zobrazuje notifikace"
        notificationUI -> ucitel "Zobrazuje notifikace"    
    }
    
    views {
        theme default
    }

}
