# Kitura–Heroku–PostgreSQL

## Requirements
- Follow instructions to install Kitura: http://www.kitura.io/en/starter/settingup.html
- And the Hello World project: http://www.kitura.io/en/starter/gettingstarted.html
- If not already, signup for free tier Heroku account: https://www.heroku.com/
- Follow instructions to install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli

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
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
```

- Run project locally https://medium.com/@m_ramsden/getting-started-with-kitura-on-heroku-3de8eae86335

- Create Heroku Project
Now we create our Heroku project. Navigate to your Heroku Dashboard: https://dashboard.heroku.com/apps. There click the 'New – Create new pp'-button. You can choose a name for your project but that is not needed for this project. YOu can also choose whatever region works for you the best.

Now you should be seeing the instructions of how to add Heroku git to your project with the help of Heroku CLI – that should already be installed for you (if not, install it now: https://devcenter.heroku.com/articles/heroku-cli). Heroku also allows you to run the code to the server through GitHub or DropBox. If you prefer those I see no reason why those wouldnät work for this tutorial, but I prefer using  heroku through the CLI.

Using the CLI lets follow the Herokus own instructions on the page.

- Open Terminal and navigate to the project folder. Login to Heroku with ```heroku login``` and enter your accounts credentials.
- Init the git project with ```git init```
- Connect the git project to heroku with CLI ```heroku git:remote -a kitura-heroku-postgress```. 'kitura-heroku-postgress' being the name of your project. You can copy this line from your own instructions page.
- Make sure you have committed the code to git by running ```git add .```, ```git commit -m "<message>"``` and the pushing it to heroku with ```git push heroku master```.

- Add PostgreSQL to the project

- Edit Main.Swift file

    - Establish PostgreSQL Connection
    - Create function to create the chicken
    - Create function to fetch all the chikens
    - Create function to fetch one chicken?
    - Push to Heroku and emonstrate the results
