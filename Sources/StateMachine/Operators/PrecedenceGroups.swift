precedencegroup LoopPrecedence {
    
}

precedencegroup CyclePrecedence {
    higherThan: LoopPrecedence
    associativity: left
}

precedencegroup OneWayPrecedence {
    higherThan: CyclePrecedence
    associativity: left
}
