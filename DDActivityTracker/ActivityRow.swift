//
//  ActivityRow.swift
//  DDActivityTracker
//
//  Created by joe on 2/1/25.
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(.headline)
                Text("Hours per day: \(activity.hoursPerDay.formatted())")
            }
            Spacer()
        }
    }
}

#Preview {
    ActivityRow(activity: .init(name: "Eat Pizza", hoursPerDay: 1))
        .padding()
}
