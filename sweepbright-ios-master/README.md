# SweepBright

Master [![Circle CI](https://circleci.com/gh/madewithlove/sweepbright-ios/tree/master.svg?style=svg&circle-token=f7e6118f03784831d27aca8eae277821b7771477)](https://circleci.com/gh/madewithlove/sweepbright-ios/tree/master)

Development [![Circle CI](https://circleci.com/gh/madewithlove/sweepbright-ios/tree/development.svg?style=svg&circle-token=f7e6118f03784831d27aca8eae277821b7771477)](https://circleci.com/gh/madewithlove/sweepbright-ios/tree/development)

# How to start working in a feature

If you want to start working in a new feature. Create a new branch `development/<feature-name>`, run `pod install` into project's folder to install the dependencies and go ahead.

# Distribuition
### Fabric
We're using Fabric to distribute the app for beta purpose. There are 3 groups of beta testers on Fabric:

|madewithlove|Email|
|------------:| ----:|
|Andreas Creten|andreas@madewithlove.be|
|Jonas Van Schoote|jonas@madewithlove.be|
|Hannes Van De Vreken|hannes@madewithlove.be|
|Hannes Van De Vreken| hannes@mwl.be|
|Kaio Brito| kaio@madewithlove.be|
|Isaac Mogetutu| isaak@madewithlove.be|
|Claudia Reynders| claudia@mwl.be|

|MONO| Email|
|------------:|------------:|
|Xavier| xb@mono.company|
|Hannes D'Hulster|hello@mrhannes.be|


|SweepBright| Email |
|------------:|------------:|
|Raphael|raphael@sweepbright.com|
|Yoram|yoram@sweepbright.com|

### Pull request for review

If you've finished a feature and want submit it to an internal review, add a tag `review-<feature-name>` and send a PR to the `development` branch. Every time a tag like that is pushed, CircleCI will build a new release and send it to Fabric.

**The review release is only available for `madewithlove` group members.**

### Beta distribution

If you want to send a release for all Fabric groups, add a tag `review-<feature-name>` and send a PR to `fabric` branch. All `madewithlove` members will get an invitation to review it. When the PR was merged, a new release will be available for all testers.

#Patterns
* [Delegation](https://en.wikipedia.org/wiki/Delegation_pattern):  Apple uses this a lot (some would say, too much).
* [UI Data Binding](https://en.wikipedia.org/wiki/UI_data_binding): Using [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
* Copy Object: In form screens where the user can discard the changes, create a copy of the object that is been edited and bind the UI to this copy. If the user wants to save the changes, update the original one, else ignore the copy.
* UIStoryboard: As the name suggests, Storyboard should tells a story, avoid a monolithic storyboard. You can work that way, but don't complain of Xcode when it start to crash or get slow.


## Folders Organization

The project is grouped using Xcode groups. There are four groups: `models`,`UI`, `Controllers` and `Components`.

1. Models
	* Where the models lives. All models **HAS TO** be a protocol, the controllers will never talk to a model class directly.
2. UI
	* Where the storyboards lives.
3. Controllers
	* Where the implementation lives. There are ViewController, Datasource, Delegate, UITableViewCell, UICollectionCell and things like that.
4. Components
	* Where the custom elements lives.


## Threads

The requests to the server will use the component Alamofire. Some requests will depend on other requests, in these cases, NSOperationQueue is being used to keep the dependencies between threads.

## Diagrams

The classes were designed based on the feature/module, so each feature is independent from other.

* [Models](./docs/models.png)
* [Location&Description](./docs/location&description.png)
* [Rooms](./docs/rooms.png)
* [Unit](./docs/unit.png)
* [Visit](./docs/visit.png)
* Settings
* Features
* [Authentication Workflow](./docs/authentication-workflow.png)

## How offline queue works
[Offline Queue](./docs/offline-queue.md)

## Save strategies
There are 2 save strategies: `form` & `field-by-field`. There is no universal strategy, the strategy will be choiced to provide the best UX.

On the `form` strategy all the information is sent together when the back button is pressed.

The `field-by-field` strategy sends the information of a item whenever its value changes.

* [Form Strategy](http://recordit.co/7rGFctvDdU)
	* Description
	* Location
* [Field-by-field Strategy](http://recordit.co/zsybkU2pzt)
	* Rooms

--
**PS**: Edit text fields on `field-by-field` strategy will send the information when the user stops editing it.

## [Requests](./docs/requests.md)
