//
//  WeatherIcons.swift
//  IOSWeather
//
//  Created by Steven McSorley on 29/11/2023.
//

import Foundation
import SwiftUI

struct SunIcon: View {
    var body: some View {
        // Sun icon path
        Circle()
            .fill(Color.cyan)
            .frame(width: 40, height: 40)
    }
}

struct CloudIcon: View {
    var body: some View {
        // Cloud icon path
        Path { path in
            path.move(to: CGPoint(x: 10, y: 20))
            path.addCurve(to: CGPoint(x: 30, y: 20), control1: CGPoint(x: 15, y: 10), control2: CGPoint(x: 25, y: 10))
            path.addCurve(to: CGPoint(x: 50, y: 20), control1: CGPoint(x: 35, y: 10), control2: CGPoint(x: 45, y: 10))
            path.addCurve(to: CGPoint(x: 70, y: 20), control1: CGPoint(x: 55, y: 10), control2: CGPoint(x: 65, y: 10))
        }
        .fill(Color.cyan)
        .frame(width: 80, height: 40)
    }
}

struct RainIcon: View {
    var body: some View {
        // Rain icon path
        Group {
            ForEach(0..<3) { row in
                HStack(spacing: 2) { // Adjust the spacing here
                    ForEach(0..<4) { _ in
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 0, y: 6)) // Adjust the height here
                        }
                        .stroke(Color.cyan, lineWidth: 2)
                        .frame(width: 10, height: 6) // Adjust the height here
                        .rotationEffect(.degrees(Double.random(in: -10...10))) // Add rotation
                    }
                }
            }
        }
        .frame(width: 60, height: 40) // Adjust the height here
    }
}






struct SnowIcon: View {
    var body: some View {
        // Snow icon path
        Group {
            Path { path in
                path.move(to: CGPoint(x: 20, y: 0))
                path.addLine(to: CGPoint(x: 20, y: 20))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 40, y: 0))
                path.addLine(to: CGPoint(x: 40, y: 20))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 60, y: 0))
                path.addLine(to: CGPoint(x: 60, y: 20))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 30, y: 10))
                path.addLine(to: CGPoint(x: 50, y: 10))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 45, y: 5))
                path.addLine(to: CGPoint(x: 45, y: 15))
            }.stroke(Color.cyan, lineWidth: 2)
        }
        
        .frame(width: 80, height: 40)
    }
}

struct StormIcon: View {
    var body: some View {
        // Storm icon path
        Group {
            Path { path in
                path.move(to: CGPoint(x: 10, y: 10))
                path.addLine(to: CGPoint(x: 20, y: 20))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 20, y: 10))
                path.addLine(to: CGPoint(x: 10, y: 20))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 30, y: 10))
                path.addLine(to: CGPoint(x: 40, y: 20))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 40, y: 10))
                path.addLine(to: CGPoint(x: 30, y: 20))
            }.stroke(Color.cyan, lineWidth: 2)
        }
        .frame(width: 80, height: 40)
    }
}

struct WindIcon: View {
    var body: some View {
        // Wind icon path
        Group {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 15))
                path.addLine(to: CGPoint(x: 80, y: 15))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 20, y: 5))
                path.addLine(to: CGPoint(x: 0, y: 15))
                path.addLine(to: CGPoint(x: 20, y: 25))
            }.stroke(Color.cyan, lineWidth: 2)
            Path { path in
                path.move(to: CGPoint(x: 60, y: 5))
                path.addLine(to: CGPoint(x: 80, y: 15))
                path.addLine(to: CGPoint(x: 60, y: 25))
            }.stroke(Color.cyan, lineWidth: 2)
        }
        .frame(width: 80, height: 40)
    }
}



struct WeatherIcons {
    
    
    static var test: some View {
        // Icon for "Warmer, and rain within 36 hours."
        ZStack {
            CloudIcon()
        }
    }
    static var warmerRain: some View {
        // Icon for "Warmer, and rain within 36 hours."
        ZStack {
            SunIcon()
            RainIcon()
        }
    }
    
    static var noChange: some View {
        // Icon for "No early change."
        SunIcon()
    }
    
    static var rainWithin18Hours: some View {
        // Icon for "Rain within 18 hours that will continue a day or two."
        RainIcon()
    }
    
    static var warmerRain24Hours: some View {
        // Icon for "Warmer, and rain within 24 hours."
        ZStack {
            SunIcon()
            RainIcon()
        }
    }
    
    static var fairWarmerRain: some View {
        // Icon for "Fair followed within two days by warmer and rain."
        ZStack {
            SunIcon()
            CloudIcon()
            RainIcon()
        }
    }
    
    static var fairSlightChanges: some View {
        // Icon for "Fair, with slight changes in temperature, for one to two days."
        ZStack {
            SunIcon()
            CloudIcon()
        }
    }
    
    static var rainHighWind: some View {
        // Icon for "Rain, with high wind, followed within two days by clearing, colder."
        ZStack {
            CloudIcon()
            RainIcon()
            WindIcon()
        }
    }
    
    static var clearingColder12Hours: some View {
        // Icon for "Clearing and colder within 12 hours."
        ZStack {
            CloudIcon()
            SunIcon()
        }
    }
    
    static var fairWarmer: some View {
        // Icon for "Fair and warmer."
        ZStack {
            SunIcon()
            CloudIcon()
        }
    }
    
    static var foulWeather: some View {
        // Icon for "Foul weather: rain, snow, and storms."
        ZStack {
            CloudIcon()
            RainIcon()
            SnowIcon()
            StormIcon()
        }
    }
    
    static var improvingWeather: some View {
        // Icon for "Improving weather: clearing skies and cooler temperatures."
        ZStack {
            CloudIcon()
            SunIcon()
        }
    }
    
    static var continuedFoulWeather: some View {
        // Icon for "Continued foul weather."
        ZStack {
            CloudIcon()
            RainIcon()
            SnowIcon()
            StormIcon()
        }
    }
    
    static var stormConditions: some View {
        // Icon for "Storm conditions expected: heavy rain or snow, strong winds."
        ZStack {
            CloudIcon()
            RainIcon()
            SnowIcon()
            StormIcon()
            WindIcon()
        }
    }
    
    static var rapidImprovement: some View {
        // Icon for "Rapid improvement expected: clearing skies and cooler."
        ZStack {
            CloudIcon()
            SunIcon()
            WindIcon()
        }
    }
    
    static var prolongedBadWeather: some View {
        // Icon for "Prolonged bad weather with heavy precipitation."
        ZStack {
            CloudIcon()
            RainIcon()
            SnowIcon()
            StormIcon()
        }
    }
    
    static var gradualClearing: some View {
        // Icon for "Gradual clearing, but conditions remain unsettled."
        ZStack {
            CloudIcon()
            SunIcon()
        }
    }
    
    static var severeWeather: some View {
        // Icon for "Severe weather: heavy rain or snow, strong winds."
        ZStack {
            CloudIcon()
            RainIcon()
            SnowIcon()
            StormIcon()
            WindIcon()
        }
    }
}
