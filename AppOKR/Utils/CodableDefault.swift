//
//  CodableDefault.swift
//  AppOKR
//
//  Created by Artur Sulinski on 13/03/2022.
//

import Foundation

public protocol CodableDefaultSource {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

public enum CodableDefault {}

extension CodableDefault {
    @propertyWrapper
    public struct Wrapper<Source: CodableDefaultSource>: Codable {
        typealias Value = Source.Value
        public var wrappedValue = Source.defaultValue
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            wrappedValue = try container.decode(Value.self)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(wrappedValue)
        }
        
        public init() {}
    }
}

public extension CodableDefault {
    typealias Source = CodableDefaultSource

    enum Sources {
        public enum False: Source {
            public static var defaultValue: Bool { false }
        }

        public enum EmptyString: Source {
            public static var defaultValue: String { "" }
        }
        
        public enum ZeroInt: Source {
            public static var defaultValue: Int { 0 }
        }
    }
}

public extension CodableDefault {
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias ZeroInt = Wrapper<Sources.ZeroInt>
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: CodableDefault.Wrapper<T>.Type,
                   forKey key: Key) throws -> CodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
