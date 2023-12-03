//
//  MainMenuView.swift
//  Fit4U
//
//  Created by Jack Grange Guerra on 16/11/23.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        home()
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}

struct home : View {
    
    @State var selected = 0
    var colors = [Color("Color1"),Color("Color")]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack{
                
                HStack {
                    
                    Text("Hello Pepe")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        
                        Image("menu")
                            .renderingMode(.original)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Bar Chart
                
                VStack(alignment: .leading, spacing: 25) {
                    Text("Daily Workouts in hrs")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        ForEach(workout_Data) {work in
                            
                            // Bars
                            VStack{
                                
                                VStack{
                                    
                                    Spacer(minLength: 0)
                                    
                                    if selected == work.id{
                                        
                                        Text(getHrs(value: work.workout_In_Min))
                                            .foregroundColor(Color("Color"))
                                            .padding(.bottom,5)
                                        
                                    }
                                    
                                    RoundedShape()
                                        .fill(LinearGradient(gradient: .init(colors: selected == work.id ? colors : [Color.white.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                    
                                    // Max height = 200
                                        .frame(height: getHeight(value: work.workout_In_Min))
                                }
                                .frame(height: 220)
                                .onTapGesture{
                                    
                                    withAnimation(.easeOut){
                                        selected = work.id
                                    }
                                    
                                }
                                
                                
                                Text(work.day)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(10)
                .padding()
                
                HStack {
                    
                    Text("Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    /*
                    Button(action: {}) {
                        
                        Image("menu")
                            .renderingMode(.original)
                            .foregroundColor(.white)
                    }
                     */
                }
                .padding()
                
                // Stats Grid
                
                LazyVGrid(columns: columns,spacing: 30){
                    
                    ForEach(stats_Data){stat in
                        
                        VStack(spacing: 32) {
                            
                            HStack{
                                
                                Text(stat.title)
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer(minLength: 0)
                            }
                            
                            // Ring
                            
                            ZStack{
                                
                                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Circle()
                                    .trim(from: 0, to: (stat.currentData / stat.goal))
                                    .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Text(getPercent(current: stat.currentData, Goal: stat.goal) + " %")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(stat.color)
                                    .rotationEffect(.init(degrees: 90))
                            }
                            .rotationEffect(.init(degrees: -90))
                            
                            Text(getDec(val: stat.currentData) + " " + getType(val: stat.title))
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(15)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                    }
                }
                .padding()
                
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
    }
    
    // Calculating Type
    
    func getType(val:  String)->String{
        
        switch val{
        case "Water": return "L"
        case "Sleep": return "Hrs"
        case "Running": return "Km"
        case "Cycling": return "Km"
        case "Steps": return "Stp"
        case "Swimming": return "Brz"
        default: return "Kcal"
        }
    }
    
    func getDec(val: CGFloat)->String{
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        return format.string(from: NSNumber.init(value: Float(val)))!
    }
    
    // Calculation %
    
    func getPercent(current : CGFloat,Goal : CGFloat)->String{
        
        let per = (current / Goal) * 100
        
        return String(format:"%.1f", per)
    }
    
    func getHeight(value : CGFloat)->CGFloat{
        
        // Value in minutes
        
        // Getting height
        
        // 24 hrs in  in = 1440
        let hrs = CGFloat(value / 1440) * 200
        
        return hrs
    }
    
    // Getting hrs
    
    func getHrs(value: CGFloat)->String{
        
        let hrs = value / 60
        return String(format: "%.1f", hrs)
    }
}

struct RoundedShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}

// Sample Data

struct Daily : Identifiable {
    var id : Int
    var day : String
    var workout_In_Min : CGFloat
}

var workout_Data = [
    Daily(id: 0, day: "Day 1", workout_In_Min: 480),
    Daily(id: 1, day: "Day 2", workout_In_Min: 880),
    Daily(id: 2, day: "Day 3", workout_In_Min: 250),
    Daily(id: 3, day: "Day 4", workout_In_Min: 360),
    Daily(id: 4, day: "Day 5", workout_In_Min: 1220),
    Daily(id: 5, day: "Day 6", workout_In_Min: 750),
    Daily(id: 6, day: "Day 7", workout_In_Min: 950)
]

// Stats Data

struct Stats : Identifiable {
    
    var id : Int
    var title : String
    var currentData : CGFloat
    var goal : CGFloat
    var color : Color
}

var stats_Data = [
    Stats(id: 0, title: "Running", currentData: 6.8, goal: 15, color: Color("Running")),
    Stats(id: 1, title: "Water", currentData: 3.5, goal: 5, color: Color("Water")),
    Stats(id: 2, title: "Energy Burn", currentData: 585, goal: 1000, color: Color("Energy Burn")),
    Stats(id: 3, title: "Sleep", currentData: 6.2, goal: 10, color: Color("Sleep")),
    Stats(id: 4, title: "Cycling", currentData: 12.5, goal: 25, color: Color("Cycling")),
    Stats(id: 5, title: "Steps", currentData: 16889, goal: 20000, color: Color("Steps")),
    Stats(id: 6, title: "Swimming", currentData: 12000, goal: 12121, color: Color("Swimming"))
    
]
