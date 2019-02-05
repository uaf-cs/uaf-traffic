# UAFTRAFFIC

UAFTRAFFIC is a traffic counting app for traditional and nontraditional vehicles at intersections in rural communities.

## Description

The UAFTRAFFIC app will serve as a data collection tool of patterns of traditional and nontraditional vehicles at rural intersections. The app is being designed so that it could potentially be integrated into a Science, Technology, Engineering, Art, and Math (STEAM) program at the high school level, although developing this curriculum is beyond the scope of this project. However, the app could also be used by officials in rural communities to collect data to support RITI projects. It is possible that there is a need for commercialization or intellectual property because this will be put in the Apple App Store, but since this will be a free app, perhaps not.

The app is designed around a simple concept, where the user can drag and drop the correct vehicle from the direction it approached an intersection to the direction it left the intersection. Internally the app is recording these inputs and assigning a timestamp so that they may be used later for analysis purposes. The app should not require an active internet connection while it is being used for counting purposes, but the app should be able to produce a readable data file that can be used for upload or analysis purposes later.

The app, when operational, should be beta tested in several villages, but that is beyond the scope of this project. The timeline is to identify requirements during the fall semester of 2018, design and construct a prototype of the app during the spring semester of 2019, and prepare delivery to the App Store before the end of the project.

## Requirements

The app must:

- display a representation of an intersection along with the cardinal direction of north.
- allow the intersection to be rotated 90 degrees to customize the north cardinal direction
- allow the user to drag and drop vehicles from one side of the screen to the next
- allow the user interface to scale based on the resolution of the output device
- be deliverable to the app store
- use icons to represent the type of vehicle
- use a sound effect as audio feedback that their input was received
- display a gear icon to switch back and forth between the data management and the traffic recording capability
- allow the data management section to be restricted by a passcode

## Timeline

| February 2019        | March 2019          | April 2019          |
| -------------------- | ------------------- | ------------------- |
| GitHub repository    | Rotate Intersection | Data Management     |
| Display Intersection | Sound Effects       | Connect to Server   |
| Drag/Drop Vehicles   | Data File           | Upload Traffic Data |

## Design and Layout

![App Layout](applayout.png)
