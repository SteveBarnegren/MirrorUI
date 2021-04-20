# MirrorUI

[![Twitter](https://img.shields.io/badge/contact-@stevebarnegren-blue.svg?style=flat)](https://twitter.com/stevebarnegren)

MirrorUI uses reflection to construct a UI to edit an object's properties. It's a great way to quickly add controls to your demos, experiments and prototypes.

![MirrorUI](https://user-images.githubusercontent.com/6288713/109871391-102e2c00-7c63-11eb-8f64-0e63a8301daf.gif)

Simply add the `@MirrorUI` property wrapper and MirrorUI will construct a UI for you. You can then edit your object directly whilst your app runs.

### macOS:

![macOS](https://user-images.githubusercontent.com/6288713/109872686-a9aa0d80-7c64-11eb-84d4-2bea36bd6fdd.png)

## Integration

The easiest way to integrate MirrorUI into your project is through the Swift Package Manager.

## How to use MirrorUI

Create a class with the fields that you want to manipulate. Use the `@MirrorUI` property wrapper to expose these to MirrorUI.

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

Any changes made will be reflected in the properties of your object. You can read these properties as normal throughout the rest of your application.

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

*Enums must conform to `CaseIterable`. Enums that contain cases with associated values will require bespoke view mappings.

## Callbacks

Properties using the `@MirrorUI` property wrapper will not trigger callbacks through property observers such as `didSet`.

Instead, there is a `didSet` closure on the property wrapper that you can set to receive a callback when the value is updated:

```swift
class Settings {

  @MirrorUI var blurEnabled = true
  
  init() {
    $blurEnabled.didSet = { newValue in
      // perform update
    }
  }
}
```


## Configuration

Some types have additional configuration.

Comparable types can be given minimum and maximum values:

```swift
class Settings {
  @MirrorUI var lives = true

  init() {
    $lives.min = 0
    $lives.max = 99
  }
}
```

## Custom view mappings

Any type can be supported in MirrorUI, provided there is a view mapping for that type. You can add mappings for additional types by registering a `ViewMapping` with the `ViewMapper`.

Create a custom `ViewMapping` instance for your type. The ViewMapping is passed an instance of the type to display/modify. This is wrapped in a `Ref<T>` container, and can be read/written through `ref.value`. The following example creates a `Picker` view to select between small / medium / large cases in a `Size` enum:

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

  let view = VStack {
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

```swift
ViewMapper.shared.add(mapping: sizeMapping)
```

In some instances, the view may also need to save additional state of its own. For instance, there may be multiple display modes the view can be in, or there may be input that isn't committed immediately. In this case, there is a state dictionary that the view can read and write from to store this information.

The following mapping provides a text field for editing a `String`. The value is only updated on `onCommit`. During editing the partial value is stored in the state dictionary until it is ready to commit back to the object. The state dictionary can be accessed via `context.state.value`.

```swift
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

[www.stevebarnegren.com](www.stevebarnegren.com)

[@stevebarnegren](twitter.com/stevebarnegren)

## License

MirrorUI is available under the MIT license. See the LICENSE file for more info.
