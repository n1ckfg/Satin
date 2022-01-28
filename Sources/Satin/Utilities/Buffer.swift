//
//  Buffer.swift
//  Satin
//
//  Created by Reza Ali on 4/22/20.
//

import Metal

open class Buffer {
    public var buffer: MTLBuffer!
    public weak var parameters: ParameterGroup!

    init() {}

    public init(device: MTLDevice, parameters: ParameterGroup, count: Int = 1, options: MTLResourceOptions = [.storageModeShared]) {
        self.parameters = parameters
        setupBuffer(device: device, count: count, options: options)
    }

    func setupBuffer(device: MTLDevice, count: Int, options: MTLResourceOptions) {
        guard let buffer = device.makeBuffer(length: parameters.stride * count, options: options) else { fatalError("Unable to create Buffer") }
        buffer.label = parameters.label
        self.buffer = buffer
    }

    public func update(_ index: Int = 0) {
        update(UnsafeMutableRawPointer(buffer.contents() + index * parameters.stride))
    }

    func update(_ content: UnsafeMutableRawPointer) {
        content.copyMemory(from: parameters.data, byteCount: parameters.size)
    }

    public func sync(_ index: Int) {
        sync(UnsafeMutableRawPointer(buffer.contents() + index * parameters.stride))
    }

    func sync(_ content: UnsafeMutableRawPointer) {
        var pointer = content
        var pointerOffset = 0
        for param in parameters.params {
            let size = param.size
            let alignment = param.alignment
            let rem = pointerOffset % alignment
            if rem > 0 {
                let offset = alignment - rem
                pointer += offset
                pointerOffset += offset
            }

            if param is BoolParameter {
                let boolParam = param as! BoolParameter
                boolParam.value = pointer.bindMemory(to: Bool.self, capacity: 1).pointee
                pointer += size
            }
            else if param is UInt32Parameter {
                let intParam = param as! UInt32Parameter
                intParam.value = pointer.bindMemory(to: UInt32.self, capacity: 1).pointee
                pointer += size
            }
            else if param is IntParameter {
                let intParam = param as! IntParameter
                intParam.value = Int(pointer.bindMemory(to: Int32.self, capacity: 1).pointee)
                pointer += size
            }
            else if param is Int2Parameter {
                let intParam = param as! Int2Parameter
                let isize = MemoryLayout<Int32>.size
                intParam.x = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
                intParam.y = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
            }
            else if param is Int3Parameter {
                let intParam = param as! Int3Parameter
                let isize = MemoryLayout<Int32>.size
                intParam.x = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
                intParam.y = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
                intParam.z = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
                // because alignment is 16 not 12
                pointer += isize
            }
            else if param is Int4Parameter {
                let intParam = param as! Int4Parameter
                let isize = MemoryLayout<Int32>.size
                intParam.x = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
                intParam.y = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
                intParam.z = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
                intParam.w = pointer.bindMemory(to: Int32.self, capacity: 1).pointee
                pointer += isize
            }
            else if param is FloatParameter {
                let floatParam = param as! FloatParameter
                floatParam.value = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += size
            }
            else if param is Float2Parameter {
                let floatParam = param as! Float2Parameter
                let fsize = MemoryLayout<Float>.size
                floatParam.x = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.y = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
            }
            else if param is Float3Parameter {
                let floatParam = param as! Float3Parameter
                let fsize = MemoryLayout<Float>.size
                floatParam.x = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.y = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.z = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                // because alignment is 16 not 12
                pointer += fsize
            }
            else if param is PackedFloat3Parameter {
                let floatParam = param as! PackedFloat3Parameter
                let fsize = MemoryLayout<Float>.size
                floatParam.x = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.y = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.z = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
            }
            else if param is Float4Parameter {
                let floatParam = param as! Float4Parameter
                let fsize = MemoryLayout<Float>.size
                floatParam.x = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.y = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.z = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
                floatParam.w = pointer.bindMemory(to: Float.self, capacity: 1).pointee
                pointer += fsize
            }
            pointerOffset += size
        }
    }
}

extension Buffer: Equatable {
    public static func == (lhs: Buffer, rhs: Buffer) -> Bool {
        return lhs === rhs
    }
}

extension Buffer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}