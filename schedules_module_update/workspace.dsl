workspace {

    model {
        user = person "User" "A user of schedules module"
        client = softwareSystem "Browser" "The browser where user interacts with the Schedules Module" "Web Browser"
        schedulesModule = softwareSystem "Schedules Module" "The module for interactions with schedules module" {
            staticFileServerContainer = container "Static file server" "Sends source code for client" {
                staticFileServer = component "Static file server" "Send source code for client"
            }
            frontendContainer = container "Frontend" "" "" "Web Browser" {
            }
            collisionController = container "Collision Controller" "In charge of ticket scheduling collisions" {
                collisionChecker = component "Collision Checker" "Checks for collisions of one course ticket"
                automaticScheduler = component "Automatic Scheduler" "Asynchronously schedules all unscheduled course tickets based on teacher preferences"
            }
            businessProcessor = container "Business Processor" "Processes requests on business principles" {
                dispatcher = component "Dispatcher" "Chooses next action based on request type"
                scheduleViewer = component "Schedule Viewer" "Send data for viewing a schedule based on request parameters"
                exporter = component "Exporter" "Process and transform data to requested format"
                ticketEditor = component "Ticket Editor" "Update ticket data in database when editing schedule"
                preferenceEditor = component "Preference Editor" "Update teaching time preference data"
                automaticSchedulerCaller = component "Automatic Scheduler Caller" "Requests to automatically schedule all remaining course tickets"
                cache = component "Cache" "Caches tickets data"
                RWManager = component "Read/Write manager" "Reads and writes to the database"
            }
            audit = container "Audit" "Logs modifications and requests about ticket schedules" {
                logger = component "Logger" "Save and read logs"
            }
            schdedulesDatabaseContainer = container "Database" "Database for Schedules data" "" "Database" {
                schedulesDatabase = component "Schedules Database" "Stores data related to Schedules module" "" "Database"
            }
            auditDatabaseContainer = container "Audit Database" "Database for audit logs" "" "Database" {
                auditDatabase = component "Audit Database" "Store logs" "" "Database"
            }

            externalDataProvider = container "External Data Provider" "Makes API calls and provides API for external systems" "" "" {
                externalDataProviderEntry = component "External Data Provider Entry" "Makes API calls to external systems to get other data" "" ""
            }

            APIProvider = container "API Provider" "Provides API for external systems to access data" "" "" {
                APIProviderEntry = component "API Provider Entry" "Provides API for external systems to access data" "" ""
            }
        }

        SIS = softwareSystem "Student Information System" "Stores user login data and manages their respective roles" "Existing System"

        user -> schedulesModule "Uses"
        client -> businessProcessor "Sends request"
        businessProcessor -> client "Sends response"

        # Relationships of Dashboard components
        client -> staticFileServer "Sends request for client source code"
        staticFileServer -> client "Sends client source code"

        # Relationships of Collision Controller components
        automaticScheduler -> RWManager "Reads from/Writes to"
        collisionChecker -> RWManager "Reads from"
        automaticScheduler -> collisionChecker "Checks collisions"

        # Relationships of Business Processor components
        preferenceEditor -> RWManager "Writes to"
        exporter -> RWManager "Reads from"
        scheduleViewer -> RWManager "Reads from"
        ticketEditor -> RWManager "Writes to"
        ticketEditor -> collisionChecker "Checks for collisions"

        dispatcher -> externalDataProviderEntry "Requests call to authorize user access"
        externalDataProviderEntry -> SIS "Make API call to get data from external system"
        APIProviderEntry -> Dispatcher "Requests data and authorization"
        automaticScheduler -> externalDataProviderEntry "Requests data about schoolrooms and buildings to recognize mutual distances"

        dispatcher -> logger "Logs requests"
        automaticSchedulerCaller -> automaticScheduler "Calls automatic scheduling"


        dispatcher -> preferenceEditor "Dispatches to Preference Editor"
        dispatcher -> exporter "Dispatches to Exporter"
        dispatcher -> scheduleViewer "Dispatches to Schedule Viewer"
        dispatcher -> ticketEditor "Dispatches to Ticket Editor"
        dispatcher -> automaticSchedulerCaller "Dispatches to Automatic Scheduler Caller"

        client -> dispatcher "Sends requests to our application"
        dispatcher -> client "Sends response to client"

        # Relationships of Model components
        cache -> schedulesDatabase "Reads from"
        RWManager -> schedulesDatabase "Writes to"
        RWManager -> cache "Invalidates"
        RWManager -> cache "Reads from"

        RWManager -> logger "Logs modification"

        # Relationships of Audit components
        logger -> auditDatabase "Writes to and reads from"

        frontendContainer -> staticFileServerContainer "Requests frontend code"
        staticFileServerContainer -> frontendContainer "Sends client source code"


        deploymentEnvironment "Deployment" {
            deploymentNode "Users's computer" "" "Any operating system" {
                deploymentNode "Web Browser" "" "Any browser with standard HTML5 and ES2015 support" {
                    frontendInstance = containerInstance frontendContainer
                }
            }
            deploymentNode "SIS server cluster" "" "" {
                deploymentNode "Static asset server" {
                    staticFileServerInstance = containerInstance staticFileServerContainer
                }
                deploymentNode "Schedules module main node"  {
                    businessProcessorInstance = containerInstance businessProcessor
                    auditInstance = containerInstance audit
                }
                deploymentNode "Collision controller node" {
                    collisionControllerInstance = containerInstance collisionController
                    description "This node is only enabled during the start of the year, when collission control is needed"
                }

                deploymentNode "Database node" {
                    databaseInstance = containerInstance schdedulesDatabaseContainer
                }

                deploymentNode "Audit database node" {
                    auditDatabaseInstance = containerInstance auditDatabaseContainer
                }

                deploymentNode "External data provider node" {
                    externalDataProviderInstance = containerInstance externalDataProvider
                }

                deploymentNode "API provider node" {
                    APIProviderInstance = containerInstance APIProvider
                }
            }
        }
    }

    views {
        systemLandscape "SystemContext" {
            include *
            exclude client
            autoLayout lr
        }
        container schedulesModule {
            include *
            exclude frontendContainer
            autoLayout
        }

        component externalDataProvider {
            include *
            autoLayout
        }

        component APIProvider {
            include *
            autoLayout
        }


        component staticFileServerContainer {
            include *
            autoLayout
        }
        component collisionController {
            include *
        }
        component businessProcessor {
            include *
            autoLayout
        }
        component audit {
            include *
            autoLayout
        }

        deployment schedulesModule "Deployment" {
            include *
            autoLayout
        }

        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #00aa00
                color #ffffff
            }
            element "Component" {
                background #ff7700
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
                background #aaaaaa
            }
            element "Database" {
                shape Cylinder
                background #ee00ee
            }
            element "Existing System" {
                background #999999
                color #ffffff
            }
        }
    }
}
