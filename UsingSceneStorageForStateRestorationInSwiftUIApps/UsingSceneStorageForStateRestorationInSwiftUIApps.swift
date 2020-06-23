//
// Example code for article: https://lostmoa.com/blog/UsingSceneStorageForStateRestorationInSwiftUIApps/
//


import SwiftUI

struct ContentView: View {
    
    @SceneStorage("selectedTab") var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CarTrips()
                .tabItem {
                    Image(systemName: "car")
                    Text("Car Trips")
                }.tag(0)
            TramTrips()
                .tabItem {
                    Image(systemName: "tram.fill")
                    Text("Tram Trips")
                }.tag(1)
            AirplaneTrips()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Airplane Trips")
            }.tag(2)
        }
    }
}

struct CarTrips: View {
    
    var body: some View {
        NavigationView {
            List {
                Text("Dunedin 03.04.2020")
                Text("Nelson 20.04.2020")
                Text("Christchurch 7.05.2020")
            }
            .navigationTitle("Car Trips")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct TramTrips: View {
    
    var body: some View {
        NavigationView {
            List {
                Text("Quake City Museum 09.04.2020")
                Text("Christchurch Cathedral  23.04.2020")
            }
            .navigationTitle("Tram Trips")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AirplaneTrips: View {
    
    @SceneStorage("selectedAirplaneSubview") var selectedAirplaneSubview = "Domestic"
    
    let subviews = ["Domestic", "International"]
    
    var body: some View {
        NavigationView {
            List {
                if selectedAirplaneSubview == "Domestic" {
                    Text("Auckland 14.04.2020")
                    Text("Wellington 10.05.2020")
                } else {
                    Text("Sydney 17.04.2020")
                    Text("Singapore 12.05.2020")
                }
            }
            .navigationBarItems(
                trailing:
                        Picker("Airplane Trips", selection: $selectedAirplaneSubview) {
                            ForEach(self.subviews, id: \.self) { subview in
                                Text(subview)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 250)

            )
            .navigationTitle("Airplane Trips")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
