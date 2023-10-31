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
                        
                    }
                    
                    systemNotificationsUI = component "Zobrazení systémových notifikací"
                }
                group "Business Layer"  {
                    tvorbaDotazu = component "Tvorba dotazů na databázi"
                    group "Kontroly" {
                        
                    }
                }
                group "Persistence Layer"  {
                    
                }
            }
            db = container "Databáze" "Ukládá data" "" "Database"
            cache = container "Chat cache" "Záloha chatu"
            kontrola = container "Kontrola" "Kontrola správnosti dat" ""
            
        }
        
        student = person "Student"
        ucitel = person "Teacher"
        
    }
    
    views {
        theme default
    }

}
