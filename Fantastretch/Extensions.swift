//
//  Extensions.swift
//  Fantastretch
//
//  Created by François Mockers on 04/12/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import Foundation

extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }

    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        let count = self.count
        indices.lazy.dropLast().forEach {
            swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
        }
        return self
    }

    /// choose one random element from an array
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }

    /// choose n random element out of m first elements of an array
    func choose(_ n: Int, outOf m: Int) -> Array { return Array(Array(prefix(m)).shuffled.prefix(n)) }

    /// foldLeft implementation
    func empty() -> Bool {
        return count == 0
    }
    var head: Element? {
        return first
    }
    var tail: Array<Element>? {
        if empty() { return nil }
        return Array(dropFirst())
    }
    func foldLeft<A>(acc: A, f: (A, Element) -> A) -> A {
        return tail?.foldLeft(acc: f(acc, head!), f: f) ?? acc
    }
}
