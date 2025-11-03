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
                    List {
                        ForEach(reflections) { entry in
                            ReflectionCard(entry: entry, scheme: scheme)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Reflections")
            .navigationBarTitleDisplayMode(.large)
        }
        .background(ReflectRoomBackground())
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Delete Logic
    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            offsets.map { reflections[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                Haptics.tap()
            } catch {
                print("❌ Failed to delete reflection: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Reflection Card (no double arrows)
private struct ReflectionCard: View {
    let entry: ReflectionEntry
    let scheme: ColorScheme

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Text(moodEmoji(for: entry.mood ?? ""))
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.mood ?? "Unknown Mood")
                    .appHeadline()
                Text(entry.timestamp ?? Date(), style: .date)
                    .subtleLabel()
            }

            Spacer() // Removed chevron to avoid double arrows
        }
        .padding()
        .background(AppTheme.Colors.cardBg(scheme))
        .cornerRadius(AppTheme.Radii.lg)
        .shadow(color: .black.opacity(scheme == .dark ? 0.4 : 0.08), radius: 4, x: 0, y: 3)
    }

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
}

#Preview {
    TimelineView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
