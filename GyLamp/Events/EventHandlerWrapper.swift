//
//  EventHandlerWrapper.swift
//  GyLamp
//
//  Created by Nikita Tarkhov on 05.02.2021.
//  Copyright © 2021 nproject. All rights reserved.
//

// An object that has some tear-down logic
public protocol EventDisposable {
    func dispose()
}


/// An event provides a mechanism for raising notifications, together with some
/// associated data. Multiple function handlers can be added, with each being invoked,
/// with the event data, when the event is raised.
public class Event<T> {
    
    public typealias EventHandler = (T) -> ()
    
    fileprivate var eventHandlers = [EventInvocable]()
    
    public init() {
    }
    
    /// Raises the event, invoking all handlers
    public func raise(data: T) {
        for handler in self.eventHandlers {
            handler.invoke(data)
        }
    }
    
    /// Adds the given handler
    public func addHandler<U: AnyObject>(target: U, handler: @escaping (U) -> EventHandler) -> EventDisposable {
        let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }
}

// MARK:- Private

// A protocol for a type that can be invoked
private protocol EventInvocable: class {
    func invoke(_ data: Any)
}

// takes a reference to a handler, as a class method, allowing
// a weak reference to the owning type.
// see: http://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/
private class EventHandlerWrapper<T: AnyObject, U> : EventInvocable, EventDisposable {
    
    public typealias EventWrapperHandler = (T) -> (U) -> ()
    
    weak var target: T?
    let handler: EventWrapperHandler
    let event: Event<U>
    
    init(target: T?, handler: @escaping EventWrapperHandler, event: Event<U>){
        self.target = target
        self.handler = handler
        self.event = event;
    }
    
    func invoke(_ data: Any) -> () {
        if let t = target {
            handler(t)(data as! U)
        }
    }
    
    func dispose() {
        event.eventHandlers = event.eventHandlers.filter { $0 !== self }
    }
}
