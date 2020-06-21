/// Create an optional cycle link to the beginning of the cycle-link chain
infix operator <>: CyclePrecedence
public func <><T, A>(_ lhs: T, _ rhs: T) -> StateMachine<T, A> where T: StateList, A: ActionList {
    StateMachine(states: [(lhs, .oneWay), (rhs, .cycleOrOneWay)])
}
public func <><T, A>(_ lhs: StateMachine<T, A>, _ rhs: T) -> StateMachine<T, A> where T: StateList, A: ActionList {
    StateMachine(states: lhs.states + [(rhs, .cycleOrOneWay)], events: lhs.events)
}
public func <><T, A>(_ lhs: StateMachine<T, A>, _ rhs: StateMachine<T, A>) -> StateMachine<T, A> where T: StateList, A: ActionList {
    precondition(rhs.states.count > 0)
    return StateMachine(states: lhs.states + [(rhs.states[0].0, .cycleOrOneWay)] + rhs.states.dropFirst(), events: lhs.events + rhs.events)
}
