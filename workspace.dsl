workspace "NSWI130" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        
        student = person "Student"
        ucitel = person "Teacher"
        pro = softwareSystem "Projekty" {
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
                        MPstHTML = component "Management projektu pro studenty HTML" "Funkcionalita pro managaovani projektu studenty ve webovem prohlizeci" "HTML+JavaScript" "Web Front-End"
                        MPteachHTML = component "Management projektu pro ucitele HTML" "Funkcionalita pro managaovani projektu uciteli ve webovem prohlizeci" "HTML+JavaScript" "Web Front-End"
  
                        group "Zobrazení stránky projektu pro učitele" {
                            formularProVytvoreniNovehoProjektu = component "Zobrazení formuláře pro založení projektu"
                            seznamVytvorenychProjektu = component "Zobrazení seznamu vytvorenych projektu"
                        }
                        group "Zobrazení stránky projektu pro studenta" {
                            seznamPrihlasenychProjektu = component "Zobrazení seznamu přihlášených projektů"
                            seznamProjektuDoKterychSeMuzePrihlasit = component "Zobrazeni seznamu projektu do kterych se muze student prihlasit"
                        }
                        // v deatilu projektu muze ucitel i student upravovat projekt, tedy pridavat a odstranovat soubory
                        detailProjektuUI = component "Zobrazení detailu projektu" "Student se může přihlásit do projektu, nebo ho editovat, učitel může editovat projekt."
                        vyhledaniProjektuUI = component "Vyledani projektu podle podminek"
                        systemNotificationsUI = component "Zobrazení systémových notifikací"

                        systemNotificationsUI -> MPstHTML "Zobrazuje notifikace o potvrzení přihlášení do projektu, nebo změny souboru"
                        systemNotificationsUI -> MPteachHTML "Zobrazuje notifikace o potvrzení vytvoření projektu"

                    
                        MPteachHTML -> detailProjektuUI "obsahuje"
                        MPteachHTML -> formularProVytvoreniNovehoProjektu  "obsahuje"
                        MPteachHTML -> seznamVytvorenychProjektu  "obsahuje"
                        MPteachHTML -> vyhledaniProjektuUI  "obsahuje"

                        MPstHTML -> detailProjektuUI "obsahuje"
                        MPstHTML -> seznamPrihlasenychProjektu  "obsahuje"
                        MPstHTML -> seznamProjektuDoKterychSeMuzePrihlasit  "obsahuje"
                        MPstHTML -> vyhledaniProjektuUI  "obsahuje"


                        ucitel -> MPteachHTML "Managuje projekty"
                        student -> MPstHTML "Přihlašuje se a pracuje na projektu"
                    }
                    group "Business Layer"  {
                        vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru = component "Vytvoreni dotazu na server pro ziskani seznamu projektu podle zadaneho filteru"
                        
                        seznamVytvorenychProjektu -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "ziskani seznamu vytvorenych projektu"
                        vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamProjektuDoKterychSeMuzePrihlasit "ziskani seznamu projektu do kterych se uze student prihlasit"
                        vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamPrihlasenychProjektu "ziskani seznamu prihlasenych projektu"
                        vyhledaniProjektuUI -> vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru "ziskani seznamu projektu podle filteru"
                        
                    }

                    group "Persistence Layer"  {
                    }
                }

                managmentProjektuServer = container "Server Správy projektů" "" "" {
            
                    group "Business Layer"  {
                        managerNotifikaciManagmentProjektu = component "Manager notifikaci"
                        group "Manager projektů" {
                            managerProjektu = component "Manager projektů"
                            kontrolaPodminekProPrihlaseniDoProjektu = component "Kontrola podmínek pro prihlaseni do projektu" "Kontrola splnění podmínek pro přihlášení do projektu"
                            kontrolaVytvoreniNovehoProjektu = component "Kontrola vytvoření nového projektu" "Kontrola jedinečnosti názvu projektu"
                        }
                        group "Vyhledávání projektů" {
                            seznamProjektu = component "Seznam projektu"
                            kontrolaFiltru = component "Kontrola Filtru" "Kontrola chyb ve vyplněných filtrech"
                        }
                        vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru -> seznamProjektu "ziskani seznamu prihlasenych projektu podle filteru"

                    }
                    group "Persistence Layer"  {
                        tvorbaDotazuSpravaProjektu = component "Komunikace s databází"
                        
                        // seznam projektu
                        seznamProjektu -> kontrolaFiltru "kontrola filtru"
                        kontrolaFiltru -> tvorbaDotazuSpravaProjektu "pozadavek na ziskani seznamu projektu dle filteru"
                        tvorbaDotazuSpravaProjektu -> seznamProjektu "doruceni seznamu projektu dle filteru"

                        // prihlaseni se do projektu
                        detailProjektuUI -> managerProjektu "prihlaseni studenta do projektu"
                        managerProjektu -> kontrolaPodminekProPrihlaseniDoProjektu "kontrola podminek"
                        kontrolaPodminekProPrihlaseniDoProjektu -> tvorbaDotazuSpravaProjektu "pridani studenta do projektu"

                        // vytvoreni noveho projektu
                        formularProVytvoreniNovehoProjektu -> managerProjektu "vytvoreni noveho projektu"
                        managerProjektu -> kontrolaVytvoreniNovehoProjektu "kontrola vytvoreni noveho projektu"
                        kontrolaVytvoreniNovehoProjektu -> tvorbaDotazuSpravaProjektu "vytvoreni noveho projektu"
                    }
                    
                    // notifikace
                    managerNotifikaciManagmentProjektu -> systemNotificationsUI "zobraz notifikaci"
                    kontrolaFiltru -> managerNotifikaciManagmentProjektu "notifikace problemu"
                    kontrolaPodminekProPrihlaseniDoProjektu -> managerNotifikaciManagmentProjektu "notifikace problemu"
                    kontrolaPodminekProPrihlaseniDoProjektu -> managerNotifikaciManagmentProjektu "notifikace uspechu, ci neuspechu"
                    kontrolaVytvoreniNovehoProjektu -> managerNotifikaciManagmentProjektu "notifikace uspechu, ci neuspechu"
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

                        // detail projektu
                        detailProjektuUI -> editaceProjektu "pozadavek na ziskani informaci detailu projektu"
                        editaceProjektu -> tvorbaDotazuEditaceProjektu "pozadavek na ziskani informaci detailu projektu"
                        tvorbaDotazuEditaceProjektu -> editaceProjektu "doruceni informaci detailu projektu"
                    
                        // uprava projektu
                        detailProjektuUI -> editaceProjektu "pridani, nebo odstraneni souboru"
                        editaceProjektu -> kontrolaSouboru "kontrola souboru"
                        kontrolaSouboru -> tvorbaDotazuEditaceProjektu "pridani, nebo odstraneni souboru projektu"
                    }
                    
                    managerNotifikaciEditaceProjektu -> systemNotificationsUI "zobraz notifikaci"
                    kontrolaSouboru -> managerNotifikaciEditaceProjektu "notifikace problemu, nebo uspechu editace projektu"
                }



                databazeProjektu = container "Databáze" "Ukládá data" "" "Database"
                
                tvorbaDotazuSpravaProjektu -> databazeProjektu "proved dotaz"
                tvorbaDotazuEditaceProjektu -> databazeProjektu "proved dotaz"
                 
            }               
        }
    

    
    # Deployment
            deploymentEnvironment "Live"    {
                # HTML
                deploymentNode "Studentuv webovy prohlizec" "" ""    {
                   MPstHTMLInstance = containerInstance managmentProjektuWebApp
                }
                deploymentNode "Webovy prohlizec Ucitele" "" ""    {
                   MPteachHTMLInstance = containerInstance managmentProjektuWebApp
                }
                 
                
                
                # Aplikace
                deploymentNode "Projects Management Aplikacni Server" "" "Ubuntu 22.04" {
                  managmentProjektuServerInstance = containerInstance managmentProjektuServer
                }
                
               deploymentNode "Projects Editace Server" "" "Ubuntu 22.04" {
                  editaceProjektuServerInstance = containerInstance editaceProjektuServer
                }

                
                # Databases
                # Pripadne databaze mohou bezet i na stejenem sereveru co aplikace
                deploymentNode "Database Server pro Projekty" "" "Ubuntu 22.04 LTS"   {
                   deploymentNode "Relational DB server" "" "Oracle 23.2.0" {
                       applicationsDatabaseInstance = containerInstance databazeProjektu
                   }
                }
                
                #Komunikace Deployment
                
                #Aplikace
                
                deploymentNode "Project Komunikacni server" "" "Ubuntu 22.04 LTS" {
                    deploymentNode "Web Server" "" "Apache Tomcat 10.1.15" {
                        komunikaceWebAppInstance = containerInstance komunikaceWebApp
                    }
                    komunikaceServerInstance = containerInstance komunikaceServer
                }
                

                deploymentNode "Database Server pro Komunikaci" "" "Ubuntu 22.04 LTS"   {
                   deploymentNode "Relational DB server" "" "Oracle 23.2.0" {
                       komunikaceDatabaseInstance = containerInstance chatLogDatabaze
                   }
                }
            }
    }
    
    views {
        theme default
    }

}