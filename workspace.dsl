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
                    chatUI -> spravaChatu : "odesílá zprávy"
                    spravaChatu -> chatUI : "zobrazuje zprávy"

                    spravaChatu -> notifikaceUI : "zobrazuje notifikace"

                    spravaChatu -> komunikaceWebsocketKlient : "žádá o data"
                    komunikaceWebsocketKlient -> spravaChatu : "poskytuje data"

                    spravaChatu -> chatCache : "cachuje data"
                    chatCache -> spravaChatu : "poskytuje data"
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
                    spravaZprav -> komunikaceWebsocketServer : "odesílá zprávy a notifikace"
                    komunikaceWebsocketServer -> spravaZprav : "přijímá zprávy"

                    spravaZprav -> kontrolaZprav : "žádá o kontrolu zpráv"
                    kontrolaZprav -> spravaZprav : "poskytuje výsledky kontroly"

                    spravaZprav -> spravaChatLogu : "ukládá nové zprávy"
                    spravaChatLogu -> spravaZprav : "poskytuje historii chatu"

                    spravaChatLogu -> chatLogs : "ukládá data"
                    chatLogs -> spravaChatLogu : "poskytuje data"
                }

                chatLogDatabaze = container "Databáze Chatů" "Zálohuje a poskytuje data o historii chatů" {
                    // Vztahy pro Databázi Chat Logů
                    spravaChatLogu -> chatLogDatabaze : "zálohuje data"
                    chatLogDatabaze -> spravaChatLogu : "poskytuje data"
                }

                // Vztahy mezi kontejnery
                komunikaceWebsocketKlient -> komunikaceWebsocketServer : "komunikuje přes WebSocket"
                komunikaceWebsocketServer -> komunikaceWebsocketKlient : "komunikuje přes WebSocket"

                // Vztahy s uživateli
                student -> chatUI : "píše zprávy"
                ucitel -> chatUI : "píše zprávy"
                chatUI -> student : "zobrazuje zprávy"
                chatUI -> ucitel : "zobrazuje zprávy"
                notifikaceUI -> student : "zobrazuje notifikace"
                notifikaceUI -> ucitel : "zobrazuje notifikace"
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
                        vyhledaniProjektuUI = component "Hladání projektu podle podmínek"
                        systemNotificationsUI = component "Zobrazení systémových notifikací"
                    }
                    group "Business Layer"  {
                        vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru = component "Vytvoreni dotazu na server pro ziskani seznamu projektu podle zadaneho filteru"
                    }
                }

                managmentProjektuServer = container "Server Správy projektů" "" "" {
                    group "Business Layer"  {
                        managerNotifikaci = component "Manager notifikaci"
                        seznamProjektu = component "Seznam projektu"
                        editaceProjektu = component "Editace projektu"
                        managerProjektu = component "Manager projektů"
                        
                        group "Kontroly" {
                            kontrolaSouboru = component "Kontrola souborů" "Kontrola formátu a správnosti vkládaných souborů"
                            kontrolaFiltru = component "Kontrola Filtru" "Kontrola chyb ve vyplněných filtrech"
                            kontrolaPodminekProPrihlaseniDoProjektu = component "Kontrola podmínek pro prihlaseni do projektu" "Kontrola splnění podmínek pro přihlášení do projektu"
                            kontrolaVytvoreniNovehoProjektu = component "Kontrola vytvoření nového projektu" "Kontrola jedinečnosti názvu projektu"
                        }

                        tvorbaDotazu = component "Komunikace s databází"
                    }
                }

                databazeProjektu = container "Databáze" "Ukládá a načítá data projektů" {
                    // Vztahy pro Databázi
                    tvorbaDotazu -> databazeProjektu : "provede dotaz"
                    databazeProjektu -> tvorbaDotazu : "poskytne výsledek dotazu"
                } 
                
             
                
                // seznam projektu
                // UI -> server
                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamProjektu "pozadavek na ziskani seznamu prihlasenych projektu podle filteru"
                // server -> UI 
                seznamProjektu -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "doruceni seznamu projektu podle filteru" 

                seznamVytvorenychProjektu -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "pozadavek na ziskani seznamu vytvorenych projektu"
                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamVytvorenychProjektu "doruceni seznamu vytvorenych projektu"

                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamProjektuDoKterychSeMuzePrihlasit "pozadavek na ziskani seznamu projektu do kterych se uze student prihlasit"
                seznamProjektuDoKterychSeMuzePrihlasit -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "doruceni seznamu projektu do kterych se uze student prihlasit"

                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamPrihlasenychProjektu "pozadavek na ziskani seznamu prihlasenych projektu"
                seznamPrihlasenychProjektu -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "doruceni seznamu prihlasenych projektu"

                vyhledaniProjektuUI -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "pozadavek na ziskani seznamu projektu podle filteru"
                vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> vyhledaniProjektuUI "doruceni seznamu projeku podle filteru"

                seznamProjektu -> kontrolaFiltru "kontrola filtru"
                kontrolaFiltru -> tvorbaDotazu "pozadavek na ziskani seznamu projektu dle filteru"
                tvorbaDotazu -> seznamProjektu "doruceni seznamu projektu dle filteru"


                // detail projektu
                // UI -> server
                detailProjektuUI -> editaceProjektu "pozadavek na ziskani informaci detailu projektu"
                editaceProjektu -> tvorbaDotazu "pozadavek na ziskani informaci detailu projektu"
                tvorbaDotazu -> editaceProjektu "doruceni informaci detailu projektu"
                // server -> UI
                editaceProjektu -> detailProjektuUI "doruceni informaci detailu projektu"

                // uprava projektu
                detailProjektuUI -> editaceProjektu "pridani, nebo odstraneni souboru"
                editaceProjektu -> kontrolaSouboru "kontrola souboru"
                kontrolaSouboru -> tvorbaDotazu "pridani, nebo odstraneni souboru projektu"
                kontrolaSouboru -> managerNotifikaci "notifikace problemu, nebo uspechu editace projektu"

                // notifikace
                managerNotifikaci -> systemNotificationsUI "zobraz notifikaci"
                kontrolaFiltru -> managerNotifikaci "notifikace problemu"
                kontrolaPodminekProPrihlaseniDoProjektu -> managerNotifikaci "notifikace problemu"
                kontrolaSouboru -> managerNotifikaci "notifikace chyby pri kontrole souboru"

                // prihlaseni se do projektu
                // UI -> server
                detailProjektuUI -> managerProjektu "prihlaseni studenta do projektu"
                managerProjektu -> kontrolaPodminekProPrihlaseniDoProjektu "kontrola podminek"
                kontrolaPodminekProPrihlaseniDoProjektu -> tvorbaDotazu "pridani studenta do projektu"
                kontrolaPodminekProPrihlaseniDoProjektu -> managerNotifikaci "notifikace uspechu, ci neuspechu"
                
                formularProVytvoreniNovehoProjektu -> managerProjektu "vytvoreni noveho projektu"
                managerProjektu -> kontrolaVytvoreniNovehoProjektu "kontrola vytvoreni noveho projektu"
                kontrolaVytvoreniNovehoProjektu -> tvorbaDotazu "vytvoreni noveho projektu"
                kontrolaVytvoreniNovehoProjektu -> managerNotifikaci "notifikace uspechu, ci neuspechu"

            }     
        }
        
        // TODO: remove?
        // managmentProjektu -> komunikace "Inicializuje chatovací místnost pro nový projekt"
        // managmentProjektu -> databazeProjektu "Ukládá a načítá data projektu"
        // komunikace -> kontrola "Kontroluje správnost zpráv v chatu"
        // tvorbaDotazu -> kontrola "Kontroluje správnost sql dotazu"
        // kontrolaZprav -> kontrola "Kontroluje správnost zpráv v chatu"
    
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
