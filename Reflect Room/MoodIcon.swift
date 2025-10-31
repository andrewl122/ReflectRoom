//
//  MoodIcon.swift
//  ReflectRoom
//
//  Created by Andrew Lawrence on 6/15/25.
//
import SwiftUI

struct MoodIcon: View {
    var label: String
    var description: String

    var body: some View {
        VStack {
            Text(label)
                .font(.system(size: 40))
            Text(description)
                .font(.caption)
        }
    }
}
struct MoodIcon_Previews: PreviewProvider {
    static var previews: some View {
        MoodIcon(label: "😊", description: "Happy")
    }
}
