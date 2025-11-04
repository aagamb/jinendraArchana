//
//  AppOpenTracker.swift
//  Jinendra Archana
//
//  Created by Assistant on 11/04/25.
//

import Foundation

final class AppOpenTracker: ObservableObject {
    static let shared = AppOpenTracker()

    @Published private(set) var openedDateKeys: Set<String>

    private let storageKey = "app_open_dates_keys_v1"

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private init() {
        if let saved = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            openedDateKeys = Set(saved)
        } else {
            openedDateKeys = []
        }
    }

    func markOpenedToday() {
        let key = Self.key(for: Date())
        if !openedDateKeys.contains(key) {
            openedDateKeys.insert(key)
            persist()
        }
    }

    func isOpened(on date: Date) -> Bool {
        openedDateKeys.contains(Self.key(for: date))
    }

    var totalDaysOpened: Int { openedDateKeys.count }

    private func persist() {
        UserDefaults.standard.set(Array(openedDateKeys), forKey: storageKey)
    }

    private static func key(for date: Date) -> String {
        dateFormatter.string(from: normalized(date))
    }

    private static func normalized(_ date: Date) -> Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: date)
    }

    // MARK: - Queries

    func countDaysOpened(inMonthOf referenceDate: Date) -> Int {
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.year, .month], from: referenceDate)
        return openedDateKeys.reduce(0) { partial, key in
            guard let date = Self.dateFormatter.date(from: key) else { return partial }
            let dc = cal.dateComponents([.year, .month], from: date)
            return (dc.year == comps.year && dc.month == comps.month) ? (partial + 1) : partial
        }
    }
}


