/// Create a one-way link to the next state in the chain
infix operator |>: OneWayPrecedence
public func |><T, A>(_ lhs: T, _ rhs: T) -> StateMachine<T, A> where T: StateList, A: ActionList {
    StateMachine(states: [(lhs, .oneWay), (rhs, .oneWay)], events: [])
}
public func |><T, A>(_ lhs: StateMachine<T, A>, _ rhs: T) -> StateMachine<T, A> where T: StateList {
    StateMachine(states: lhs.states + [(rhs, .oneWay)], events: lhs.events)
}
public func |><T, A>(_ lhs: StateMachine<T, A>, _ rhs: StateMachine<T, A>) -> StateMachine<T, A> where T: StateList, A: ActionList {
    StateMachine(states: lhs.states + rhs.states, events: lhs.events + rhs.events)
}
