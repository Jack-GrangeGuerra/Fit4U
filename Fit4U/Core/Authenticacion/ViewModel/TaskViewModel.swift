//
//  TaskViewModel.swift
//  Fit4U
//
//  Created by Jack Grange Guerra on 2/12/23.
//

import Foundation
import SwiftUI

 class TaskViewModel: ObservableObject{
 // Sample TaskNerw
 @Published var storedTasks: [TaskNew] = [
 
 TaskNew(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701556131)),
 TaskNew(taskTitle: "Icon set", taskDescription: "Edit ", taskDate: .init(timeIntervalSince1970: 1701556131)),
 TaskNew(taskTitle: "Prototype", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701556131)),
 
 TaskNew(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701621765)),
 TaskNew(taskTitle: "Icon set", taskDescription: "Edit ", taskDate: .init(timeIntervalSince1970: 1701621765)),
 TaskNew(taskTitle: "Prototype", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701621765)),
 TaskNew(taskTitle: "Check asset", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701621765)),
 TaskNew(taskTitle: "Team Party", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701621765)),
 TaskNew(taskTitle: "Client Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701621765)),
 TaskNew(taskTitle: "Next Project", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701621765)),
 TaskNew(taskTitle: "Team Proposal", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1701621765))

  ]
     
     // MARK: Current Week Days
     
     @Published var currentWeek: [Date] = []
     
     // MARK: Current Day
     
     @Published var currentDay: Date = Date()
     
     // MARK: Filtering Today Task
     
     @Published var filteredTasks: [TaskNew]?
     
     // MARK: Initializing
     init(){
         fetchCurrentWeek()
         filteredTodayTasks()
     }
     
// MARK: Filtered Today Tasks
     func filteredTodayTasks(){
         
         DispatchQueue.global(qos: .userInteractive).async {
             
             let calendar = Calendar.current
             
             let filtered = self.storedTasks.filter{
                 return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
             }
             
             DispatchQueue.main.async {
                 withAnimation{
                     self.filteredTasks = filtered
                 }
             }
         }
     }
     
     func fetchCurrentWeek(){
         let today = Date()
         let calendar = Calendar.current
         
         let week = calendar.dateInterval(of: .weekOfMonth, for: today)
         guard let firstWeekDay = week?.start else{
             return
         }
         
         (0...7).forEach { day in
             if let weekday = calendar.date(byAdding: .day, value: day,to: firstWeekDay){
                 currentWeek.append(weekday)
             }
             
         }
     }
     
     func extractDate(date: Date, format: String)->String{
         let formatter = DateFormatter()
         
         formatter.dateFormat = format
         
         return formatter.string(from: date)
     }
     
     // MARK: Cheking if current Date is Today

     func isToday(date: Date)->Bool{
         
         let calendar = Calendar.current
         
         return calendar.isDate(currentDay, inSameDayAs: date)
     }
     

  }
