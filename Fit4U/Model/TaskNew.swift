//
//  Task.swift
//  Fit4U
//
//  Created by Jack Grange Guerra on 2/12/23.
//

import Foundation

// Task Model

struct TaskNew: Identifiable{
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
    
}
