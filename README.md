# RealityShaper

[![License][license-image]][license-url]
![swift](https://img.shields.io/badge/Swift-5.10%20|%205.9-orange)
![visionOS](https://img.shields.io/badge/visionOS-blue)
![iOS](https://img.shields.io/badge/iOS-blue)

A DSL for vending SwiftUI views that allows the user to change attributes on a RealityKit `Entity`. Enabling a type-safe way of reaching out to RealityKit content with a readable syntax. 

![Simulator Screen Recording - Apple Vision Pro - 2024-03-28 at 15 09 05](https://github.com/loomery/RealityShaper/assets/59975039/bf2a2788-ae9c-4254-88a5-90177087b0b6)

## Installation

### SPM

Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/loomery/Polymorph.git", majorVersion: 0, minor: 0)
    ]
)
```

## Usage example

Conform your Entity model to the `EntityRepresentable` protocol and setup the `init` as follows:

```swift
import RealityShaper

struct ShowroomCar: EntityRepresentable {
    let name: String
    var entity: RealityKit.Entity
    var subEntities: [Library.Entity]
    
    init(named name: String, @EntityBuilder subEntities: () async -> [Library.Entity]) async throws {
        self.name = name
        let entity = try await RealityKit.Entity(named: name, in: realityKitContentBundle)
        
        self.subEntities = await subEntities().map {
            $0.withEntity(entity)
        }
        self.entity = entity
    }
}
```

The package comes the a `resultBuilder` called `EntityBuilder` that allows you to define the sub entities of 


## Development setup

Describe how to install all development dependencies and how to run an automated test-suite of some kind. Potentially do this for multiple platforms.

```sh
make install
```

## Release History

* 0.2.1
    * CHANGE: Update docs (module code remains unchanged)
* 0.2.0
    * CHANGE: Remove `setDefaultXYZ()`
    * ADD: Add `init()`
* 0.1.1
    * FIX: Crash when calling `baz()` (Thanks @GenerousContributorName!)
* 0.1.0
    * The first proper release
    * CHANGE: Rename `foo()` to `bar()`
* 0.0.1
    * Work in progress

## Meta

Your Name – [@YourTwitter](https://twitter.com/dbader_org) – YourEmail@example.com

Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/) 

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
