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
- Add PostgreSQL to the project
- Edit Main.Swift file
- Establish PostgreSQL Connection
- Create function to create the chicken
- Create function to fetch all the chikens
- Create function to fetch one chicken?
