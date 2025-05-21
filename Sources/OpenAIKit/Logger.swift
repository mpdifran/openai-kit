//
//  Logger.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-21.
//

public extension Logger {
    enum LogLevel: Sendable {
        case none
        case warning
        case debug

        var marker: String {
            switch self {
            case .none:
                ""
            case .warning:
                "[Warning]"
            case .debug:
                "[Debug]"
            }
        }
    }
}

public struct Logger: Sendable {
    public static let shared = Logger()

    private init() { }

    private var level: LogLevel = .none
}

extension Logger {

    public mutating func set(logLevel: LogLevel) {
        self.level = logLevel
    }

    func log(_ logLevel: LogLevel, _ output: String) {
        switch (level, logLevel) {
        case (.none, _):
            break
        case (.warning, .warning), (.debug, .debug), (.debug, .warning):
            print("\(logLevel.marker) \(output)")
        case (.warning, .debug), (.warning, .none), (.debug, .none):
            break
        }
    }
}
