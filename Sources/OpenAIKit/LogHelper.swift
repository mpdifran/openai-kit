//
//  LogHelper.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-21.
//

import Foundation

public extension LogHelper {
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

public class LogHelper {
    nonisolated(unsafe) public static let shared = LogHelper()

    private init() { }

    private var level: LogLevel = .none
}

extension LogHelper {

    public func set(logLevel: LogLevel) {
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
