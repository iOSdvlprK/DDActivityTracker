//
//  ActivityView.swift
//  DDActivityTracker
//
//  Created by joe on 1/27/25.
//

import SwiftUI
import Charts
import SwiftData

struct ActivityView: View {
    @Query(sort: \Activity.name, order: .forward)
    var activities: [Activity]
    
    @Environment(\.modelContext) private var context
    
    @State private var newName: String = ""
    @State private var hoursPerDay: Double = 0.0
    @State private var currentActivity: Activity? = nil
    
    @State private var selectCount: Int?
    
    var totalHours: Double {
        var hours = 0.0
        for activity in activities {
            hours += activity.hoursPerDay
        }
        return hours
    }
    
    var remainingHours: Double {
        24 - totalHours
    }
    
    var maxHoursOfSelected: Double {
        remainingHours + hoursPerDay
    }
    
    let step = 1.0
    
    var body: some View {
        NavigationStack {
            VStack {
                if activities.isEmpty {
                    ContentUnavailableView("Enter an Activity", systemImage: "list.dash")
                } else {
                    Chart {
                        let isSelected: Bool = true
                        
                        ForEach(activities) { activity in
                            SectorMark(
                                angle: .value("Activities", activity.hoursPerDay),
                                innerRadius: .ratio(0.6),
                                outerRadius: isSelected ? 1.05 : 0.95,
                                angularInset: 1
                            )
                            .foregroundStyle(Color.red)
                            .cornerRadius(5)
                        }
                    }
                    .chartAngleSelection(value: $selectCount)
                }
                
                List {
                    ForEach(activities) { activity in
                        ActivityRow(activity: activity)
                            .contentShape(Rectangle())
                            .listRowBackground(
                                currentActivity?.name == activity.name ? Color.blue.opacity(0.3) : Color.clear
                            )
                            .onTapGesture {
                                withAnimation {
                                    currentActivity = activity
                                    hoursPerDay = activity.hoursPerDay
                                }
                            }
                    }
                    .onDelete(perform: deleteActivity)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                
                // text field
                TextField("Enter new activity", text: $newName)
                    .padding()
                    .background(Color.blue.gradient.opacity(0.3))
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                
                // slider
                if let currentActivity {
                    Slider(value: $hoursPerDay, in: 0...maxHoursOfSelected, step: step)
                        .onChange(of: hoursPerDay) { oldValue, newValue in
                            if let index = self.activities.firstIndex(where: {$0.name == currentActivity.name}) {
                                activities[index].hoursPerDay = newValue
                            }
                        }
                }
                
                Button("Add") {
                    addActivity()
                }
                .buttonStyle(.borderedProminent)
                .disabled(remainingHours <= 0)
            }
            .padding()
            .navigationTitle("Activity Tracker")
            .toolbar {
                EditButton()
                    .onChange(of: selectCount) { oldValue, newValue in
                        if let newValue {
                            withAnimation {
                                // change currentActivity based on newValue of selectCount
                                getSelected(value: newValue)
                            }
                        }
                    }
            }
        }
    }
    
    private func addActivity() {
        if newName.count > 2 && !activities.contains(where: { $0.name.lowercased() == newName.lowercased() }) {
            // go ahead and add activity
            let activity = Activity(name: newName, hoursPerDay: hoursPerDay)
            
            // add new activity
            context.insert(activity)
            
            // reset new name
            newName = ""
            
            currentActivity = activity
        }
    }
    
    private func deleteActivity(at offsets: IndexSet) {
        offsets.forEach { index in
            let activity = activities[index]
            context.delete(activity)
        }
    }
    
    private func getSelected(value: Int) {
        // TODO: getSelected
    }
}

#Preview {
    ActivityView()
        .modelContainer(for: Activity.self)
}
