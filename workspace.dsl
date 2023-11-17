workspace "NSWI130" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }

        student = person "Student" "Student"
        ucitel = person "Učitel" "Učitel"

        projekty = softwareSystem "Modul Projekty" {
            // TODO: přidat managementProjektuWebApp -> komunikaceWebApp: "přesměrovává na daný chat"
            // TODO: přidat do managementPrujektuServer něco, co si bude pamatovat id chatů, které pak zahrne v přesměrování
            group "Komunikace" {
                komunikaceWebApp = container "Webová Aplikace Komunikace" "" "" {
                    group "Presentation Layer"  {
                        chatUI = component "Chat UI" "Zobrazení okénka chatu"
                        notifikaceUI = component "Notifikace UI" "Zobrazení notifikací"
                    }
                    group "Business Layer"  {
                        komunikaceWebsocketKlient = component "WebSocket Klient" "Zajišťuje komunikaci s WebSocket serverem"
                        spravaChatu = component "Správa chatu" "Zajišťuje získání a odeslání zpráv"
                    }
                    group "Persistence Layer"  {
                        chatCache = component "Cache zpráv" "Cachování zpráv pro rychlejší zobrazení a kontrola aktuálnosti dat"
                    }
                    // Vztahy pro Webovou Aplikaci
                    chatUI -> spravaChatu  "odesílá zprávy"
                    spravaChatu -> chatUI  "zobrazuje zprávy"

                    spravaChatu -> notifikaceUI  "zobrazuje notifikace"

                    spravaChatu -> komunikaceWebsocketKlient  "žádá o data"
                    komunikaceWebsocketKlient -> spravaChatu  "poskytuje data"

                    spravaChatu -> chatCache  "cachuje data"
                    chatCache -> spravaChatu  "poskytuje data"
                }

                komunikaceServer = container "Server Komunikace" "" "" {
                    group "Business Layer"  {
                        komunikaceWebsocketServer = component "WebSocket Server" "Zajišťuje komunikaci s webovou aplikací"
                        kontrolaZprav = component "Kontrola zpráv" "Kontrola obsahu zpráv"
                        spravaZprav = component "Správa zpráv" "Zpracovává odeslání a příjem zpráv"
                        spravaChatLogu = component "Správa chat logů" 
                    }
                    group "Persistence Layer"  {
                        chatLogs = component "Chat logy" "Chat logy aktivních chatů"
                    }
                    // Vztahy pro Server Komunikace
                    spravaZprav -> komunikaceWebsocketServer  "odesílá zprávy a notifikace"
                    komunikaceWebsocketServer -> spravaZprav  "přijímá zprávy"

                    spravaZprav -> kontrolaZprav  "žádá o kontrolu zpráv"
                    kontrolaZprav -> spravaZprav  "poskytuje výsledky kontroly"

                    spravaZprav -> spravaChatLogu  "ukládá nové zprávy"
                    spravaChatLogu -> spravaZprav  "poskytuje historii chatu"

                    spravaChatLogu -> chatLogs  "ukládá data"
                    chatLogs -> spravaChatLogu  "poskytuje data"
                }

                chatLogDatabaze = container "Databáze Chatů" "Zálohuje a poskytuje data o historii chatů" {
                    // Vztahy pro Databázi Chat Logů
                    spravaChatLogu -> chatLogDatabaze  "zálohuje data"
                    chatLogDatabaze -> spravaChatLogu  "poskytuje data"
                }

                // Vztahy mezi kontejnery
                komunikaceWebsocketKlient -> komunikaceWebsocketServer  "komunikuje přes WebSocket"
                komunikaceWebsocketServer -> komunikaceWebsocketKlient  "komunikuje přes WebSocket"

                // Vztahy s uživateli
                student -> chatUI  "píše zprávy"
                ucitel -> chatUI  "píše zprávy"
                chatUI -> student  "zobrazuje zprávy"
                chatUI -> ucitel  "zobrazuje zprávy"
                notifikaceUI -> student  "zobrazuje notifikace"
                notifikaceUI -> ucitel  "zobrazuje notifikace"
            }
            
            group "Management Projektu" {
                managmentProjektuWebApp = container "Webová Aplikace Správa projektů" "" "" {
                    group "Presentation Layer"  {
                        group "Zobrazení pro učitele" {
                            formularProVytvoreniNovehoProjektu = component "Zobrazení formuláře pro založení projektu"
                            seznamVytvorenychProjektu = component "Zobrazení seznamu projektů, které učitel vytvořil"
                        }
                        group "Zobrazení pro studenta" {
                            seznamPrihlasenychProjektu = component "Zobrazení seznamu projektů, do kterých je student přihlášený"
                            seznamProjektuDoKterychSeMuzePrihlasit = component "Zobrazení seznamu projektů, do kterých se student může přihlásit"
                        }
                        // v deatilu projektu muze ucitel i student upravovat projekt, tedy pridavat a odstranovat soubory
                        detailProjektuUI = component "Zobrazení detailu projektu"
                        vyhledaniProjektuUI = component "Hledání projektu podle podmínek"
                        systemNotificationsUI = component "Zobrazení systémových notifikací"
                    }
                    group "Business Layer"  {
                        vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru = component "Vytvoreni dotazu na server pro ziskani seznamu projektu podle zadaneho filteru"
                    }
                }

                managmentProjektuServer = container "Server Správy projektů" "" "" {
                    group "Business Layer"  {
                        managerNotifikaci = component "Manager notifikaci"
                        group "Manager projektů" {
                            managerProjektu = component "Manager projektů"
                            kontrolaPodminekProPrihlaseniDoProjektu = component "Kontrola podmínek pro prihlaseni do projektu" "Kontrola splnění podmínek pro přihlášení do projektu"
                            kontrolaVytvoreniNovehoProjektu = component "Kontrola vytvoření nového projektu" "Kontrola jedinečnosti názvu projektu"
                        }
                        group "Vyhledávání projektů" {
                            seznamProjektu = component "Seznam projektu"
                            kontrolaFiltru = component "Kontrola Filtru" "Kontrola chyb ve vyplněných filtrech"
                        }
                    }
                    group "Persistence Layer"  {
                        tvorbaDotazuSpravaProjektu = component "Komunikace s databází"
                    }
                }

                editaceProjektuServer = container "Server Editace projektu" {
                    group "Business Layer" {
                        managerNotifikaciEditaceProjektu = component "Manager notifikaci"
                        group "Editor projektu" {
                            editaceProjektu = component "Editace projektu"
                            kontrolaSouboru = component "Kontrola souborů" "Kontrola formátu a správnosti vkládaných souborů"
                        }
                    }
                    group "Persistence Layer"  {
                        tvorbaDotazuEditaceProjektu = component "Komunikace s databází"
                    }
                }

                databazeProjektu = container "Databáze" "Ukládá a načítá data projektů" {
                    // Vztahy pro Databázi
                    tvorbaDotazuSpravaProjektu -> databazeProjektu : "provede dotaz"
                    databazeProjektu -> tvorbaDotazuSpravaProjektu : "poskytne výsledek dotazu"

                    tvorbaDotazuEditaceProjektu -> databazeProjektu : "provede dotaz"
                    databazeProjektu -> tvorbaDotazuEditaceProjektu : "poskytne výsledek dotazu"
                } 
                
             
                
                // seznam projektu
                // UI -> server
                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamProjektu "požadavek na získání seznamu přihlášených projektů podle filteru"
                // server -> UI 
                seznamProjektu -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "doručení seznamu projektů podle filteru" 

                seznamVytvorenychProjektu -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "požadavek na získání seznamu vytvorenych projektu"
                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamVytvorenychProjektu "doručení seznamu vytvořených projektů"

                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamProjektuDoKterychSeMuzePrihlasit "požadavek na získání seznamu projektů, do kterých se může student přihlásit"
                seznamProjektuDoKterychSeMuzePrihlasit -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "doručení seznamu projektů, do kterých se může student přihlásit"

                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamPrihlasenychProjektu "požadavek na získání seznamu přihlášených projektů"
                seznamPrihlasenychProjektu -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "doručení seznamu přihlášených projektů"

                vyhledaniProjektuUI -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "požadavek na získání seznamu projektů podle filteru"
                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> vyhledaniProjektuUI "doručení seznamu projektů podle filteru"

                seznamProjektu -> kontrolaFiltru "kontrola filtru"
                kontrolaFiltru -> tvorbaDotazuSpravaProjektu "požadavek na získání seznamu projektů dle filteru"
                tvorbaDotazuSpravaProjektu -> seznamProjektu "doručení seznamu projektů dle filteru"


                // detail projektu
                // UI -> server
                detailProjektuUI -> editaceProjektu "požadavek na získání informaci detailu projektu"
                editaceProjektu -> tvorbaDotazuEditaceProjektu "požadavek na získání informaci detailu projektu"
                tvorbaDotazuEditaceProjektu -> editaceProjektu "doručení informaci detailu projektu"
                // server -> UI
                editaceProjektu -> detailProjektuUI "doručení informaci detailu projektu"

                // uprava projektu
                detailProjektuUI -> editaceProjektu "přidání, nebo odstranění souboru"
                editaceProjektu -> kontrolaSouboru "kontrola souboru"
                kontrolaSouboru -> tvorbaDotazuEditaceProjektu "přidání, nebo odstranění souboru projektu"
                kontrolaSouboru -> managerNotifikaci "notifikace problému, nebo úspěchu editace projektu"

                // notifikace
                managerNotifikaci -> systemNotificationsUI "zobraz notifikaci"
                kontrolaFiltru -> managerNotifikaci "notifikace problému"
                kontrolaPodminekProPrihlaseniDoProjektu -> managerNotifikaci "notifikace problému"
                kontrolaSouboru -> managerNotifikaci "notifikace chyby při kontrole souboru"

                // prihlaseni se do projektu
                // UI -> server
                detailProjektuUI -> managerProjektu "přihlášení studenta do projektu"
                managerProjektu -> kontrolaPodminekProPrihlaseniDoProjektu "kontrola podmínek"
                kontrolaPodminekProPrihlaseniDoProjektu -> tvorbaDotazuSpravaProjektu "přidání studenta do projektu"
                kontrolaPodminekProPrihlaseniDoProjektu -> managerNotifikaci "notifikace úspěchu, či neúspěchu"
                
                formularProVytvoreniNovehoProjektu -> managerProjektu "vytvoření nového projektu"
                managerProjektu -> kontrolaVytvoreniNovehoProjektu "kontrola vytvoření nového projektu"
                kontrolaVytvoreniNovehoProjektu -> tvorbaDotazuSpravaProjektu "vytvoření nového projektu"
                kontrolaVytvoreniNovehoProjektu -> managerNotifikaci "notifikace úspěchu, či neúspěchu"

            }     
        }
    
        ucitel -> detailProjektuUI "Spravuje projekty"

        student -> detailProjektuUI "Přihlašuje se do nového projektu."
        student -> detailProjektuUI "Edituje projekt"
        
        systemNotificationsUI -> student "Zobrazuje notifikace o potvrzení přihlášení do projektu nebo změny souboru"
        systemNotificationsUI -> ucitel "Zobrazuje notifikace o potvrzení vytvoření projektu"


        ucitel -> projekty "Spravuje studentské projekty a komunikuje se studenty"
        student -> projekty "Přihlašuje se do projektů, pracuje na nich a komunikuje se svým učitelem a spolužáky"
    }
    
    // TODO: upravit views, aby všechno vypadalo ok (include, exclude,...)
    views {
        systemContext projekty "projektySystemContext" "Diagram systému" {
            include *
            autoLayout lr
        }

        container projekty "projektyContainer" "Diagram kontejnerů" {
            include *
            autoLayout lr
        }

        component komunikaceWebApp "komunikaceWebAppComponent" "Diagram komponent" {
            include *
            autoLayout lr
        }

        component komunikaceServer "komunikaceServerComponent" "Diagram komponent" {
            include *
            autoLayout lr
        }

        component managmentProjektuWebApp "managmentProjektuWebAppComponent" "Diagram komponent" {
            include *
            autoLayout lr
        }

        component managmentProjektuServer "managmentProjektuServerComponent" "Diagram komponent" {
            include *
            autoLayout lr
        }

        theme default
    }
}
