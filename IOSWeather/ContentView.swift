import SwiftUI
import CoreMotion
import Combine

class PressureTrendTracker: ObservableObject {
    @Published var pressureTrend: BarometerView.PressureTrend = .steady
    private var pressureHistory: [Double] = []
    private let pressureChangeThresholdRapid: Double = 0.5 // Define your rapid threshold
    private let pressureChangeThresholdSlow: Double = 0.1 // Define your slow threshold

    func updatePressure(_ newPressure: Double) {
        pressureHistory.append(newPressure)

        // Only keep the last minute of readings, assuming one reading per second
        if pressureHistory.count > 60 {
            pressureHistory.removeFirst()
        }

        // Calculate trend based on the change over the last minute
        if let firstPressure = pressureHistory.first {
            let pressureChange = newPressure - firstPressure
            
            if pressureChange > pressureChangeThresholdRapid {
                pressureTrend = .risingRapidly
            } else if pressureChange < -pressureChangeThresholdRapid {
                pressureTrend = .fallingRapidly
            } else if pressureChange > pressureChangeThresholdSlow {
                pressureTrend = .risingSlowly
            } else if pressureChange < -pressureChangeThresholdSlow {
                pressureTrend = .fallingSlowly
            } else {
                pressureTrend = .steady
            }
        }
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var thumbColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .foregroundColor(thumbColor)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

struct BarometerGaugeView: View {
    var pressure: Double
    private let minValue: Double = 100.0
    private let maxValue: Double = 1100.0

    var clampedPressure: Double {
        min(max(pressure, minValue), maxValue)
    }

    var body: some View {
        Gauge(value: clampedPressure, in: minValue...maxValue) {
            // The label inside the gauge is removed for a minimalist design
        } currentValueLabel: {
            Text("\(clampedPressure, specifier: "%.2f") kPa")
                .font(.system(size: 16)) // Adjust the font size as needed
                .foregroundColor(Color.cyan)
        }
        .gaugeStyle(.accessoryCircular)
        .tint(Color.cyan) // Using solid cyan color
        .scaleEffect(4) // Adjust the scale factor as needed
        .padding() // Add padding around the gauge
    }
}




struct BarometerView: View {
    var pressure: Double
      @ObservedObject var trendTracker: PressureTrendTracker
      @State private var showInHg = false // State to toggle between kPa and inHg
      @State private var showToggle = false // State to control the visibility of the toggle


    var weatherDescription: String {
        let pressureInInHg = pressure / 3.38639 // Convert kPa to inHg for comparison

        switch (pressureInInHg, trendTracker.pressureTrend) {
        case (30.20..., .fallingRapidly):
            return "Warmer, and rain within 36 hours."
        case (30.20..., .steady):
            return "No early change."
        case (30.00...30.20, .fallingSlowly):
            return "Rain within 18 hours that will continue a day or two."
        case (30.00...30.20, .fallingRapidly):
            return "Warmer, and rain within 24 hours."
        case (30.00...30.20, .risingRapidly):
            return "Fair followed within two days by warmer and rain."
        case (30.00...30.20, .steady):
            return "Fair, with slight changes in temperature, for one to two days."
        case (29.80..<30.00, .fallingRapidly):
            return "Rain, with high wind, followed within two days by clearing, colder."
        case (29.80..<30.00, .risingRapidly):
            return "Clearing and colder within 12 hours."
        case (29.80..<30.00, .steady):
            return "Fair and warmer."
        case (29.60..<29.80, .fallingSlowly):
            return "Foul weather: rain, snow, and storms."
        case (29.60..<29.80, .risingSlowly):
            return "Improving weather: clearing skies and cooler temperatures."
        case (29.60..<29.80, .steady):
            return "Continued foul weather."
        case (...29.60, .fallingRapidly):
            return "Storm conditions expected: heavy rain or snow, strong winds."
        case (...29.60, .risingRapidly):
            return "Rapid improvement expected: clearing skies and cooler."
        case (...29.60, .steady):
            return "Severe weather: heavy rain or snow, strong winds."
        case (...29.60, .fallingRapidly):
            return "Severe storm with heavy rain or snow imminent."
        case (...29.60, .risingRapidly):
            return "Rapid improvement, but cold weather likely."
        case (...29.60, .fallingSlowly):
            return "Prolonged bad weather with heavy precipitation."
        case (...29.60, .risingSlowly):
            return "Gradual clearing, but conditions remain unsettled."
        case (...29.60, .steady):
            return "Severe weather: heavy rain or snow, strong winds."
        default:
            return String(format: "Check for updates - Current pressure: %.2f inHg", pressureInInHg)
        }
    }
    
    var pressureDisplay: String {
         let pressureInInHg = pressure / 3.38639 // Convert kPa to inHg
         return showInHg
             ? String(format: "%.2f inHg", pressureInInHg)
             : String(format: "%.4f kPa", pressure)
     }
    
    var pressureDisplayGuage: Double {
        showInHg ? pressure / 3.38639 : pressure // Convert kPa to inHg if needed
    }

     var body: some View {
         VStack {
             Spacer()
             
             // Gauge for displaying pressure
             BarometerGaugeView(pressure: pressure)
                 .padding()
             // Pressure display text with tap gesture
              Text(pressureDisplay)
                  .font(.system(size: 40, weight: .bold, design: .monospaced))
                  .foregroundColor(Color.cyan)
                  .padding()
                  .onTapGesture {
                      self.showToggle.toggle() // Toggle the visibility of the switch
                  }

              // Conditionally display the toggle
              if showToggle {
                  Toggle(isOn: $showInHg) {
                      Text(showInHg ? "Display in kPa" : "Display in inHg")
                          .foregroundColor(Color.cyan)
                  }
                  .padding()
                  .toggleStyle(ColoredToggleStyle(onColor: .cyan, offColor: .gray, thumbColor: .white))
              }
             Text(weatherDescription)
                 .font(.title3)
                 .foregroundColor(Color.cyan)
                 .padding()
//             WeatherIcons.test // Replace with the appropriate weather icon
//                         .font(.system(size: 60)) // Adjust the size as needed
//                         .foregroundColor(Color.cyan)
             Spacer()
         }
         .background(Color.black.edgesIgnoringSafeArea(.all))
     }
    
    enum PressureTrend {
        case risingRapidly, fallingRapidly, risingSlowly, fallingSlowly, steady
    }
}

struct ContentView: View {
    @State private var pressure: Double = 1013.25 // A default value for pressure
    @StateObject private var trendTracker = PressureTrendTracker()
    private let altimeter = CMAltimeter()

    var body: some View {
        BarometerView(pressure: pressure, trendTracker: trendTracker)
            .onAppear(perform: startAltimeter)
    }

    private func startAltimeter() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            print("Altimeter is not available on this device")
            return
        }

        altimeter.startRelativeAltitudeUpdates(to: .main) { (altitudeData, error) in
            guard error == nil, let data = altitudeData else {
                print("Error reading altimeter data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                let rawPressure = data.pressure.doubleValue
                self.pressure = rawPressure * 10 // Example transformation, adjust as needed
//                print("Altimeter Pressure: \(rawPressure), Transformed Pressure: \(self.pressure)")
                self.trendTracker.updatePressure(self.pressure)
            }
        }

    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
