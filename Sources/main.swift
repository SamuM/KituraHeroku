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

Log.verbose("\(DBHost.absoluteURL)")
let connection = PostgreSQLConnection(url: DBHost)

// Handle HTTP GET requests to root
router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

router.get("/addchicken/:name/:destiny") {
    request, response, next in

    // To properly handle DB connections you should create an connection pool for it. https://github.com/IBM-Swift/Swift-Kuery
    connection.connect { error in
        if let error = error {
            Log.error("Connection error: \(error)")
            next()
        } else {
            guard let name = request.parameters["name"],
                let destiny = request.parameters["destiny"] else {
                    
                Log.error("No parameters found")
                return
            }

            let chickentable = ChickenTable()

            // Create an InsertQuery and add values to the fields using Tuples
            let insertQuery = Insert(into: chickentable, valueTuples: (chickentable.name, name), (chickentable.destiny, destiny))

            connection.execute(query: insertQuery, onCompletion: { result in
                if result.success {
                    response.send("Data added!")
                }
                response.send("Error: \(String(describing: result.asError))")
                Log.error("\(String(describing: result.asError))")
                next()
            })

        }
        // Close connection to DB since we are not using connection pooling
        connection.closeConnection()
    }

}

router.get("/chickens") {
    request, response, next in
    
    connection.connect { error in
        if let error = error {
            Log.error("Connection error: \(error)")
            next()
        } else {
            
            let chickentable = ChickenTable()
            
            // Create an InsertQuery and add values to the fields using Tuples
            let selectQuery = Select([chickentable.name, chickentable.destiny], from: chickentable)
            
            connection.execute(query: selectQuery, onCompletion: { result in
                if result.success {
                    
                    if let resultSet = result.asResultSet {
                        var resultString: String = ""
                        for row in resultSet.rows {
                            resultString += "\(row)\n"
                        }
                        response.send("Here is the data: \n \(resultString))")
                    }
                    
                }
                response.send("Error: \(String(describing: result.asError))")
                Log.error("\(String(describing: result.asError))")
                next()
            })
            
        }
        // Close connection to DB since we are not using connection pooling
        connection.closeConnection()
    }
    
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
