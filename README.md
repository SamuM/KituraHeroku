# Kitura–Heroku–PostgreSQL

## Pre-Requirements
- This tutorial is targeted for macOS users
- Follow instructions to install Kitura: http://www.kitura.io/en/starter/settingup.html
- Implement the Hello World project to ensure that everything works: http://www.kitura.io/en/starter/gettingstarted.html
- Sign up for free-tier Heroku account: https://www.heroku.com/
- Follow instructions to install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli
- Homebrew installed: https://brew.sh/
- In order to be able to build the final project you need to have PostgreSQL installed locally on your computer. I recommend installing it through Homebrew. Run this ```brew install postgresql``` in Terminal.

## Setting up the Basic Project

Once you have the basic Kitura project up and running, your Heroku account set up, and the Heroku CLI installed, we are ready to start creating a simple example app. The main idea is to walk you through the process of using Kitura and PostgreSQL with Heroku. The following steps are based on the Kitura Hello World -application.

Open the Package.swift file and add ```Swift-Kuery-PostgreSQL``` and ```Kitura-Request``` packages to the project. Afterwards, your file should look like this:
```swift
// Package.swift
// swift-tools-version:3.1
 
import PackageDescription
 
let package = Package(
    name: "KituraHeroku",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/Swift-Kuery-PostgreSQL", majorVersion: 0, minor: 10),
        .Package(url: "https://github.com/IBM-Swift/Kitura-Request.git", majorVersion: 0)
])
```

- After updating the package, we can run swift package generate-xcodeproj(this works if you are running macOS and Xcode). This generates an xcodeproj file that allows you to use Xcode to edit the project with all the Xcode features. Note that this has to be run every time you update your Packages-Swift file as it fetches the added packages.

- Afterwards, if you want to fetch the latest versions of packages, you can run ```swift package fetch```

- For now you just have the Kitura Hello World program in your ```Main.swift``` file. Please find the code below:

```swift
// Main.swift
 
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
 
// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)
 
// Start the Kitura runloop (this call never returns)
Kitura.run()
```

- If you generated the Xcode project file, you can run the code on Xcode by opening the project and running the target that looks like a Terminal icon on 'My Mac'. After Xcode is done building and compiling, you can open a new browser window and navigate to http://localhost:8080/that should display your 'Hello, World!' text. 

- You can also run the project from Terminal. In Terminal, run ```swift build```. That obviously builds the project. Then execute the file that is named after your project ```.build/debug/<projectName>```. For example, I would run my project like this  ```.build/debug/KituraHeroku```. After Kitura starts, you can navigate tohttp://localhost:8080/  just like with the instance started from Xcode.

## Heroku Integration

Now we can create our Heroku project. Navigate to your Heroku Dashboard: https://dashboard.heroku.com/apps. Click the 'New – Create new app'-button. Enter a name for your project. Also, choose whichever region works the best for you.
Now you should be seeing instructions about how to add a Heroku git to your project with the help of Heroku CLI – that should already be installed for you (if not, install it now: https://devcenter.heroku.com/articles/heroku-cli). Heroku also allows you to run the code on the server through GitHub or DropBox. If you prefer those, I see no reason why they wouldn't work for this tutorial, but I prefer using Heroku through the CLI.

Before we can push the project to Heroku we need to add a ```Procfile``` to the root of the project. Create the file and add ```web: KituraHeroku``` into the file. 'KituraHeroku' being your project name'.

After creating the Procfile, we need to run a command to define which buildpack we wish to use with our Heroku application. Run this using Terminal:
```
heroku buildpacks:set https://github.com/kylef/heroku-buildpack-swift.git
```

Heroku uses a different port than our default 8080. Therefore we need to make the Heroku port number selection automatic in our ```Main.swift``` file, where we add the import for Foundation and the code to automate the port selection.

Modifiy ```Main.swift```to look like this:

```swift
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
 
// Use Heroku-provided port number when run  on Heroku.
 
let port: Int
let defaultPort = 8080
 
if let herokuPort = ProcessInfo.processInfo.environment["PORT"] {
    port = Int(herokuPort) ?? defaultPort
} else {
    port = defaultPort
}
 
// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: port, with: router)
 
// Start the Kitura run loop (this call never returns)
Kitura.run()
```

Using Heroku CLI, let’s follow Heroku’s own instructions:
- Open Terminal and navigate to the project folder. Login to Heroku with ```heroku login``` and enter your account credentials.
- Init the git project with ```git init```
- Connect the git project to Heroku with CLI ```heroku git:remote -a kitura-heroku-postgress```. 'kitura-heroku-postgress' being the name of your project. You can copy this line from your own instructions page.
- Make sure you have committed the code to git by running ```git add .```, ```git commit -m "<message>"``` and then pushing it to Heroku with ```git push heroku master```. Launching the app on Heroku takes a while, but after Terminal gives you a new empty prompt, you can run the application with ```heroku open```. You should see your app displaying the same 'Hello, World!' text from the cloud, as we have seen previously from a local server.


## Adding PostgreSQL to the Project

Now that we have our app running on Heroku, we can concentrate on developing it further. Next, we will add PostgreSQL to the application. We will add the database using the Heroku dashboard.

- Navigate to your Heroku dashboard https://dashboard.heroku.com and select your Kitura application.
- Open the 'Resources' tab from the project navigation. From the 'Add-ons' selection, search for 'Heroku Postgres'. Choose the free tier Hobby Dev plan and add it to the project.
- Click the newly added database to open its control panel.
- On the database admin panel scroll down to 'ADMINISTRATION' and click 'Database Credentials'.
- Copy the command script labeled 'Heroku CLI’ to clipboard. This command logs us into our newly created database.
- Open new tab in Terminal and paste & run the command.
- Now we can use queries and such interactively with the database. Next, we are going to create our first table.
- Run this command to create a table for chickens: 
```sql 
CREATE TABLE chickentable (id SERIAL, name varchar(256) NOT NULL, destiny varchar(256) NOT NULL);
```
- Enter ```\q``` to quit the interactive mode.

## Working With the PostgreSQL

Now that we have the Database set up and have created our first table, we can start using it.

Lets add a few new imports from Packages that we already added to the project. Add these to the ```Main.swift``` file imports:

```swift
import HeliumLogger
import LoggerAPI
import SwiftKuery
import SwiftKueryPostgreSQL
import KituraRequest
```

Next, we are going to add some logging with the HeliumLogger package that we already have added to the project. Add this line of code to the Main.swift file right at the top after the imports.
```swift
HeliumLogger.use()
```
If you are using Xcode you should see the autocomplete feature working just like with regular projects. If you now build and run the project, you can see that we have some more verbose information coming from the server.

As the first database-related task, we will create a class to represent the actual database table. Please add the following code block below the HeliumLogger.use()-line:

```swift
class ChickenTable: Table {
    let tableName = "chickentable"
    
    let name = Column("name")
    let destiny = Column("destiny")
}
```

Next we will set up the project so that we can connect to a local or remote Heroku database depending on where the application is running.
 
Modify your Main.swift file to look like this:
```swift
import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import SwiftKuery
import SwiftKueryPostgreSQL
import KituraRequest
 
HeliumLogger.use()
 
class ChickenTable: Table {
    let tableName = "chickentable"
    
    let name = Column("name")
    let destiny = Column("destiny")
}
 
// Create a new router
let router = Router()
 
// Setup DB connections to use the correct DB_URL depending on the environment the project is run in.
 
let DBHost: URL
let defaultDBHost = "localhost"
 
// Check if we are running on Heroku by requesting DB_URL from Heroku environment variables
if let requestedHost = ProcessInfo.processInfo.environment["DATABASE_URL"] {
    // There is an annoying feature in Kitura that requires us to make the postgres address coming from Heroku to have an uppercase first letter
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
 
// Configure the app to use a different port when used from Heroku.
 
let port: Int
let defaultPort = 8090
 
if let herokuPort = ProcessInfo.processInfo.environment["PORT"] {
    port = Int(herokuPort) ?? defaultPort
} else {
    port = defaultPort
}
 
// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: port, with: router)
 
// Start the Kitura run loop (this call never returns)
Kitura.run()
```

Next we will establish a connection to our database and create a simple insert query to add rows to the database table. Add the below code after the ```router.get(“/")```-block.
```swift
router.get("/addchicken/:name/:destiny") {
    request, response, next in
 
    // To properly handle DB connections, you should create a connection pool for the database. https://github.com/IBM-Swift/Swift-Kuery
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
 
            // Create an insert Qquery and add values using Tuples
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
```

Now we can test out our app to ensure that everything is working fine. Do a ```git commit -am "comment here"```. After that, push to heroku with ```git push heroku master```. This deploys the application to Heroku. When it is done, type ```heroku open``` in Terminal and navigate to ```/addchicken/Frank/McNugget``` to test the app.

Next we will create a simple query to fetch the data on all of the chickens.

Add this piece of code after the last router block:

```swift
router.get("/chickens") {
    request, response, next in
    
    connection.connect { error in
        if let error = error {
            Log.error("Connection error: \(error)")
            next()
        } else {
            
            let chickentable = ChickenTable()
            
            // Create a select query to fetch all stored chickens
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
```

Commit and push the code to Heroku and try our new /chickens endpoint. You should see a raw representation of our data.
 
You can get the full source code for the project here: https://github.com/SamuM/KituraHeroku
