workspace "NSWI130" {

    model {
    
        properties {
            "structurizr.groupSeparator" "/"
        }
        pro = softwareSystem "Projekty" {

            group "Komunikace" {
                // TODO: přidat logiku pro správu chatů - tvorba nových chatů, přidávání/odebírání uživatelů z chatu, zobrazení historie chatu,...
                // TODO: přidat vztahy s Student a Učitel s UI
                komunikaceWebApp = container "Webová Aplikace Komunikace" "" "" {
                    group "Presentation Layer"  {
                        chatUI = component "Chat UI" "Zobrazení okénka chatu"
                        notifikaceUI = component "Notifikace UI" "Zobrazení notifikací"
                    }
                    group "Business Layer"  {
                        websocketKlient = component "WebSocket Klient" "Zajišťuje komunikaci s WebSocket serverem"
                        ziskaniChatu = component "Získání chatu" "Získává chaty z cache nebo serveru"
                    }
                    group "Persistence Layer"  {
                        chatCache = component "Cache zpráv" "Cachování zpráv pro rychlejší zobrazení a kontrola aktuálnosti dat"
                    }
                    // Vztahy pro Webovou Aplikaci
                    chatUI -> websocketKlient : "zobrazuje uživatelské rozhraní"
                    notifikaceUI -> websocketKlient : "přijímá notifikace"
                    websocketKlient -> ziskaniChatu : "žádá o data"
                    ziskaniChatu -> websocketKlient : "posílá data"
                    ziskaniChatu -> chatCache : "čte data"
                    chatCache -> ziskaniChatu : "poskytuje data"
                }

                komunikaceServer = container "Server Komunikace" "" "" {
                    group "Business Layer"  {
                        websocketServer = component "WebSocket Server" "Zajišťuje komunikaci s webovou aplikací"
                        kontrolaZprav = component "Kontrola zpráv" "Kontrola obsahu zpráv"
                        spravaZprav = component "Správa zpráv" "Zpracovává odeslání a příjem zpráv"
                        spravaChatLogu = component "Správa chat logů" 
                    }
                    group "Persistence Layer"  {
                        chatLogs = component "Chat logy" "Chat logy aktivních chatů"
                    }
                    // Vztahy pro Server Komunikace
                    websocketServer -> spravaZprav : "přijímá zprávy"
                    spravaZprav -> websocketServer : "odesílá zprávy a notifikace"
                    kontrolaZprav -> spravaZprav : "poskytuje výsledky kontroly"
                    spravaZprav -> kontrolaZprav : "žádá o kontrolu zpráv"
                    spravaZprav -> chatLogs : "ukládá zprávy"
                    chatLogs -> spravaZprav : "poskytuje historii chatu"
                }

                chatLogDatabaze = container "Databáze Chatů" "Ukládá a poskytuje data pro historii chatů"
                // Vztahy pro Databázi Chat Logů
                spravaChatLogu -> chatLogDatabaze : "ukládá data"
                chatLogDatabaze -> spravaChatLogu : "poskytuje data"
            }

            
            group "Management Projektu" {
                managmentProjektuUI = container "UI Správy projektů" "" "" {
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

                managmentProjektuServer = container "Server Správy projektů" "" "" {
                    group "Presentation Layer"  {
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

        managmentProjektu -> komunikace "Inicializuje chatovací místnost pro nový projekt"
        managmentProjektu -> databazeProjektu "Ukládá a načítá data projektu"
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
