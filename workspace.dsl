workspace "NSWI130" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        # External
        // TODO: rozhodnout se, zda je potřeba mít propojení se SISem
        studentInfoSystem = softwareSystem "Studijni Informacni System" {
            tags "External" 
        }

        # Aktéři
        student = person "Student" "Studuje na univerzitě"
        ucitel = person "Učitel" "Přednáší na univerzitě"

        projekty = softwareSystem "Modul Projekty" "Modul Projekty pro Studenty a učitele" {
            // TODO: přidat do managementPrujektuServer něco, co si bude pamatovat id chatů, které pak zahrne v přesměrování
            // TODO: přidat managementProjektuWebApp -> komunikaceWebApp: "přesměrovává na daný chat"

            group "Komunikace" {
                komunikaceWebApp = container "Webová Aplikace Komunikace" "" "" "Web Front-End" {
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
                    tags "Database"
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
                # HTML 
                # Ty containery běží na straně uživatele a posílají api calls na controllery
                // A jsou víc potřebné pro deployment. Podobný container bych vytvořila i v Komunikaci, aby to mohlo reprezentovat Uživatelský
                // webový prohlížeč
                MPstHTML = container "Management projektu pro studenty HTML" "Funkcionalita pro managaovani projektu studenty ve webovem prohlizeci" "HTML+JavaScript" "Web Front-End"
                MPteachHTML = container "Management projektu pro ucitele HTML" "Funkcionalita pro managaovani projektu uciteli ve webovem prohlizeci" "HTML+JavaScript" "Web Front-End"

                # Web Apps
                managementProjektustudentApp = container "Webova aplikace Management Projektu pro studenta Front end" "Dorucuje HTML data aby student zobrazil info o projektech" {
                    managementProjektControllerSt = component "Project Controller pro studenta" "Definuje rozhrani pro cteni/prihlaseni do projektu a poskytuje tohle rozhrani."
                    managementProjektUISt = component "Uzivatelske Rozhrani pro modul Projekty pro studenta (Viewer)" "Poskytuje HTML rozhrani"
                }
                managementProjektuteacherApp = container "Webova aplikace Management Projektu pro ucitele Front end" "Dorucuje HTML data aby student zobrazil info o projektech" {
                    managementProjektControllerT = component "Project Controller pro ucitele" "Definuje rozhrani pro cteni/vytvareni/editaci projektu a poskytuje tohle rozhrani."
                    managementProjektUIT = component "Uzivatelske Rozhrani pro modul Projekty pro ucitele (Viewer)" "Poskytuje HTML rozhrani"
                }

                # Manager
                // To si predstavuju jako server na kterem ja zarizena Business a Persistent logika. Tu Presentation ma na starosti WebApp frontend 
                // V predchozi verzi jsme meli containery editace projektu a Notifikace  (ti notifikaci vubec nechapu co a pro co je),
                // takse container notifikace jsem smazala, ale je tu mala komponenta managerNotifikaci, jenom musime rozhodnout, kam s ni dal
                // Do mailu? do weboveho rozhrani? nebo di SISu, kde pak se tam o to postara
                //
                // Ohledne toho, ze jsme dopodrobna meli rozepsany Editace Projektu s predpokladem, ze by pro to byl jeste 
                // zvlastni serever si myslim je zbytecne. Myslim si, ze to vsechno jde zahrnout v Business logice, vzdyt to poznamenava 
                // zmeny (bud to je prihlaseni studenta, nebo vypsani noveho projektu), prevadi ty zmeny do podoby, ve ktere je sezere Persistent
                // a pak ulozi do DB
                managementProjektuManager = container "Sprava projektu" "Managovani (vytvareni, editace, prihlaseni do) prjektu" {
                    group "Persistent Layer" {
                        projectsRepository = component "Repository projektu" "Persists projekty v repositorii. Definuje rozhrani pro cteni a vytvareni projektu a poskytuje implmentaci rozhrani."
                    }
                    group "Business Layer" {
                        managerNotifikaci = component "Manager notifikaci" "Posila notifikace"  
                        // Kontroly
                        kontrolniUnit = component "Kontrola a Validace" "Provedeni kontroly a validace dat"
                        // Hlavni business logika pro vytvareni, editaci, prihlaseni do projektu (Na tehle urovni rozdeleni do mensich casti nas jenonm zmatne, ne?)
                        projectBusiness = component "Projekt" "Business logika pro projekt"
                        // Gateway aby zmeny byly poznamenany v SISu u stufdenta a ucitele
                        // Ohledne tech Gateways si nejsem uplne jista.
                        // Jestli mame situaci, kdyz chceme, aby se zmeny provedene v modulu projekty byly videt zvenku. Jako treba kdyz vsichni
                        // postupujeme do dalsiho rocniku, potom to, ze jsme ve 3. rocniku najdeme nejen v modulu "Vysledky Zkousek" ale i na hlavni strance SISu v pravem hornim rohu
                        // Takze pokud podobne zmeny chceme poznamenavat do jinych modulu, odkazem GateWayem na SIS
                        gateway = component "Gateway" "Zajišťuje komunikaci s informačním systémem"
                        
                    }
                }
                databazeProjektu = container "Databáze projektu" "Ukládá a načítá data projektů" {
                    tags "Database"
                }
            }

            # Vztahy 
            ## Aktéři
            student -> MPstHTML "Prohlizi a prihlasi se do projektu"
            ucitel -> MPteachHTML "Prohlizi, managuje a vytvoruje projekty"

            ## z web App do prohlizece
            MPstHTML -> managementProjektControllerSt "Posila pozadavky na data"
            managementProjektControllerSt -> MPstHTML "Dorucuje data"

            MPteachHTML -> managementProjektControllerT "Posila pozadavky na data"
            managementProjektControllerT -> MPteachHTML "Dorucuje data"

            ## Uvnitr WebApp frontEnd
            managementProjektControllerSt -> managementProjektUISt "Pouziva pro renderovani dat pro management projektu"
            managementProjektControllerT -> managementProjektUIT "Pouziva pro renderovani dat pro management projektu"

            ## Z webApp front end do Business Sprava Projektu
            managementProjektControllerSt -> projectBusiness "Ziskava a meni data projektu"
            managementProjektControllerT -> projectBusiness  "Ziskava a meni data projektu"
            managerNotifikaci -> managementProjektControllerSt "Posílá notifikace o úspěchu či neúspěchu akcí"
            managerNotifikaci -> managementProjektControllerT "Posílá notifikace o úspěchu či neúspěchu akcí"

            ## Kontroly
            kontrolniUnit -> projectBusiness "Posila validni data"
            projectBusiness -> kontrolniUnit "Posila data pro validaci"
            kontrolniUnit -> managerNotifikaci "Posílá informace o výsledku kontroly"

            ## Gateway vztahy na urovni business logiky
            projectBusiness -> gateway  "Posila pozadavek na zmenu dat"

            gateway -> studentInfoSystem "Udela API call pro zapsani zmen, takajicich se studenta"

            ## Z Business do Persistent
            projectBusiness -> projectsRepository "Cte/pise data pres rozhrani"

            ## z Pesristent do DB
            projectsRepository -> databazeProjektu "Cte z/zapisuje do DB"
        }

        ucitel -> projekty "Spravuje studentské projekty a komunikuje se studenty"
        student -> projekty "Přihlašuje se do projektů, pracuje na nich a komunikuje se svým učitelem a spolužáky"

        # Deployment
        deploymentEnvironment "Live" {
            # Management Projektu
            ## HTML
            deploymentNode "Studentuv webovy prohlizec" "" "" {
                MPstHTMLInstance = containerInstance MPstHTML
            }
            deploymentNode "Webovy prohlizec Ucitele" "" "" {
                MPteachHTMLInstance = containerInstance MPteachHTML
            }

            ## Aplikace
            deploymentNode "Project Management Aplikacni Server" "" "Ubuntu 22.04 LTS" {
                deploymentNode "Web server" "" "Apache Tomcat 10.1.15" {
                    studentProjectManagerAppInstance = containerInstance managementProjektustudentApp
                    teacherProjectManagerAppInstance = containerInstance managementProjektuteacherApp
                }
                ProjectManagementManagerInstance = containerInstance managementProjektuManager
            }

            ## Databáze
            // Pripadne databaze mohou bezet i na stejenem sereveru co aplikace
            deploymentNode "Database Server pro Projekty" "" "Ubuntu 22.04 LTS" {
                deploymentNode "Relational DB server" "" "Oracle 23.2.0" {
                    applicationsDatabaseInstance = containerInstance databazeProjektu
                }
            }

            # Komunikace
            ## Web App
            // TODO: Web App chatu

            ## Aplikace
            deploymentNode "Project Komunikacni server" "" "Ubuntu 22.04 LTS" {
                deploymentNode "Web Server" "" "Apache Tomcat 10.1.15" {
                    komunikaceWebAppInstance = containerInstance komunikaceWebApp
                }
                komunikaceServerInstance = containerInstance komunikaceServer
            }

            ## Databáze
            deploymentNode "Database Server pro Komunikaci" "" "Ubuntu 22.04 LTS" {
                deploymentNode "Relational DB server" "" "Oracle 23.2.0" {
                    komunikaceDatabaseInstance = containerInstance chatLogDatabaze
                }
            }
        }
    }

    views {
            systemContext projekty "projektySystemContext" "Diagram systému" {
                include *
                //autoLayout lr
            }

            container projekty "projektyContainer" "Diagram kontejnerů" {
                include *
                //autoLayout lr
            }

            component managementProjektustudentApp "ProjectManagementWebAppStudent" {
                include *
                //autoLayout lr
            }

            component managementProjektuteacherApp "ProjectManagementWebAppTeacher" {
                include *
                //autoLayout lr
            }

            component managementProjektuManager "ProjektManagementComponent" {
                include *
                //autolayout lr
            }

            component komunikaceWebApp "komunikaceWebAppComponent" "Diagram komponent" {
                include *
                //autoLayout lr
            }

            component komunikaceServer "komunikaceServerComponent" "Diagram komponent" {
                include *
                //autoLayout lr
            }

            deployment projekty "Live" "StudentSystemDeployment" {
                include *
                //autolayout lr
            }
            theme default

        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }

            element "Web Front-End" {
                shape WebBrowser
            }

            element "Database" {
                shape Cylinder
            }

            element "Software System" {
                background #1168bd
                color #ffffff
            }

            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }

            element "External" {
                background  #636363
            }
        }
    }
}
