//
//  Observable.swift
//  MapleStoryGuide
//
//  Created by dhoney96 on 2023/02/08.
//

class Observable<T> {
    
    struct Observer<T> {
        weak var observer: AnyObject?
        let listener: (T) -> Void
    }
    
    var value: T {
        didSet {
            notifyObservers()
        }
    }
    
    private var observers = [Observer<T>]()
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(on observer: AnyObject, _ closure: @escaping (T) -> Void) {
        observers.append(Observer(observer: observer, listener: closure))
    }
    
    func unsubscribe(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.listener(value)
        }
    }
}
