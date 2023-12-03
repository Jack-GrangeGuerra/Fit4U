//
//  Fit4UApp.swift
//  Fit4U
//
//  Created by Jack Grange Guerra on 7/11/23.
//

import SwiftUI
import Firebase

@main
struct Fit4UApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TaskView()
                .environmentObject(viewModel)
        }
    }
}
