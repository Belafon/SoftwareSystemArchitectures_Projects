workspace "NSWI130" {

    model {
    
        properties {
            "structurizr.groupSeparator" "/"
        }
        pro = softwareSystem "Projekty" {

            group "Komunikace" {
                komunikaceUI = container "UI Komunikace" "" "" {
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

                komunikaceServer = container "Server Komunikace" "" "" {
                    group "Presentation Layer"  {
                        chatServerUI = component "Chat Server User Interface" "Zobrazení okénka chatu"
                    }
                    group "Business Layer"  {
                        komunikace = component "Komunikace" "Komunikace mezi uživateli"
                    }
                    group "Persistence Layer"  {
                    }
                }

                databazeChatu = container "Chat Databáze" "Záloha chatu"
            }
            
            group "Management Projektu" {
                managmentProjektuUI = container "UI Správy projektů" "" "" {
                    group "Presentation Layer"  {
                        group "Zobrazení stránky projektu pro učitele" {
                            formular = component "Zobrazení formuláře pro založení projektu"
                            seznamVytvorenychProjektu = component "Zobrazení seznamu vytvorenych projektu"
                        }
                        group "Zobrazení stránky projektu pro studenta" {
                            seznamPrihlasenychProjektu = component "Zobrazení seznamu přihlášených projektů "
                        }
                        // v deatilu projektu muze ucitel i student upravovat projekt, tedy pridavat a odstranovat soubory
                        detailProjektuUI = component "Zobrazení detailu projektu"
                        vyhledaniProjektuUI = component "Vyhledání projektů podle podmínek"
                        systemNotificationsUI = component "Zobrazení systémových notifikací"
                    }
                    group "Business Layer"  {
                    }
                    group "Persistence Layer"  {
                    }
                }

                managmentProjektuServer = container "Server Správy projektů" "" "" {
                    group "Presentation Layer" {
                        managmentProjektuServerUI = component "Správa projektů Server User Interface" "Zobrazení stránky projektu pro učitele"
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

                databazeProjektu = container "Databáze" "Ukládá data" "" "Database"
            }            
        }
        
        student = person "Student"
        ucitel = person "Teacher"
            

        chatLog -> chatCache "Zaloguje zprávu do Cache"
        chatCache -> kontrolaZprav "Odešle zprávu na kontrolu"
        startChatu -> chatUI "Aktualizuje chatové okno"
        startChatu -> notificationUI "Pošle notifikaci"
        
        kontrolaZprav -> databazeChatu "Odešle zprávu cachi mažéru"
        databazeChatu -> startChatu "posílá zprávy na zobrazení"
        
    

        managmentProjektuServer -> komunikace "Inicializuje chatovací místnost pro nový projekt"
        managmentProjektuServer -> databazeProjektu "Ukládá a načítá data projektu"
        //komunikace -> kontrola "Kontroluje správnost zpráv v chatu"
        //tvorbaDotazu -> kontrola "Kontroluje správnost sql dotazu"
        //kontrolaZprav -> kontrola "Kontroluje správnost zpráv v chatu"
    
        kontrolaSouboru -> tvorbaDotazu "Pošle soubor na vytvoření dotazu"
        kontrolaFiltru -> kontrolaPodminek "Pošle správně vyplnené pole filtru na kontrolu podmínek"
        kontrolaPodminek -> tvorbaDotazu "Pošle informace na tvorbu dotazu"
        //kontrola -> praceSDatabazi "Pošle hotový příkaz na databázi"
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
