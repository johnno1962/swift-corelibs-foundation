// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//


import CoreFoundation

internal final class _NSCFArray : NSMutableArray {
    deinit {
        _CFDeinit(self)
        _CFZeroUnsafeIvars(&_storage)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    required init(objects: UnsafePointer<AnyObject?>, count cnt: Int) {
        fatalError()
    }
    
    override var count: Int {
        return CFArrayGetCount(_cfObject)
    }
    
    override func object(at index: Int) -> AnyObject {
        let value = CFArrayGetValueAtIndex(_cfObject, index)
        return unsafeBitCast(value, to: AnyObject.self)
    }
    
    override func insert(_ anObject: AnyObject, at index: Int) {
        CFArrayInsertValueAtIndex(_cfMutableObject, index, unsafeBitCast(anObject, to: UnsafeRawPointer.self))
    }
    
    override func removeObject(at index: Int) {
        CFArrayRemoveValueAtIndex(_cfMutableObject, index)
    }
    
    override var classForCoder: AnyClass {
        return NSMutableArray.self
    }
}

internal func _CFSwiftArrayGetCount(_ array: AnyObject) -> CFIndex {
    return (array as! NSArray).count
}

internal func _CFSwiftArrayGetValueAtIndex(_ array: AnyObject, _ index: CFIndex) -> Unmanaged<AnyObject> {
    return Unmanaged.passUnretained((array as! NSArray).object(at: index))
}

internal func _CFSwiftArrayGetValues(_ array: AnyObject, _ range: CFRange, _ values: UnsafeMutablePointer<Unmanaged<AnyObject>?>) {
    for idx in 0..<range.length {
        let obj = (array as! NSArray).object(at: idx + range.location)
        values[idx] = Unmanaged.passUnretained(obj)
    }
}

internal func _CFSwiftArrayAppendValue(_ array: AnyObject, _ value: AnyObject) {
    (array as! NSMutableArray).add(value)
}

internal func _CFSwiftArraySetValueAtIndex(_ array: AnyObject, _ value: AnyObject, _ idx: CFIndex) {
    (array as! NSMutableArray).replaceObject(at: idx, with: value)
}

internal func _CFSwiftArrayReplaceValueAtIndex(_ array: AnyObject, _ idx: CFIndex, _ value: AnyObject) {
    (array as! NSMutableArray).replaceObject(at: idx, with: value)
}

internal func _CFSwiftArrayInsertValueAtIndex(_ array: AnyObject, _ idx: CFIndex, _ value: AnyObject) {
    (array as! NSMutableArray).insert(value, at: idx)
}

internal func _CFSwiftArrayExchangeValuesAtIndices(_ array: AnyObject, _ idx1: CFIndex, _ idx2: CFIndex) {
    (array as! NSMutableArray).exchangeObject(at: idx1, withObjectAt: idx2)
}

internal func _CFSwiftArrayRemoveValueAtIndex(_ array: AnyObject, _ idx: CFIndex) {
    (array as! NSMutableArray).removeObject(at: idx)
}

internal func _CFSwiftArrayRemoveAllValues(_ array: AnyObject) {
    (array as! NSMutableArray).removeAllObjects()
}

internal func _CFSwiftArrayReplaceValues(_ array: AnyObject, _ range: CFRange, _ newValues: UnsafeMutablePointer<Unmanaged<AnyObject>>, _ newCount: CFIndex) {
    NSUnimplemented()
//    (array as! NSMutableArray).replaceObjectsInRange(NSMakeRange(range.location, range.length), withObjectsFromArray: newValues.array(newCount))
}
