import Foundation
import Kitura
import HeliumLogger

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

// Define app to use different port when used from Heroku.

let port: Int
let defaultPort = 8080

if let herokuPort = ProcessInfo.processInfo.environment["PORT"] {
    port = Int(herokuPort) ?? defaultPort
} else {
    port = defaultPort
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: port, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
