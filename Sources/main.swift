import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import SwiftKuery
import SwiftKueryPostgreSQL
import KituraRequest

class ChickenTable: Table {
    let tableName = "chickentable"

    let name = Column("name")
    let destiny = Column("destiny")
}

HeliumLogger.use()

// Create a new router
let router = Router()

// Setup DB connections to use correct DB_URL depending on environment the project is run on.
let DBHost: URL
let defaultDBHost = "localhost"

// Check if we are running on Heroku by requesting DB_URL from Herokus environment variables
if let requestedHost = ProcessInfo.processInfo.environment["DATABASE_URL"] {
    // There is an annoying bug in Kitura that requires us to make the postgress address coming from Heroku to have first letter as uppercase
    var urlComp = URLComponents(string: requestedHost)
    urlComp?.scheme = "Postgres"
    
    if let url = urlComp?.url {
        DBHost = url
    } else {
        DBHost = URL(string: defaultDBHost)!
    }
    
} else {
    DBHost = URL(string: defaultDBHost)!
}

let connection = PostgreSQLConnection(url: DBHost)


// Handle HTTP GET requests to /
router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

router.get("/addchicken/:name/:destiny") {
    request, response, next in

    guard let name = request.parameters["name"],
        let destiny = request.parameters["destiny"] else {

            Log.error("No parameters found")
            try response.status(.badRequest).end()
            return
    }
    let chickentable = ChickenTable()

    let insertQuery = Insert(into: chickentable, values: name, destiny)

    connection.execute(query: insertQuery, onCompletion: { result in
        if result.success {
            response.send("We are DONE! \(result.asValue)")
        }
        next()
    })

    //response.send("Hi! My name is \(name) and when I grow up I'm going to be an \(destiny)!")
   // next()
}

// Define app to use different port when used from Heroku.

let port: Int
let defaultPort = 8090

if let herokuPort = ProcessInfo.processInfo.environment["PORT"] {
    port = Int(herokuPort) ?? defaultPort
} else {
    port = defaultPort
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: port, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
