# Mochi
A sample demonstrating the use of AVPlayer to build a video feed. The project is written in Swift 5.0 using Xcode 11.2.1.

Deployment - Building and deploying on an iOS simulator should be pretty direct but deploying on an external iOS device would need signing in to an active development team. 

Steps to deploy to a simulator - 

1. Download or clone the repository
2. Open the xcworkspace file in Xcode
3. Choose any iOS simulator from the list of available devices
4. Run

Technical design - The app adopts Instagram style scrolling mechanism where if two cells are equally visible on the screen, the direction of the scroll would determine which cell is playing its video.
