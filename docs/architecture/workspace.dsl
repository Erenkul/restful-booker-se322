workspace {

    model {
        user = person "User" "A guest or administrator interacting with the Restful Booker System."

        restfulBooker = softwareSystem "Restful Booker System" "Allows users to book rooms, view existing bookings, and authenticate." {
            loadBalancer = container "Load Balancer" "Routes traffic to active API instances." "Nginx / AWS ALB"
            
            activeAPI = container "Active API Instance" "Processes bookings and serves API requests." "Node.js / Express" {
                router = component "API Router" "Routes HTTP requests to appropriate handlers." "Express Router"
                validationLayer = component "Input Validation Layer" "Validates and sanitizes incoming request payloads." "validate.js / helper" "Security - Tactic #2"
                bookingHandler = component "Booking Handler" "Executes booking business logic." "Javascript Controller"
                authHandler = component "Auth Handler" "Authenticates users and generates tokens." "Javascript Controller"
                modelController = component "Model Controller" "Manages booking data models and calls DB Driver." "Javascript Controller"
                dbDriver = component "DB Driver" "Reads and writes data via LokiJS library." "LokiJS Driver"
            }
            
            standbyAPI = container "Warm Standby API Instance" "Warm redundant spare instance ready to take over in case of active API failure." "Node.js / Express" "Availability - Tactic #1"
            
            primaryDB = container "Primary Database" "Stores booking details and auth tokens." "LokiJS"
            replicaDB = container "Replica Database" "Maintains a copy of primary database data." "LokiJS" "Performance & Redundancy - Tactic #3"
        }

        # Relationships (Level 1 & 2)
        user -> loadBalancer "Sends API requests to" "HTTPS"
        loadBalancer -> activeAPI "Routes traffic to" "HTTP"
        loadBalancer -> standbyAPI "Fails over to (in case of failure)" "HTTP"
        
        activeAPI -> primaryDB "Reads from and writes to" "LokiJS API"
        standbyAPI -> primaryDB "Reads from and writes to (on failover)" "LokiJS API"
        primaryDB -> replicaDB "Replicates data to" "Replication Sync"

        # Component Relationships (Level 3)
        loadBalancer -> router "Forwards requests to" "HTTP"
        router -> validationLayer "Passes request payload to" "In-process call"
        validationLayer -> bookingHandler "Passes validated request to" "In-process call"
        validationLayer -> authHandler "Passes validated credentials to" "In-process call"
        
        bookingHandler -> modelController "Invokes data operations" "In-process call"
        authHandler -> modelController "Saves/reads token data" "In-process call"
        modelController -> dbDriver "Queries/updates database" "LokiJS API"
        dbDriver -> primaryDB "Persists data to" "File I/O"
    }

    views {
        systemContext restfulBooker "SystemContext" "Level 1: System Context Diagram" {
            include *
            autoLayout
        }

        container restfulBooker "Containers" "Level 2: Container Diagram" {
            include *
            autoLayout
        }

        component activeAPI "Components" "Level 3: Component Diagram" {
            include *
            autoLayout
        }

        styles {
            element "Element" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape Person
                background #08427b
            }
            element "Availability - Tactic #1" {
                background #d35400
            }
            element "Security - Tactic #2" {
                background #27ae60
            }
            element "Performance & Redundancy - Tactic #3" {
                background #8e44ad
            }
        }
    }

}
