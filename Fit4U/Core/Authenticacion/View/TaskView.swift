//
//  TaskView.swift
//  Fit4U
//
//  Created by Jack Grange Guerra on 2/12/23.
//

import SwiftUI

struct TaskView: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack with Pinned Header
            LazyVStack(spacing: 15, pinnedViews:  [.sectionHeaders]) {
                
                Section {
                    
                    // MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10){
                            
                            ForEach(taskModel.currentWeek,id: \.self){day in
                               
                                VStack(spacing: 10){
                                    
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    // EEE will return day as MON, TUE...
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                // MARK: Foreground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                //MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack{
                                      
                                        //MARK: Matched geometry Effect
                                        
                                        if taskModel.isToday(date: day){
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                               )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Update Current Day
                                    withAnimation{
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        
    }
    
    // MARK: Tasks View
    func TasksView()->some View{
        
        LazyVStack(spacing: 18){
           
            if let tasks = taskModel.filteredTasks{
                if tasks.isEmpty{
                    
                    Text("No tasks found!!!")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)

                } else {
                    
                    ForEach(tasks){task in
                        TaskCardView(task: task)
                    }
                }
            } else {
                // MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        // MARK: Updating Tasks
        .onChange(of: taskModel.currentDay) { newValue in
            taskModel.filteredTodayTasks()
        }
    }
    
    
    // MARK: Task Card View
    func TaskCardView(task: TaskNew)->some View{
        HStack(alignment: .top, spacing: 30){
            
            VStack(spacing: 10){
                
                Circle()
                    .fill(.black)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                        .stroke(.black, lineWidth: 1)
                        .padding(-3)
                    )
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack{
                
                HStack(alignment: .top, spacing: 10) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
            }
            //Cambiamos color de las letras
            //.foregroundColor(.white)
            .padding()
            .hLeading()
            .background(
                // Aqui cambio color de fondo de los boadillos
                Color(.green)
                    .cornerRadius(25)
            )
        }
        .hLeading()
    }
    
    // MARK: Header
    func HeaderView()->some View{
        HStack(spacing: 10){
            VStack(alignment: .leading, spacing: 10){
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button{
                
            } label: {
                Image("Fit4U")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
            }
        .padding()
        .padding(.top,getSafeArea().top)
        .background(Color.white)
        
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}

// Mark: UI Design Helper funcionts
extension View{
    func hLeading()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .leading)
    }
   
    func hTrailing()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .leading)
    }
   
    func hCenter()->some View{
        self
            .frame(maxWidth: .infinity,alignment: .leading)
    }
   
    // MARK: Safe Area
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
}
