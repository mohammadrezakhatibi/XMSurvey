# XMSurvey

### Hi 👋🏼
Here are the key points about the project:

1. There is no necessary setup for running the project. Just clone (main or develop) and run XMSurvey.xcodeproj.
2. The project contains, the Feature package and the XMSurvey target.
3. I tried to keep everything simple for this project but some times you may feel over engineered solution, and it is on puporse since I wanted to show my ablities such as modularization.
4. For runnig tests, you can select `XMSurvey` scheme.
5. In the main target you can find a UI test and the rest of the tests are located insede their own feature folder. 
6. For presantation layer I'm using a simple MVVM pattern and Swift Combine.


## **Prject Structure**
The `Feature` Swift package is the heart of the app implementation. It includes the Core and Feature implementations (You check the diagram). The Shared, HTTPClient, and Models are part of the Core and form the high-level layer. The App, Home and Survey belong to the Feature layer.

## **Diagram**
<img src="https://raw.githubusercontent.com/mohammadrezakhatibi/XMSurvey/develop/XMSurvey.png" width="700">

**Thank you**

## **Requirements**
* iOS 14.0+
* Xcode 15.0+

## **Installation**
There is no necessary setup for running this project. Just clone and run!


## About

**Mohammadreza Khatibi** <br />
http://mohammadreza.me <br />
mohammadrezakhatibi@outlook.com <br />