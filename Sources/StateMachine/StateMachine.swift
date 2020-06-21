public typealias StateList = CaseIterable & Hashable
public typealias ActionList = CaseIterable & Hashable

public struct StateMachine<T, A> where T: StateList, A: ActionList {
    public enum Direction {
        case oneWay
        case cycle
        case cycleOrOneWay
    }
    
    public let states: [(T, Direction)]
    public var events: [(T, () -> Void)] = []
    public var actionEvents: [(A, () -> Void)] = []
    
    var state: Int
    var currentState: (T, Direction) {
        states[state]
    }
    public var activeState: T {
        currentState.0
    }
    
    init(states: [(T, Direction)], events: [(T, () -> Void)] = []) {
        self.states = states
        self.events = events
        self.state = 0
    }
    
    public mutating func addEvent(on states: [T], _ action: @escaping () -> Void) {
        for state in states {
            events.append((state, action))
        }
    }
    
    public mutating func addEvent(on state: T, _ action: @escaping () -> Void) {
        addEvent(on: [state], action)
    }
    
    public mutating func addEvent(on states: [A], _ actionEvent: @escaping () -> Void) {
        for state in states {
            actionEvents.append((state, actionEvent))
        }
    }
    
    public mutating func addEvent(on action: A, _ actionEvent: @escaping () -> Void) {
        addEvent(on: [action], actionEvent)
    }
    
    public mutating func nextState() throws {
        switch currentState.1 {
        case .oneWay, .cycleOrOneWay:
            guard state + 1 < states.count else {
                throw "State out of bounds. Try adding a cycle to the end of the state machine: `.end <|> .beginning`"
            }
            self.state += 1
            if currentState.1 == .cycle {
                try nextState()
                return
            }
        case .cycle:
            guard let stateIdx = states.firstIndex(where: { $0.0 == currentState.0 }) else {
                throw "Cycle start not found"
            }
            self.state = stateIdx
        }
        runEvents()
    }
    
    public mutating func cycle() throws {
        if currentState.1 != .cycleOrOneWay {
            throw "Can't cycle state that is not .cycleOrOneWay. Use: `.cycleStart <> .cycleEnd`"
        }
        var idx = state
        while states[idx].1 == .cycleOrOneWay {
            idx -= 1
        }
        state = idx
        runEvents()
    }
    
    public enum ActionModifier {
        case nextState
        case cycle
        case jump(to: T)
    }
    var actions: [(A, T, ActionModifier)] = []
    public mutating func bindAction(_ action: A, to state: T, _ actionModifier: ActionModifier = .nextState) throws {
        if actions.contains(where: { $0.0 == action }) {
            throw "Action already bound"
        }
        actions.append((action, state, actionModifier))
    }
    
    public mutating func send(_ action: A) throws {
        guard let boundAction = actions.first(where: { $0.0 == action }) else {
            throw "Action not bound"
        }
        guard currentState.0 == boundAction.1 else {
            throw "Action not valid for current state"
        }
        switch boundAction.2 {
        case .nextState:
            try nextState()
        case .cycle:
            try cycle()
        case .jump(to: let state):
            try setState(to: state)
        }
        actionEvents.filter { $0.0 == action }
                    .forEach { $0.1() }
    }
    
    public mutating func setState(to state: T) throws {
        guard let idx = states.firstIndex(where: { $0.0 == state }) else {
            throw "State `\(state)` not found"
        }
        self.state = idx
    }
    
    func runEvents() {
        events.filter { $0.0 == currentState.0 }
              .forEach { $0.1() }
    }
}
