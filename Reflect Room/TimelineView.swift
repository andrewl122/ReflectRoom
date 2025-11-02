//
//  TimelineView.swift
//  Reflect Room
//
//  Created by Andrew Lawrence on 10/30/25.
//

import SwiftUI
import CoreData
import AVKit

struct TimelineView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var scheme

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ReflectionEntry.timestamp, ascending: false)],
        animation: .default
    )
    private var reflections: FetchedResults<ReflectionEntry>

    var body: some View {
        NavigationStack {
            ZStack {
                ReflectRoomBackground()

                if reflections.isEmpty {
                    VStack(spacing: AppTheme.Spacing.md) {
                        Text("No Reflections Yet")
                            .appHeadline()
                            .foregroundColor(AppTheme.Colors.textPrimary)

                        Text("Your recorded reflections will appear here once you’ve saved a few check-ins.")
                            .subtleLabel()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.md) {
                            ForEach(reflections) { entry in
                                NavigationLink(destination: ReflectionDetailView(entry: entry)) {
                                    HStack(spacing: AppTheme.Spacing.md) {
                                        Text(moodEmoji(for: entry.mood ?? ""))
                                            .font(.largeTitle)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(entry.mood ?? "Unknown Mood")
                                                .appHeadline()
                                            Text(entry.timestamp ?? Date(), style: .date)
                                                .subtleLabel()
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.footnote)
                                            .foregroundColor(AppTheme.Colors.textSecondary)
                                    }
                                    .padding()
                                    .cardBackground(scheme)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Reflections")
            .navigationBarTitleDisplayMode(.large)
        }
        .background(ReflectRoomBackground())
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Helpers
    private func moodEmoji(for mood: String) -> String {
        switch mood.lowercased() {
        case "happy": return "😊"
        case "sad": return "😢"
        case "okay": return "😐"
        case "angry": return "😠"
        case "anxious": return "😰"
        default: return "🪞"
        }
    }

    private func deleteSelected() {
        // No swipe-to-delete in ScrollView, but if you add one later, this keeps it safe.
        // Example placeholder for keyboard delete command on macOS Catalyst.
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let entry = reflections[index]
            viewContext.delete(entry)
        }
        try? viewContext.save()
        Haptics.tap()
    }
}

#Preview {
    TimelineView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
