/// Create a cycle link to the beginning of the one-way chain
infix operator <|>: LoopPrecedence
public func <|><T, A>(_ lhs: T, _ rhs: T) -> StateMachine<T, A> where T: StateList, A: ActionList {
    StateMachine(states: [(lhs, .oneWay), (rhs, .cycle)])
}
public func <|><T, A>(_ lhs: StateMachine<T, A>, _ rhs: T) -> StateMachine<T, A> where T: StateList, A: ActionList {
    StateMachine(states: lhs.states + [(rhs, .cycle)], events: lhs.events)
}
