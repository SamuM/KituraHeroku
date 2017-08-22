# Kitura–Heroku–PostgreSQL

## Requirements
- This tutorial is targeted for OS X users
- Follow instructions to install Kitura: http://www.kitura.io/en/starter/settingup.html
- And the Hello World project: http://www.kitura.io/en/starter/gettingstarted.html
- If not already, signup for free tier Heroku account: https://www.heroku.com/
- Follow instructions to install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli
- Homebrew installed: https://brew.sh/
- In order to be able to build the final project you need to have PostgreSQL installed on your computer. I recommend installing it through Homebrew. Run this ```brew install postgresql```in your terminal.

## Setting up the basic project

Once you have the basic Kitura project up and running, an Heroku account set up and the Heroku CLI installed we will first mve the project to Heroku. After that we will add the needed packages to our project to use PostgreSQL and create a simple example app to walk you trhough the process of using PostgreSQL and Heroku with Kitura.

Open the Package.Swift file and add ```Swift-Kuery-PostgreSQL``` and ```Kitura-Request``` packages to the project. Your file should look smething like this afterwards:
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

- After updating the package we can run ```swift package generate-xcodeproj```(this works if you are running OS X and Xcode. This generates xcodeproj file that allows you to use Xcode to edit the project with all the Xcode features. Note that this has to be run everytime you update your Packages-Swift file as it fetches the added packages.

- Afterwards if you want to fetch latest version of packages you can run ```swift package fetch```

- For now you just have the Kitura Hello World porgram on your ```Main.swift```file. If not here is the code:

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
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
```

- If you generated the Xcode project file you can run the code on Xcode by opening the project and running the target that looks like a Terminal icon on 'My Mac'. After Xcode finishesh building and compiling you can open a new browser window and navigate to http://localhost:8090/ that should display your 'Hello World!' text. 

- You can also run the project from Terminal. In Terminal run ```swift build```. That obviously builds the project. Then run the file that is named after your project from ```.build/debug/<projectName>```. For example I would run my project like this ```.build/debug/KituraHeroku```. After Kitura starting you can navigate to http://localhost:8090/ just like with instance started  by Xcode.

## Heroku integration

Now we can create our Heroku project. Navigate to your Heroku Dashboard: https://dashboard.heroku.com/apps. There click the 'New – Create new app'-button. You can choose a name for your project but that is not needed for this project. YOu can also choose whatever region works for you the best.

Now you should be seeing the instructions of how to add Heroku git to your project with the help of Heroku CLI – that should already be installed for you (if not, install it now: https://devcenter.heroku.com/articles/heroku-cli). Heroku also allows you to run the code to the server through GitHub or DropBox. If you prefer those I see no reason why those wouldn't work for this tutorial, but I prefer using  heroku through the CLI.

Before we can push the project to heroku we need to create a ```Procfile``` to the root of the project. Create the file and add ```web: KituraHeroku```to the file. 'HerokuKitura being your project name'.

After creating the Procfile we need to run a command to define what buildback we want to use with our Heroku. Run this on Terminal 
```heroku buildpacks:set https://github.com/kylef/heroku-buildpack-swift.git```

Heroku uses different port than our default 8080 so we need to listen for Herokus port of choice from our ```Main.swift```file where we add the import for Foundation and the code to specify the port used.

Modifie ```Main.swift```to look like this:

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
```

Using the CLI lets follow the Herokus own instructions on the page.

- Open Terminal and navigate to the project folder. Login to Heroku with ```heroku login``` and enter your accounts credentials.
- Init the git project with ```git init```
- Connect the git project to heroku with CLI ```heroku git:remote -a kitura-heroku-postgress```. 'kitura-heroku-postgress' being the name of your project. You can copy this line from your own instructions page.
- Make sure you have committed the code to git by running ```git add .```, ```git commit -m "<message>"``` and the pushing it to heroku with ```git push heroku master```. Launching the app on Heroku takes a while, but after Terminal gives you an new empty prompt you can open the application by running ```heroku open```. You should see your app running the same 'Hello, World!' text as we have seen previously.

## Adding PostgreSQL to the project

Now that we have our app running in Heroku we can concentrate on developing it further, meaning next we will add PostgreSQL to it. And this we will do from the Heroku dashboard.

- Navigate to your Heroku dashboard https://dashboard.heroku.com and open your Kitura running application.
- Open ```Resources``` tab from the project navigation adn type ```postgres```on the 'Add-ons' search box and Select 'Heroku Postgres'. Choose the free tier Hobby Dev plan and add it to the project.
- Click the newly added database to open its controll panel in a new tab.
- Scroll down to 'ADMINISTRATION' and click 'Database Credentials'.
- Copy the heroku command labeled 'Heroku CLI'. This command logs us in to our newly created Database.
- Open new tab in Terminal and paste & run the command.
- Now we can run queries and such to the Database. For now we are going to create our first table.
- Run this command to create our table for chickens: 
```sql 
CREATE TABLE chickentable (id SERIAL, name varchar(256) NOT NULL, destiny varchar(256) NOT NULL);
```

## Working with the PostgreSQL

Now that we have the Database set up and have created our table we can start using it.

Lets add few new imports from Packages that we already added to the project. Add these to the Main.swift files imports:
```swift
import SwiftKuery
import SwiftKueryPostgreSQL
import KituraRequest
```

Then we are going to add some logging with HeliumLogger package that we already have added to the project. Add this line of code to the Main.swift file right at the top after the imports.
```swift
HeliumLogger.user()
```
If you are using the Xcode you should see the autocomplete working just like with regular projects.
If you now build and run the project you can see that we have some more verbose information coming from the server.

- Edit Main.Swift file

    - Establish PostgreSQL Connection
    - Create function to create the chicken
    - Create function to fetch all the chikens
    - Create function to fetch one chicken?
    - Push to Heroku and emonstrate the results
