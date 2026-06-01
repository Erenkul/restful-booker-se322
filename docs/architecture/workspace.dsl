workspace "Restful Booker" "C4 architecture model for the Restful Booker API" {

    model {

        # ── People ──────────────────────────────────────────────
        client = person "API Client" "A developer or external system consuming the Restful Booker REST API."

        # ── Software System ──────────────────────────────────────
        restfulBooker = softwareSystem "Restful Booker" "A RESTful hotel booking API built with Node.js and Express. Supports creating, reading, updating, and deleting bookings." {

            # ── Containers (Level 2) ─────────────────────────────

            # Tactic: Warm Redundant Spare — standby instance ready to take over on failure
            standbyApp = container "Standby Application" "Warm redundant spare instance of the Node.js application. Monitored by a load balancer and takes over automatically if the primary instance fails." "Node.js / Express" "Standby"

            webApp = container "Node.js Application" "Primary application instance. Handles all incoming HTTP requests, applies input validation, and executes booking business logic." "Node.js / Express" {

                # ── Components (Level 3) ─────────────────────────

                # Tactic: Input Validation — all requests pass through validator before processing
                validator  = component "Validator" "Sanitizes and validates all incoming request payloads before they reach business logic. Rejects malformed or incomplete data." "helpers/validator.js (validate.js)"

                router     = component "Router" "Defines and handles all API endpoints: /ping, /auth, /booking, /booking/search, /booking/:id." "routes/index.js (Express Router)"
                parser     = component "Parser" "Serializes responses into the format requested by the client: JSON, XML, or URL-encoded." "helpers/parser.js"
                bookingCreator = component "Booking Creator" "Generates random booking payloads used to seed the database on startup." "helpers/bookingcreator.js"
                authHandler = component "Auth Handler" "Generates and stores session tokens. Verifies token or Basic Auth header on protected endpoints (PUT, PATCH, DELETE)." "routes/index.js (crypto)"
                bookingModel = component "Booking Model" "Encapsulates all CRUD operations against the in-memory LokiJS database." "models/booking.js"
            }

            # Tactic: Data Replication — replica node ensures data redundancy and read scalability
            primaryDb = container "Primary Database" "Primary in-memory database. Stores all booking records and is the single source of write operations." "LokiJS" "Database"
            replicaDb = container "Replica Database" "Read replica of the primary database. Provides data redundancy and offloads read traffic to improve performance." "LokiJS" "Database"
        }

        # ── Relationships ────────────────────────────────────────

        # Level 1
        client -> restfulBooker "Makes API calls to" "HTTPS / JSON or XML"

        # Level 2
        client      -> webApp     "Sends HTTP requests to" "HTTP / JSON, XML, URL-encoded"
        webApp      -> primaryDb  "Reads from and writes to"
        primaryDb   -> replicaDb  "Replicates data to" "Data Replication"
        webApp      -> standbyApp "Traffic fails over to on primary failure" "Load Balancer"

        # Level 3
        router      -> validator     "Passes incoming payload to" "Input Validation"
        router      -> parser        "Formats response using"
        router      -> authHandler   "Authenticates request via"
        router      -> bookingModel  "Reads / writes booking data via"
        bookingCreator -> bookingModel "Seeds initial bookings through"
        bookingModel -> primaryDb    "Persists data to"
    }

    views {

        systemContext restfulBooker "Level1-SystemContext" {
            include *
            autoLayout
            title "Level 1 – System Context"
            description "Shows the Restful Booker system and its external users."
        }

        container restfulBooker "Level2-Container" {
            include *
            autoLayout
            title "Level 2 – Container"
            description "Shows internal containers. Highlights: Warm Redundant Spare (Standby Application) and Data Replication (Replica Database)."
        }

        component webApp "Level3-Component" {
            include *
            autoLayout
            title "Level 3 – Component"
            description "Shows internal components of the Node.js application. Highlights: Input Validation (Validator component)."
        }

        styles {
            element "Person" {
                shape Person
                background #08427B
                color #ffffff
            }
            element "Software System" {
                background #1168BD
                color #ffffff
            }
            element "Container" {
                background #438DD5
                color #ffffff
            }
            element "Component" {
                background #85BBF0
                color #000000
            }
            element "Database" {
                shape Cylinder
                background #438DD5
                color #ffffff
            }
            element "Standby" {
                background #E07B00
                color #ffffff
            }
        }
    }
}