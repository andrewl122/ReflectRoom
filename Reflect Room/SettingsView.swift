//
//  SettingsView.swift
//  Reflect Room
//
//  Created by Andrew Lawrence on 11/2/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            ReflectRoomBackground()

            VStack(spacing: AppTheme.Spacing.lg) {
                // MARK: - Header
                Text("Settings")
                    .appTitle()
                    .padding(.top, 20)

                Text("Customize your reflection experience.")
                    .subtleLabel()

                // MARK: - Settings List
                VStack(spacing: AppTheme.Spacing.sm) {
                    settingsRow(icon: "lock.fill", title: "App Lock", subtitle: "Enable Face ID or Passcode")
                    settingsRow(icon: "icloud.fill", title: "iCloud Sync", subtitle: "Backup reflections automatically")
                    settingsRow(icon: "person.crop.circle.badge.checkmark", title: "Privacy Mode", subtitle: "Keep entries private")
                    settingsRow(icon: "paintbrush.fill", title: "Theme", subtitle: "Light / Dark / System")
                }
                .padding(.vertical, AppTheme.Spacing.md)
                .cardBackground(scheme)

                Spacer()

                // MARK: - Footer
                VStack(spacing: 4) {
                    Text("Reflect Room v1.0")
                        .font(.footnote)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    Text("Created with purpose and reflection.")
                        .font(.caption2)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Settings Row
    private func settingsRow(icon: String, title: String, subtitle: String) -> some View {
        Button {
            Haptics.tap()
        } label: {
            HStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.accentSoft)
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.Colors.accent)
                        .font(.system(size: 18, weight: .medium))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .appHeadline()
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.6))
                    .font(.system(size: 14))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.light)
}
