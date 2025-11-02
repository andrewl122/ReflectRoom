//
//  CustomTabBar.swift
//  Reflect Room
//
//  Created by Andrew Lawrence on 10/30/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "house"
    case timeline = "calendar"
    case settings = "gear"
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            // MARK: - Glass Background
            VisualEffectView(
                effect: UIBlurEffect(
                    style: scheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight
                )
            )
            .ignoresSafeArea(edges: .bottom)
            .overlay(
                Rectangle()
                    .fill(AppTheme.Colors.accent.opacity(0.08))
                    .frame(height: 0.5)
                    .edgesIgnoringSafeArea(.horizontal),
                alignment: .top
            )

            // MARK: - Tab Buttons
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Spacer()

                    Button {
                        Haptics.tap()
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                if selectedTab == tab {
                                    Circle()
                                        .fill(AppTheme.Colors.accent.opacity(0.18))
                                        .frame(width: 44, height: 44)
                                        .blur(radius: 4)
                                        .transition(.scale)
                                }
                                Image(systemName: tab.rawValue)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(selectedTab == tab
                                                     ? AppTheme.Colors.accent
                                                     : AppTheme.Colors.textSecondary.opacity(0.7))
                                    .scaleEffect(selectedTab == tab ? 1.15 : 1.0)
                            }

                            Text(label(for: tab))
                                .font(.caption2)
                                .foregroundColor(selectedTab == tab
                                                 ? AppTheme.Colors.accent
                                                 : AppTheme.Colors.textSecondary.opacity(0.7))
                        }
                        .padding(.vertical, AppTheme.Spacing.xs)
                    }

                    Spacer()
                }
            }
            .padding(.bottom, 8)
            .background(Color.clear)
        }
        .frame(height: 75)
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Label Helper
    private func label(for tab: Tab) -> String {
        switch tab {
        case .home: return "Home"
        case .timeline: return "Reflections"
        case .settings: return "Settings"
        }
    }
}

// MARK: - UIKit Blur Bridge
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

#Preview {
    ZStack {
        Color(.systemBackground).ignoresSafeArea()
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.home))
        }
    }
}
