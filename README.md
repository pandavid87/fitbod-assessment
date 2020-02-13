# fitbod-assessment

## Tooling
The assessment uses Cocoapods for dependency management. In order to build and run the app:
* Install Cocoapods https://cocoapods.org/
* Run command `pod install` from root directory of the project

```
pod install
```

## Dependencies

The assessment uses an open source framework called Charts to render the historical one rep max data

Link to the Github project: https://github.com/danielgindi/Charts


## Architecture

The project primarily uses MVC with a focus on a separation of concerns between the different layers for reading and transforming data.  Apple's reactive framework Combine is primarily used for processing and sending data.Each view has an explicit data controller responsible for reading and storing data used by view controllers.  The view controllers interact with the data controller to start requests and can respond to results via Publishers.  Publishers are abstracted away using Combine's built in type erasure to reduce exposure of implementation detals to views.


