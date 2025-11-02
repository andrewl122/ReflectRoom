//
//  HomeView.swift
//  Reflect Room
//
//  Created by Andrew Lawrence on 10/30/25.
//

import SwiftUI
import Charts
import CoreData

// MARK: - MoodStat Model
struct MoodStat: Identifiable, Equatable {
    var id = UUID()
    var mood: String
    var count: Int
    var emoji: String

    static func == (lhs: MoodStat, rhs: MoodStat) -> Bool {
        lhs.id == rhs.id &&
        lhs.mood == rhs.mood &&
        lhs.count == rhs.count &&
        lhs.emoji == rhs.emoji
    }
}

// MARK: - HomeView
struct HomeView: View {
    @State private var selectedMood: String? = nil
    @State private var navigateToCheckIn = false
    @State private var selectedTab: Tab = .home
    @State private var showInsightsView = false
    @State private var isTabBarHidden = false
    @Environment(\.colorScheme) var scheme

    // MARK: - Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ReflectionEntry.timestamp, ascending: false)],
        animation: .default
    )
    private var reflections: FetchedResults<ReflectionEntry>

    // MARK: - Mood Data
    private var moodData: [MoodStat] {
        let moods = ["Happy", "Okay", "Sad", "Anxious", "Angry"]
        let emojis = ["😊", "😐", "😢", "😰", "😠"]
        var stats: [MoodStat] = []

        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        let recent = reflections.filter {
            if let t = $0.timestamp { return t >= startDate }
            return false
        }

        for (i, mood) in moods.enumerated() {
            let count = recent.filter { $0.mood == mood }.count
            if count > 0 {
                stats.append(MoodStat(mood: mood, count: count, emoji: emojis[i]))
            }
        }
        return stats
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if selectedTab == .home {
                NavigationView {
                    ZStack {
                        ReflectRoomBackground()

                        VStack(spacing: AppTheme.Spacing.lg) {
                            Spacer(minLength: 20)
                            greetingSection
                            moodButtonRow

                            NavigationLink(
                                destination: CheckInView(isTabBarHidden: $isTabBarHidden, selectedMood: selectedMood ?? "Unknown"),
                                isActive: $navigateToCheckIn
                            ) { EmptyView() }

                            moodOverviewSection
                            Spacer(minLength: 40)
                        }
                        .padding()
                    }
                }
            } else if selectedTab == .timeline {
                TimelineView()
            } else if selectedTab == .settings {
                SettingsView()
            }

            if !isTabBarHidden {
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }

    // MARK: - Greeting
    private var greetingSection: some View {
        Text("Hi Andrew,\nTap your mood to begin.")
            .appHeadline()
            .multilineTextAlignment(.center)
            .foregroundColor(AppTheme.Colors.textPrimary)
            .padding(.horizontal)
    }

    // MARK: - Mood Buttons
    private var moodButtonRow: some View {
        HStack(spacing: 20) {
            moodButton("😊", mood: "Happy")
            moodButton("😐", mood: "Okay")
            moodButton("😢", mood: "Sad")
            moodButton("😰", mood: "Anxious")
            moodButton("😠", mood: "Angry")
        }
        .padding(.bottom, AppTheme.Spacing.sm)
    }

    // MARK: - Mood Overview
    private var moodOverviewSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Text("Your Mood Overview")
                .appHeadline()
                .foregroundColor(AppTheme.Colors.accent)

            if moodData.isEmpty {
                Text("No reflections yet. Start your first check-in today!")
                    .subtleLabel()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Button {
                    Haptics.tap()
                    showInsightsView = true
                } label: {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: scheme == .dark
                                ? [AppTheme.Colors.accent.opacity(0.25),
                                   Color.black.opacity(0.4)]
                                : [AppTheme.Colors.accent.opacity(0.15),
                                   Color.blue.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(AppTheme.Radii.lg)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                        VStack(spacing: AppTheme.Spacing.md) {
                            Chart {
                                ForEach(moodData) { stat in
                                    BarMark(
                                        x: .value("Mood", stat.emoji),
                                        y: .value("Count", stat.count)
                                    )
                                    .foregroundStyle(colorForMood(stat.mood))
                                    .cornerRadius(6)
                                    .annotation {
                                        Text("\(stat.count)")
                                            .font(.caption)
                                            .foregroundColor(AppTheme.Colors.textSecondary)
                                    }
                                }
                            }
                            .frame(height: 180)
                            .padding(.horizontal)
                            .chartLegend(.hidden)
                            .chartYAxis(.hidden)
                            .animation(.easeInOut(duration: 0.4), value: moodData)

                            HStack(spacing: 14) {
                                ForEach(moodData, id: \.mood) { stat in
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(colorForMood(stat.mood))
                                            .frame(width: 10, height: 10)
                                        Text(stat.mood)
                                            .font(.caption)
                                            .foregroundColor(AppTheme.Colors.textPrimary)
                                    }
                                }
                            }
                            .padding(.bottom, 6)
                            .padding(.top, 4)
                        }
                        .padding(.vertical, AppTheme.Spacing.md)
                    }
                    .padding(.horizontal)
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showInsightsView) {
                    MoodInsightsView(reflections: reflections)
                }
            }
        }
        .padding(.top)
    }

    // MARK: - Mood Button Template
    private func moodButton(_ emoji: String, mood: String) -> some View {
        Button {
            selectedMood = mood
            navigateToCheckIn = true
            Haptics.tap()
        } label: {
            VStack(spacing: 4) {
                Text(emoji)
                    .font(.system(size: 44))
                Text(mood)
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .allowsTightening(true)
            }
            .padding(AppTheme.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                    .fill(Color.white.opacity(scheme == .dark ? 0.05 : 0.2))
                    .shadow(radius: 1)
            )
        }
    }

    // MARK: - Mood Color Mapping
    private func colorForMood(_ mood: String) -> Color {
        switch mood.lowercased() {
        case "happy": return .yellow
        case "okay": return .gray
        case "sad": return .blue
        case "anxious": return .orange
        case "angry": return .red
        default: return AppTheme.Colors.accent
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

