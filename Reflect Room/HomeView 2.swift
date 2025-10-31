//
//  HomeView.swift
//  ReflectRoom
//
//  Created by Andrew Lawrence on 6/15/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Lavender-to-white background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 216/255, green: 190/255, blue: 255/255),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    // Greeting
                    Text("Hi Andrew,\nready to check in?")
                        .font(.system(size: 36, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)

                    // NavigationLink instead of Button
                    NavigationLink(destination: CheckInView()) {
                        Text("Start My Reflection")
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: 280)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(20)
                            .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)
                    }

                    // Add vertical spacing between button and mood icons
                    VStack {
                        Spacer().frame(height: 100)

                        HStack(spacing: 20) {
                            MoodIcon(label: "😊", description: "Happy")
                            MoodIcon(label: "😐", description: "Okay")
                            MoodIcon(label: "😢", description: "Sad")
                            MoodIcon(label: "😰", description: "Anxious")
                            MoodIcon(label: "😠", description: "Angry")
                        }
                    }

                    Spacer()

                    // Custom Tab Bar
                    CustomTabBar()
                }
                .padding()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .previewDisplayName("Light Mode")
                .preferredColorScheme(.light)

            HomeView()
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
        }
    }
}
