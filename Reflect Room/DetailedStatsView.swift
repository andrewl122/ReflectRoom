//
//  DetailedStatsView.swift
//  Reflect Room
//
//  Created by Andrew Lawrence on 11/02/25.
//

import SwiftUI
import CoreData

struct DetailedStatsView: View {
    var reflections: [ReflectionEntry]
    @Environment(\.colorScheme) private var scheme
    @State private var showInfo = false
    @State private var selectedRange: TimeRange = .month // ✅ same range toggle as MoodInsightsView

    // MARK: - Computed Properties
    private var avgMood: Double {
        let scores = reflections.map { ReflectionEntry.moodScore(for: $0.mood ?? "") }
        return scores.isEmpty ? 0 : scores.reduce(0, +) / Double(scores.count)
    }

    private var recentAvgMood: Double {
        let last7 = reflections.filter {
            guard let date = $0.timestamp else { return false }
            return date >= Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        }
        let scores = last7.map { ReflectionEntry.moodScore(for: $0.mood ?? "") }
        return scores.isEmpty ? 0 : scores.reduce(0, +) / Double(scores.count)
    }

    private var reflectionCount: Int { reflections.count }

    private var dominantMood: String {
        reflections.map { $0.mood ?? "" }.mostFrequent() ?? "None"
    }

    private var currentStreak: Int {
        ReflectionEntry.currentStreak(from: reflections)
    }

    private var longestStreak: Int {
        ReflectionEntry.longestStreak(from: reflections)
    }

    private var reflectionFrequency: Double {
        guard let first = reflections.compactMap({ $0.timestamp }).min() else { return 0 }
        let daysActive = max(1, Calendar.current.dateComponents([.day], from: first, to: Date()).day ?? 1)
        let weeklyRate = Double(reflectionCount) / Double(daysActive / 7)
        return min(weeklyRate, 7)
    }

    // MARK: - View Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Mood Icon + Title
                    VStack(spacing: 6) {
                        Text(emojiForMood(dominantMood))
                            .font(.system(size: 56))
                            .shadow(radius: 4)
                        Text("Your Reflection Stats")
                            .font(.title2.bold())
                            .foregroundColor(AppTheme.Colors.textPrimary)
                    }
                    .padding(.top, 8)

                    // MARK: - Range Selector
                    HStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Button {
                                Haptics.tap()
                                withAnimation(.easeInOut) { selectedRange = range }
                            } label: {
                                Text(range.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(selectedRange == range ? .bold : .regular)
                                    .foregroundColor(selectedRange == range ? .white : AppTheme.Colors.textPrimary)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(
                                        Capsule().fill(selectedRange == range
                                                       ? AppTheme.Colors.accent
                                                       : AppTheme.Colors.cardBg(scheme))
                                    )
                            }
                        }
                    }

                    // MARK: - Key Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        statCard(title: "Average Mood", value: String(format: "%.1f / 5", avgMood))
                        statCard(title: "Last 7 Days", value: String(format: "%.1f / 5", recentAvgMood))
                        statCard(title: "Reflections", value: "\(reflectionCount)")
                        statCard(title: "Dominant Mood", value: "\(emojiForMood(dominantMood)) \(dominantMood)")
                        statCard(title: "Current Streak", value: "\(currentStreak) days")
                        statCard(title: "Longest Streak", value: "\(longestStreak) days")
                    }

                    // MARK: - Data Coverage Indicator (Dynamic)
                    let count = reflectionCount(for: selectedRange)
                    if count > 0 {
                        Text("Based on \(count) reflection\(count == 1 ? "" : "s") this \(selectedRange.labelDescription.lowercased())")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .animation(.easeInOut, value: selectedRange)
                    } else {
                        Text("No reflections recorded this \(selectedRange.labelDescription.lowercased())")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .animation(.easeInOut, value: selectedRange)
                    }

                    // MARK: - Mood Average Info Card
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Text("How Averages Are Calculated")
                                .appHeadline()
                            Button {
                                Haptics.tap()
                                showInfo = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .alert("Mood Score Scale", isPresented: $showInfo) {
                                Button("Got it", role: .cancel) { }
                            } message: {
                                Text("""
                                Each mood is converted into a 1–5 numeric value:

                                😊 Happy = 5  
                                😐 Okay = 4  
                                😢 Sad = 3  
                                😰 Anxious = 2  
                                😠 Angry = 1

                                Your averages represent the mean of these scores based on your recorded reflections.
                                """)
                            }
                        }

                        Text("Your mood averages are calculated using a 1–5 scale (Angry–Happy).")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                            .fill(AppTheme.Colors.cardBg(scheme))
                            .shadow(color: .black.opacity(scheme == .dark ? 0.4 : 0.08),
                                    radius: 4, x: 0, y: 3)
                    )

                    // MARK: - Reflection Frequency Progress Ring
                    VStack(spacing: 10) {
                        Text("Reflection Frequency")
                            .appHeadline()
                            .foregroundColor(AppTheme.Colors.accent)

                        ZStack {
                            Circle()
                                .stroke(lineWidth: 12)
                                .opacity(0.15)
                                .foregroundColor(.gray)

                            Circle()
                                .trim(from: 0.0, to: reflectionFrequency / 7.0)
                                .stroke(
                                    AngularGradient(
                                        gradient: Gradient(colors: [AppTheme.Colors.accent, .green]),
                                        center: .center
                                    ),
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .animation(.easeOut(duration: 0.8), value: reflectionFrequency)

                            VStack(spacing: 2) {
                                Text(String(format: "%.1f", reflectionFrequency))
                                    .font(.title.bold())
                                Text("per week")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(width: 160, height: 160)
                    }
                    .padding(.top, 16)

                    Spacer(minLength: 30)
                }
                .padding()
            }
            .navigationTitle("Detailed Stats")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Helper: Count by Range
    private func reflectionCount(for range: TimeRange) -> Int {
        let (start, end) = dateRange(for: range)
        return reflections.filter {
            if let d = $0.timestamp { return d >= start && d <= end }
            return false
        }.count
    }

    private func dateRange(for range: TimeRange) -> (start: Date, end: Date) {
        let now = Date()
        switch range {
        case .day:       return (Calendar.current.date(byAdding: .day, value: -1, to: now)!, now)
        case .week:      return (Calendar.current.date(byAdding: .day, value: -7, to: now)!, now)
        case .month:     return (Calendar.current.date(byAdding: .month, value: -1, to: now)!, now)
        case .sixMonths: return (Calendar.current.date(byAdding: .month, value: -6, to: now)!, now)
        case .year:      return (Calendar.current.date(byAdding: .year, value: -1, to: now)!, now)
        }
    }

    // MARK: - Reusable Stat Card
    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3.bold())
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                .fill(AppTheme.Colors.cardBg(scheme))
                .shadow(color: .black.opacity(scheme == .dark ? 0.4 : 0.08),
                        radius: 4, x: 0, y: 3)
        )
    }

    // MARK: - Mood Emoji Helper (Unified)
    private func emojiForMood(_ mood: String) -> String {
        switch mood.lowercased() {
        case "happy": return "😊"
        case "okay": return "😐"
        case "sad": return "😢"
        case "anxious": return "😰"
        case "angry": return "😠"
        case "none", "": return "🪞"
        default: return "🪞"
        }
    }
}



// MARK: - Helper Extension
fileprivate extension Array where Element == String {
    func mostFrequent() -> String? {
        guard !isEmpty else { return nil }
        let counts = Dictionary(grouping: self, by: { $0 }).mapValues { $0.count }
        return counts.max(by: { $0.value < $1.value })?.key
    }
}
