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
                    }
                }
                group "Persistence Layer"  {
                    praceSDatabazi = component "Práce s databází"
                }
            }
            db = container "Databáze" "Ukládá data" "" "Database"
            cache = container "Chat cache" "Záloha chatu"
            kontrola = container "Kontrola" "Kontrola správnosti dat" ""
            
        }
        
        student = person "Student"
        ucitel = person "Teacher"
            

        chatLog -> chatCache "Zaloguje zprávu do Cache"
        chatCache -> kontrolaZprav "Odešle zprávu na kontrolu"
        startChatu -> chatUI "Aktualizuje chatové okno"
        startChatu -> notificationUI "Pošle notifikaci"
        
        kontrolaZprav -> chatDabataze "Odešle zprávu cachi mažéru"
        chatDabataze -> startChatu "posílá zprávy na zobrazení"
    }
    
    views {
        theme default
    }

}

}
