# ExpressWash.us (formerly Wo-Wo)

## Contributors

|                                       [Joel Groomer](https://github.com/joelgroomer)                                        |                                       [Robert Keffury](https://github.com/Keffury1)                                        |                                       
| :-----------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------: |
|                      [<img src="https://github.com/Lambda-School-Labs/wowo-ios/blob/master/README_images/Joel.jpg?raw=true" width = "200" />](https://github.com/joelgroomer)                       |                      [<img src="https://github.com/Lambda-School-Labs/wowo-ios/blob/master/README_images/Robert.png?raw=true" width = "200" />](https://github.com/Keffury1)                       |
|                 [<img src="https://github.com/favicon.ico" width="15"> ](https://github.com/joelgroomer)                 |            [<img src="https://github.com/favicon.ico" width="15"> ](https://github.com/Keffury1)             |
| [ <img src="https://static.licdn.com/sc/h/al2o9zrvru7aqj8e1x2rzsrca" width="15"> ](https://www.linkedin.com/in/joelgroomer/) | [ <img src="https://static.licdn.com/sc/h/al2o9zrvru7aqj8e1x2rzsrca" width="15"> ](https://www.linkedin.com/in/robert-keffury-426188142/) |


[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://cocoapods.org/)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://www.apple.com/ios/ios-13/)

[![Maintainability](https://api.codeclimate.com/v1/badges/b0e7997cfcbf8e3931ca/maintainability)](https://codeclimate.com/github/Lambda-School-Labs/wowo-ios/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/b0e7997cfcbf8e3931ca/test_coverage)](https://codeclimate.com/github/Lambda-School-Labs/wowo-ios/test_coverage)


## Project Overview

You can clone and build this project in Xcode.
Test the app directly on your phone from TestFlight: https://testflight.apple.com/join/xOHV2Zmj (last deployed 25 Jun, 2020)

You can find the deployed web project at [www.expresswash.us](https://www.expresswash.us).

[Trello Board](https://trello.com/b/LeNRHnQ2/labspt9-wowo)

[Product Canvas](https://www.notion.so/WoWo-Wax-On-Wax-Off-fd2deecea49f462699b5ce23d15cf3ff)


## Problem

- People struggle to find time to hand wash their cars.  Automatic car washes are expensive and can often damage cars with heavy brushes and harsh chemicals.
- A lot of people are looking to make an honest extra buck.  But they'd like to work outside and do something with their hands.
- Contractors want to have a flexible schedule and set their own rates.

## Mission

A . Let customers hire a car washer that they like and trust (based on the car washer's profile and cost) to come to them and wash and/or detail their cars.  

B.  Let people become paid car washers by creating a profile that customers can view.

C. Allow customers to hire car washers and facilitate and manage the transaction.

D. Allow customers and car washers to rate and leave feedback about each other.

![](https://github.com/Lambda-School-Labs/wowo-ios/blob/master/README_images/ExpressWashScreens.png)

### Features

-   Schedule a Car Wash
    - Search for your desired location and see it on a map
    - Select your desired Washer from a list of available Washers in your area
-   In-App payment via Stripe
-   Notification of completed job (via email)
    - See before and after photos of your wash
-   Map of job location for Washers
    - Details of the car to be washed are displayed
-   User profiles, add multiple cars to your account
-   Washers can set rates for small, medium, and large cars

### Authentication API here

Authentication is done through JWT via the back-end. To authenticate requests in the app, add UserController.shared.bearerToken to your request.

`request.setValue(UserController.shared.bearerToken, forHTTPHeaderField: "Authorization")`


### Payment API here

Stripe: 

Stripe is a service that allows users to accept payments online, specifically developers. With the Stripe application, users can keep track of payments, search past payments, create recurring charges, and keep track of customers.


### Misc API here

MapBox:

Mapbox is the location data platform for mobile and web applications. They provide building blocks to add location features like maps, search, and navigation into any experience created.


## Requirements

-   iOS 13.0+
-   Xcode 11.0+
-   Cocoa Pods

## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we have a [code of conduct](./CODE_OF_CONDUCT.md). Please follow it in all your interactions with the project.

### Issue/Bug Request

    ## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we have a [code of conduct](./code_of_conduct.md). Please follow it in all your interactions with the project.

### Issue/Bug Request

 **If you are having an issue with the existing project code, please submit a bug report under the following guidelines:**
 - Check first to see if your issue has already been reported.
 - Check to see if the issue has recently been fixed by attempting to reproduce the issue using the latest master branch in the repository.
 - Create a live example of the problem.
 - Submit a detailed bug report including your environment & browser, steps to reproduce the issue, actual and expected outcomes,  where you believe the issue is originating from, and any potential solutions you have considered.

### Feature Requests

We would love to hear from you about new features which would improve this app and further the aims of our project. Please provide as much detail and information as possible to show us why you think your new feature should be implemented.

### Pull Requests

If you have developed a patch, bug fix, or new feature that would improve this app, please submit a pull request. It is best to communicate your ideas with the developers first before investing a great deal of time into a pull request to ensure that it will mesh smoothly with the project.

Remember that this project is licensed under the MIT license, and by submitting a pull request, you agree that your work will be, too.

#### Pull Request Guidelines

- Ensure any install or build dependencies are removed before the end of the layer when doing a build.
- Update the README.md with details of changes to the interface, including new plist variables, exposed ports, useful file locations and container parameters.
- Ensure that your code conforms to our existing code conventions and test coverage.
- Include the relevant issue number, if applicable.
- You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.

### Attribution

These contribution guidelines have been adapted from [this good-Contributing.md-template](https://gist.github.com/PurpleBooth/b24679402957c63ec426).


## Documentation

See [Backend Documentation](https://github.com/Lambda-School-Labs/wowo-be) for details on the backend of our project.


[swift-image]: https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics

