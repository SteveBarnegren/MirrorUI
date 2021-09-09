import Foundation

struct EachWithIsLastBidirectionalCollection<Base> where Base: BidirectionalCollection {

    let base: Base

    init(_ baseCollection: Base) {
        self.base = baseCollection
    }
}

extension EachWithIsLastBidirectionalCollection: BidirectionalCollection {
    
    subscript(position: Base.Index) -> (Base.Element, Bool) {
        return (base[position], position == self.index(startIndex, offsetBy: count-1))
    }
    
    var startIndex: Base.Index {
        return base.startIndex
    }
    
    var endIndex: Base.Index {
        return base.endIndex
    }
    
    func index(after i: Base.Index) -> Base.Index {
        return base.index(after: i)
    }
    
    func index(before i: Base.Index) -> Base.Index {
        return base.index(after: i)
    }
}

extension BidirectionalCollection {
    
    func eachWithIsLast() -> EachWithIsLastBidirectionalCollection<Self> {
        return EachWithIsLastBidirectionalCollection(self)
    }
}
