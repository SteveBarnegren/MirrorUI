# MirrorUI

[![License](https://img.shields.io/cocoapods/l/TweenKit.svg?style=flat)](http://cocoapods.org/pods/TweenKit)
[![Twitter](https://img.shields.io/badge/contact-@stevebarnegren-blue.svg?style=flat)](https://twitter.com/stevebarnegren)

MirrorUI uses reflection to construct a UI to edit your object's properties. It's a great way to quickly add controls to your demos, experiments and prototypes.

// Image

## Instructions

Simply create a class with the fields that you want to manipulate. Use the `@MirrorUI` property wrapper to expose these to MirrorUI.

You might like to make this a singleton so that you can access it from other places in your application.

```swift
class Settings {
  static let shared = Settings()

  @MirrorUI var blurEnabled = true
  @MirrorUI var lives = 4
  @MirrorUI var startingHealth = 12.5
  @MirrorUI(range: 0...20) var damage = 5.3
  @MirrorUI var greeting = "Welcome"
}

```

Then, simply construct a `MirrorView` with the instance of your object. You can present this SwiftUI view however you like. As a modal, for instance.

```swift
let mirrorView = MirrorView(object: Settings.shared)
```

The presented view will look like this:

<img style="border:10px solid black; border-radius: 7px;" src="https://user-images.githubusercontent.com/6288713/109864223-79f60800-7c5a-11eb-828e-18e2b87cee1d.png">

Any changes made will be reflected in the properties of your object. You can read these properties as normal throughout the rest of your application.

## Callbacks

Properties using the `@MirrorUI` property wrapper will not trigger callbacks through property observers such as `didSet`.

Instead, there is a `didSet` closure on the property wrapper that you can set to revieve a callback when the value is updated:

```swift
class Settings {

  @MirrorUI var blurEnabled = true
  
  init() {
    _blurEnabled.didSet = { newValue in
      // perform update
    }
  }
}
```

## Supported types

To be able to present UI to edit a type, MirrorUI needs to have a 'mapping' to a view for that type. Several common types are supported out of the box:

- String
- Bool
- Int and other FixedWidthInteger types
- Double
- Float
- SwiftUI.Color
- CGFloat
- CGPoint
- CGSize
- CGRect
- Enums*

* Enums must conform to `CaseIterable`. Enums that contain cases with associated values will require bespoke view mappings.

## Configuration

Some types have additional configuration.

Comparable types can be given minimum and maximum values:

```

class Settings {
  @MirrorUI var lives = true

  init() {
    _lives.min = 0
    _lives.max = 99
  }
}
```

## Custom view mappings

Any type can be supported in MirrorUI, provided there is a view mapping for that type. You can add mappings for additional types by registering a `ViewMapping` with the `ViewMapper`.

Create a custom `ViewMapping` instance for your type. The ViewMapping is passed an instance of the type to display/modify. This is wrapped in a `Ref<T>` container, and can be read/written through `ref.value` as in the following example.

```swift
// Our custom type
enum Size: Int {
  case small
  case medium
  case large
}

// A mapping for the Size type
let sizeMapping = ViewMapping(for: Size.self) { (ref, context) -> AnyView in

  let binding = Binding(get: { ref.value.rawValue },
                        set: { ref.value = Size(rawValue: $0)! })

  let view = VStack(alignment: .leading, spacing: 0) {
    Text(context.propertyName)
    Picker(context.propertyName, selection: binding) {
      Text("Small").tag(0)
      Text("Medium").tag(1)
      Text("Large").tag(2)
    }
  }

  return AnyView(view)
}
```

Note that it will be required to write a custom `Binding<T>` for the value. Writing to the value will trigger SwiftUI to update the view. Most mappings show the property name, this can be found in `context.propertyName`.

Simply register the mapping with the ViewMapper, and it will map to any fields of the matching type.

```
ViewMapper.defaultMapper.add(mapping: sizeMapping)
```

In some instances, the view may also need to save additional state of its own. For instance, there may be multiple display modes the view can be in, or there may be input that isn't commited immediately. In this case, there is a state dictionary that the view can read and write from to store this information.

The following mapping provides a text field for editing a `String`. The value is only updated on `onCommit`. During editing the partial value is stored in the state dictionary until it is ready to commit back to the object. The state dictionary can be accessed via `context.state.value`.

```
let stringMapping = ViewMapping(for: String.self) { ref, context in

  var partial: String {
    get { context.state.value["text"] as? String ?? ref.value }
    set { context.state.value["text"] = newValue }
  }

  let binding = Binding(get: { partial },
                        set: { partial = $0 })

  let view = HStack {
    Text("\(context.propertyName):")
    TextField(context.propertyName, text: binding, onCommit: {
      ref.value = partial
      context.state.value["text"] = nil
    })
  }

  return AnyView(view)
}
```

## How does it work?

MirrorUI uses reflection through Swift's `Mirror` api to understand which fields an object has, and what types those fields are. The `@MirrorUI` property wrapper wraps each field in a `Ref<T>` type container, which gives each property reference semantics, even if the underlying type is a value type.

A `ViewMapping` is held for each supported property type in the `ViewMapper`. If `MirrorView` is able to match a mapping to a property, then it will display that view. Because each property has reference semantics, it's possible to pass each view a `Ref<T>` containing the value of that property that it can then modify.

## Author

Steve Barnegren

steve.barnegren@gmail.com

@stevebarnegren

## License

MirrorUI is available under the MIT license. See the LICENSE file for more info.
