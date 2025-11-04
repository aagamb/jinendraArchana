//
//  StreakView.swift
//  Jinendra Archana
//
//  Created by Aagam Bakliwal on 11/07/25.
//

import SwiftUI

struct StreakView: View {
    @ObservedObject private var tracker = AppOpenTracker.shared
    @State private var today: Date = Date()
    @State private var displayedMonth: Date = Date()
    private let calendar = Calendar(identifier: .gregorian)

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)
                    Text("Streak")
                        .font(.title2).bold()
                        .foregroundStyle(.primary)
                }

                // Total metrics
                HStack(spacing: 12) {
                    VStack(alignment: .center, spacing: 4) {
                        Text("Total Days Opened")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Text("\(tracker.totalDaysOpened)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    VStack(alignment: .center, spacing: 4) {
                        Text("Opened This Month")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Text("\(tracker.countDaysOpened(inMonthOf: displayedMonth))")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.secondary.opacity(0.15), lineWidth: 0.5)
                )

                // Calendar of the current month
                CalendarMonthView(
                    monthDate: displayedMonth,
                    onPrev: { displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth },
                    onNext: { displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth },
                    isOpened: { date in
                    tracker.isOpened(on: date)
                })
            }
            .padding(16)
        }
        .background(.background)
        .onAppear {
            // Keep today in sync when the view appears
            today = Date()
            displayedMonth = calendar.startOfDay(for: today)
        }
    }
}

private struct CalendarMonthView: View {
    let monthDate: Date
    let onPrev: () -> Void
    let onNext: () -> Void
    let isOpened: (Date) -> Bool

    private let calendar = Calendar(identifier: .gregorian)
    private let weekDaySymbols = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Month Title + navigation
            HStack {
                Button {
                    onPrev()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                Spacer()
                Text(monthTitle)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    onNext()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(.ultraThinMaterial))
                }
            }

            // Weekday headers (use indices for unique IDs to avoid duplicates like "S" and "T")
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
                ForEach(Array(weekDaySymbols.enumerated()), id: \.offset) { item in
                    let symbol = item.element
                    Text(symbol)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Days grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
                // leading blanks with unique IDs so they don't collide with day cells
                ForEach(0..<leadingEmptyCount, id: \.self) { index in
                    Color.clear
                        .frame(height: 36)
                        .id("placeholder-\(index)")
                }

                ForEach(1...numberOfDays, id: \.self) { day in
                    let date = dateForDay(day)
                    VStack(spacing: 4) {
                        Text("\(day)")
                            .font(.subheadline)
                            .foregroundStyle(isToday(date) ? .orange : .primary)
                        Circle()
                            .fill(isOpened(date) ? Color.green : Color.clear)
                            .frame(width: 6, height: 6)
                    }
                    .frame(height: 36)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        ZStack {
                            if isToday(date) {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.orange.opacity(0.12))
                            }
                        }
                    )
                    .id("day-\(day)")
                }
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.secondary.opacity(0.15), lineWidth: 0.5)
            )
        }
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale.current
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: startOfMonth)
    }

    private var startOfMonth: Date {
        let comps = calendar.dateComponents([.year, .month], from: monthDate)
        return calendar.date(from: comps) ?? monthDate
    }

    private var numberOfDays: Int {
        calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 30
    }

    private var leadingEmptyCount: Int {
        // Convert weekday (1...7, Sunday = 1) to leading blanks count
        let weekday = calendar.component(.weekday, from: startOfMonth)
        return (weekday - 1)
    }

    private func dateForDay(_ day: Int) -> Date {
        calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) ?? startOfMonth
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
}

#Preview {
    StreakView()
}


