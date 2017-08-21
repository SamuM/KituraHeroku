# Kitura–Heroku–PostgreSQL

- Follow instructions to install Kitura: http://www.kitura.io/en/starter/settingup.html & http://www.kitura.io/en/starter/gettingstarted.html
- If not already, signup for free tier Heroku account: https://www.heroku.com/
- Follow instructions to install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli

Once you have the basic Kitura project up and running, an Heroku account set up and the Heroku CLI installed we will first mve the project to Heroku. After that we will add the needed packages to our project to use PostgreSQL and create a simple example app to walk you trhough the process of using PostgreSQL and Heroku with Kitura.

Open the Package.Swift file and add Swift-Kuery-PostgreSQL and Kitura-Request packages to the project. Your file should look smething like this afterwards:
```swift
// Package.Swift
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

- Create Heroku Project
Now we create our Heroku project. Navigate to your Heroku Dashboard: https://dashboard.heroku.com/apps. There click the 'New – Create new pp'-button. You can choose a name for your project but that is not needed for this project. YOu can also choose whatever region works for you the best.

Now you should be seeing the instructions of how to add Heroku git to your project with the help of Heroku CLI – that should already be installed for you (if not, install it now: https://devcenter.heroku.com/articles/heroku-cli). Heroku also allows you to run the code to the server through GitHub or DropBox. If you prefer those I see no reason why those wouldnät work for this tutorial, but I prefer using  heroku through the CLI.

Using the CLI lets follow the Herokus own instructions on the page.

- Open Terminal and navigate to the project folder. Login to Heroku with ```heroku login```
- 

- Add PostgreSQL to the project
- Edit Main.Swift file
- Establish PostgreSQL Connection
- Create function to create the chicken
- Create function to fetch all the chikens
- Create function to fetch one chicken?
