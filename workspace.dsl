workspace "NSWI130" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        # External
        studentInfoSystem = softwareSystem "Studijni Informacni System" {
            tags "External" 
        }

        # Aktéři
        student = person "Student" "Studuje na univerzitě"
        ucitel = person "Učitel" "Přednáší na univerzitě"

        projekty = softwareSystem "Modul Projekty" "Modul Projekty pro Studenty a učitele" {
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
                student -> chatUI  "píše zprávy" "" "internal"
                ucitel -> chatUI  "píše zprávy" "" "internal"
                chatUI -> student  "zobrazuje zprávy" "" "internal"
                chatUI -> ucitel  "zobrazuje zprávy" "" "internal"
                notifikaceUI -> student  "zobrazuje notifikace" "" "internal"
                notifikaceUI -> ucitel  "zobrazuje notifikace" "" "internal"
            }

            group "Management Projektu" {
                # HTML 
                # Containery běží na straně uživatele a posílají api calls na controllery
                MPstHTML = container "Management projektu pro studenty HTML" "Funkcionalita pro správu projektů studenty ve webovém prohlížeči" "HTML+JavaScript" "Web Front-End"
                MPteachHTML = container "Management projektu pro ucitele HTML" "Funkcionalita pro správu projektů učitely ve webovém prohlížeči" "HTML+JavaScript" "Web Front-End"

                # Web Apps
                managementProjektustudentApp = container "Webová aplikace Management Projektu pro studenta Front end" "Doručuje HTML data, aby si student zobrazil info o projektech" {
                    managementProjektControllerSt = component "Project Controller pro studenta" "Definuje rozhraní pro čtení/přihlášení do projektu a poskytuje tohle rozhraní."
                    managementProjektUISt = component "Uživatelské Rozhraní pro modul Projekty pro studenta (Viewer)" "Poskytuje HTML rozhraní"
                }
                managementProjektuteacherApp = container "Webová aplikace Management Projektu pro učitele Front end" "Doručuje HTML data, aby si učitel zobrazil info o projektech" {
                    managementProjektControllerT = component "Project Controller pro učitele" "Definuje rozhraní pro čtení/vytváření/editaci projektu a poskytuje tohle rozhraní."
                    managementProjektUIT = component "Uzivatelske Rozhrani pro modul Projekty pro ucitele (Viewer)" "Poskytuje HTML rozhraní"
                }

                # Manager
                managementProjektuManager = container "Správa projektu" "Správa (vytváření, editace, přihlášení do) projektu" {
                    group "Persistent Layer" {
                        projectsRepository = component "Repository projektu" "Persists projekty v repositorii. Definuje rozhraní pro čtení a vytváření projektu a poskytuje implementaci rozhraní."
                    }
                    group "Business Layer" {
                        managerNotifikaci = component "Manager notifikací" "Posílá notifikace"  
                        // Kontroly
                        kontrolniUnit = component "Kontrola a Validace" "Provedení kontroly a validace dat"
                        // Hlavni business logika pro vytvareni, editaci, prihlaseni do projektu 
                        projectBusiness = component "Projekt" "Business logika pro projekt"
                        gateway = component "Gateway" "Zajišťuje komunikaci s informačním systémem"
                        
                    }
                }
                databazeProjektu = container "Databáze projektu" "Ukládá a načítá data projektů" {
                    tags "Database"
                }
            }

            # Vztahy 
            ## Aktéři
            student -> MPstHTML "Prohlíží a přihlásí se do projektů" "" "internal"
            ucitel -> MPteachHTML "Prohlíží, managuje a vytváří projekty" "" "internal"

            ## z WebApp do prohlížeče
            MPstHTML -> managementProjektControllerSt "Posílá požadavky na data"
            managementProjektControllerSt -> MPstHTML "Doručuje data"

            MPteachHTML -> managementProjektControllerT "Posílá požadavky na data"
            managementProjektControllerT -> MPteachHTML "Doručuje data"

            ## Uvnitř WebApp front-end
            managementProjektControllerSt -> managementProjektUISt "Používá pro renderovani dat pro management projektů"
            managementProjektControllerT -> managementProjektUIT "Používá pro renderovani dat pro management projektů"

            ## Z webApp front-end do Business Sprava Projektu
            managementProjektControllerSt -> projectBusiness "Získává a mění data projektu"
            managementProjektControllerT -> projectBusiness  "Získává a mění data projektu"
            managerNotifikaci -> managementProjektControllerSt "Posílá notifikace o úspěchu či neúspěchu akcí"
            managerNotifikaci -> managementProjektControllerT "Posílá notifikace o úspěchu či neúspěchu akcí"

            ## Kontroly
            kontrolniUnit -> projectBusiness "Posílá validní data"
            projectBusiness -> kontrolniUnit "Posílá data pro validaci"
            kontrolniUnit -> managerNotifikaci "Posílá informace o výsledku kontroly"

            ## Gateway vztahy na úrovni business logiky
            projectBusiness -> gateway  "Posílá požadavek na změnu dat"

            gateway -> studentInfoSystem "Udělá API call pro zapsání změn"

            ## Z Business do Persistent
            projectBusiness -> projectsRepository "Čte/píše data přes rozhraní"

            ## Z Pesristent do DB
            projectsRepository -> databazeProjektu "Čte z/zapisuje do"
        }
        MPstHTML -> komunikaceWebApp "přesměrování na daný chat"
        MPteachHTML -> komunikaceWebApp "přesměrování na daný chat"

        ucitel -> projekty "Spravuje studentské projekty a komunikuje se studenty" 
        student -> projekty "Přihlašuje se do projektů, pracuje na nich a komunikuje se svým učitelem a spolužáky"

        # Deployment
        deploymentEnvironment "Live" {
            # Management Projektu
            ## HTML
            deploymentNode "Studentův webový prohlížeč" "" "" {
                MPstHTMLInstance = containerInstance MPstHTML
            }
            deploymentNode "Webový prohlížeč Učitele" "" "" {
                MPteachHTMLInstance = containerInstance MPteachHTML
            }

            ## Aplikace
            deploymentNode "Project Management Aplikační Server" "" "Ubuntu 22.04 LTS" {
                deploymentNode "Web server" "" "Apache Tomcat 10.1.15" {
                    studentProjectManagerAppInstance = containerInstance managementProjektustudentApp
                    teacherProjectManagerAppInstance = containerInstance managementProjektuteacherApp
                }
                ProjectManagementManagerInstance = containerInstance managementProjektuManager
            }

            ## Databáze
            // Databáze mohou bězet i na stejénem serveru jako aplikace
            deploymentNode "Database Server pro Projekty" "" "Ubuntu 22.04 LTS" {
                deploymentNode "Relational DB server" "" "Oracle 23.2.0" {
                    applicationsDatabaseInstance = containerInstance databazeProjektu
                }
            }

            # Komunikace
            ## Aplikace
            deploymentNode "Komunikace Aplikační server" "" "Ubuntu 22.04 LTS" {
                ## Web App
                deploymentNode "Webová aplikace pro Komunikaci" "" "" {
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
            
            filtered "projektySystemContext" exclude "internal"
            
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
