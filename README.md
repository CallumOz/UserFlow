# UserFlow

This is a short app to showcase iOS Architecture.
The code is not perfect and could do with improvement.

# Architecture

The architecture is based on MVVM and Viper. It has these components:
* View Controller
* View Model
* Router
* Interactor
* Entity

## View Controller

The View Controller subclass represents the View, it doesn't contain any business logic. Each ViewController has a View Model to provide the content to show.

## View Model

The View Model exposes the content to be shown in the View Controller. It has a reference to the Router, but not to the View Controller.

## Router

The Router is used to show the View Controller and also to navigate to other View Controllers.
It has a weak reference to the View Controller.

## Interactor

The Interactor interacts with an API, cache or any other datasource. In this case it's the Deezer API. This is where business logic should be.
The Interactor doesn't have any references to the other elements.

## Entity

The Entities are usually just value types. They are models that expose and parse the values from the datasource.


