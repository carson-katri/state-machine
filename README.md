# State Machine

Dead simple state machines in Swift.

## Usage
Setup your states:

```swift
enum FetchStates: StateList {
    case idle, fetching, error
}
```

and your actions:

```swift
enum FetchActions: ActionList {
    case fetch, success, failure, retry, reset
}
```

Then create your machine:

```swift
var machine: StateMachine<FetchStates, FetchActions> = .idle <> .fetching <> .error <|> .idle
```

Bind your actions:

```swift
try machine.bindAction(.fetch, to: .idle)
try machine.bindAction(.success, to: .fetching, .cycle)
try machine.bindAction(.failure, to: .fetching)
try machine.bindAction(.retry, to: .error, .cycle)
try machine.bindAction(.reset, to: .error)
```

Add events for your states and/or actions:

```swift
machine.addEvent(on: [.fetch, .retry]) {
    // Perform fetch operation
}
machine.addEvent(on: .success) {
    // Show data
}
machine.addEvent(on: .error) {
    // Show error
}
```

Send events:

```swift
try machine.send(.fetch)
```

And that's all it takes to get a working state machine 🎉
