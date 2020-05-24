//
//  Vector2.swift
//  MusicNotationKit
//
//  Created by Steve Barnegren on 20/12/2018.
//  Copyright © 2018 Steve Barnegren. All rights reserved.
//

import Foundation

typealias Vector2D = Vector2<Double>

struct Vector2<T> {
    
    var firstValue: T
    var secondValue: T
    
    init(_ firstValue: T, _ secondValue: T) {
        self.firstValue = firstValue
        self.secondValue = secondValue
    }
    
    var x: T {
        get { return firstValue }
        set { firstValue = newValue }    }
    
    var y: T {
        get { return secondValue }
        set { secondValue = newValue }
    }
    
    var width: T {
        get { return firstValue }
        set { firstValue = newValue }
    }
    
    var height: T {
        get { return secondValue }
        set { secondValue = newValue }
    }
}

extension Vector2 where T: AdditiveArithmetic {
    func adding(x: T) -> Vector2<T> {
        return Vector2<T>(self.x + x, y)
    }
    
    func subtracting(x: T) -> Vector2<T> {
        return Vector2<T>(self.x - x, y)
    }
    
    func adding(y: T) -> Vector2<T> {
        return Vector2<T>(self.x, self.y + y)
    }
    
    func subtracting(y: T) -> Vector2<T> {
        return Vector2<T>(self.x, self.y - y)
    }
}

extension Vector2 where T: Numeric {
    
    func lerp(to other: Self, t: T) -> Self {
        return Self(self.x + (other.x - self.x)*t,
                    self.y + (other.y - self.y)*t)
    }
    
}

extension Vector2 where T: FloatingPoint {
    
    func slope(to other: Self) -> T {
        return (other.y - self.y) / (other.x - self.x)
    }
    
    var slope: T {
        return y / x
    }
}

extension Vector2: Equatable where T: Equatable {
    static func == (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: - Math

func +(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
    return Vector2D(lhs.x + rhs.x, lhs.y + rhs.y)
}

func -(lhs: Vector2D, rhs: Vector2D) -> Vector2D {
    return Vector2D(lhs.x - rhs.x, lhs.y - rhs.y)
}

func *(lhs: Vector2D, rhs: Double) -> Vector2D {
    return Vector2D(lhs.x * rhs, lhs.y * rhs)
}

func *=(lhs: inout Vector2D, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
}

extension Vector2D {
    
    func flipX() -> Vector2D {
        return Vector2D(-x, y)
    }
    
    func flipY() -> Vector2D {
        return Vector2D(x, -y)
    }
}
