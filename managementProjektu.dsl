workspace "NSWI130" {

    model {
    
        properties {
            "structurizr.groupSeparator" "/"
        }
        
        student = person "Student"
        ucitel = person "Teacher"
        
        pro = softwareSystem "Projekty" {

            group "Komunikace" {
                komunikaceUI = container "UI Komunikace" "" "" {
                    group "Presentation Layer"  {
                        chatUI = component "Chat User Interface" "Zobrazení okénka chatu"
                        notifikaceUI = component "Chat Notifications User Interface" "Zobrazení notifikací"
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
                            formularProVytvoreniNovehoProjektu = component "Zobrazení formuláře pro založení projektu"
                            seznamVytvorenychProjektu = component "Zobrazení seznamu vytvorenych projektu"
                        }
                        group "Zobrazení stránky projektu pro studenta" {
                            seznamPrihlasenychProjektu = component "Zobrazení seznamu přihlášených projektů"
                            seznamProjektuDoKterychSeMuzePrihlasit = component "Zobrazeni seznamu projektu do kterych se muze student prihlasit"
                        }
                        // v deatilu projektu muze ucitel i student upravovat projekt, tedy pridavat a odstranovat soubory
                        detailProjektuUI = component "Zobrazení detailu projektu"
                        vyhledaniProjektuUI = component "Vyledani projektu podle podminek"
                        systemNotificationsUI = component "Zobrazení systémových notifikací"
                    }
                    group "Business Layer"  {
                        vytvoreniDotazuNaZiskaniSeznamuProjektuPodleFiltru = component "Vytvoreni dotazu na server pro ziskani seznamu projektu podle zadaneho filteru"
                    }
                    group "Persistence Layer"  {
                    }
                }

                managmentProjektuServer = container "Server Správy projektů" "" "" {
                    group "Presentation Layer" {
                        UIDeliver = component "Správa projektů Server User Interface" ""
                    }
                    group "Business Layer"  {
                        
                        managerNotifikaci = component "Manager notifikaci"
                        seznamProjektu = component "Seznam projektu"
                        editaceProjektu = component "Editace projektu"
                        managerProjektu = component "Manager projektů"
                        tvorbaDotazu = component "Tvorba dotazů na databázi"
                        group "Kontroly" {
                            kontrolaSouboru = component "Kontrola souborů" "Kontrola formátu a správnosti vkládaných souborů"
                            kontrolaFiltru = component "Kontrola Filtru" "Kontrola chyb ve vyplněných filtrech"
                            kontrolaPodminekProPrihlaseniDoProjektu = component "Kontrola podmínek pro prihlaseni do projektu" "Kontrola splnění podmínek pro přihlášení do projektu"
                            kontrolaVytvoreniNovehoProjektu = component "Kontrola vytvoření nového projektu" "Kontrola jedinečnosti názvu projektu"
                        }
                    }
                    group "Persistence Layer"  {
                    }
                }

                databazeProjektu = container "Databáze" "Ukládá data" "" "Database"
                
                // nacteni stranek
                ucitel -> UIDeliver "pozadeavek ziskani html stranky projektu"
                student -> UIDeliver "pozadavek ziskani html stranky projektu"
                UIDeliver -> ucitel "doruceni html stranky pro ucitele"
                UIDeliver -> student "doruceni html stranky pro studenta"

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



                // databaze
                tvorbaDotazu -> databazeProjektu "proved dotaz"

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
        
        
    }
    
    views {
        theme default
    }

}
