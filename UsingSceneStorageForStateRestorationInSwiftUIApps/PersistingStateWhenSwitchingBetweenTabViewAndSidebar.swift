// This is example code for persisting state with SceneStorage when switching between TabView and Sidebar made with iOS & iPadOS 14: 18A5301v

// It crashes very often within the framework when switching size class.

// There currently some issues with programmatic navigation:
// it doesn't highlight the row if it was selected programmatically
// it calls the selection binding twice, second time with nil, so we need to ignore the nil value. We can ignore nil value because this view is replaced with TabView in compact mode.

import SwiftUI

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @ViewBuilder var body: some View {
        if horizontalSizeClass == .compact {
            TabBarNavigation()
        } else {
            SidebarNavigation()
        }
    }
}

enum NavigationItem: String {
    case car
    case tram
    case airplaine
}

struct SidebarNavigation: View {
    
    @SceneStorage("selectedItem") var selectedItem: NavigationItem = .car
    
    var navigationBinding: Binding<NavigationItem?> {
        Binding<NavigationItem?> {
            return self.selectedItem
        } set: { value in
            if let value = value {
                self.selectedItem = value
            }
            
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CarTrips(), tag: NavigationItem.car, selection: navigationBinding) {
                    Label("Car Trips", systemImage: "car")
                }
                .tag(NavigationItem.car)
                
                NavigationLink(destination: TramTrips(), tag: NavigationItem.tram, selection: navigationBinding) {
                    Label("Tram Trips", systemImage: "tram")
                }
                .tag(NavigationItem.tram)
                
                NavigationLink(destination: AirplaneTrips(), tag: NavigationItem.airplaine, selection: navigationBinding) {
                    Label("Airplane Trips", systemImage: "airplane")
                }
                .tag(NavigationItem.airplaine)
                
            }
            .listStyle(SidebarListStyle())
            
            
            Text("Select something.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        
    }
    
}

struct TabBarNavigation: View {
    @SceneStorage("selectedItem") var selectedItem: NavigationItem = .car
    
    var body: some View {
        TabView(selection: $selectedItem) {
            NavigationView {
                CarTrips()
            }
            .tabItem {
                Label("Car Trips", systemImage: "car")
            }
            .tag(NavigationItem.car)
            
            NavigationView {
                TramTrips()
            }
            .tabItem {
                Label("Tram Trips", systemImage: "tram.fill")
            }
            .tag(NavigationItem.tram)
            
            
            NavigationView {
                AirplaneTrips()
            }
            .tabItem {
                Label("Airplane Trips", systemImage: "airplane")
            }
            .tag(NavigationItem.airplaine)
        }
        
    }
}

struct CarTrips: View {
    
    var body: some View {
        List {
            Text("Dunedin 03.04.2020")
            Text("Nelson 20.04.2020")
            Text("Christchurch 7.05.2020")
        }
        .navigationTitle("Car Trips")
    }
    
}

struct TramTrips: View {
    
    var body: some View {
        List {
            Text("Quake City Museum 09.04.2020")
            Text("Christchurch Cathedral  23.04.2020")
        }
        .navigationTitle("Tram Trips")
    }
}

struct AirplaneTrips: View {
    
    @SceneStorage("selectedAirplaneSubview")
    var selectedAirplaneSubview: Subview = .domestic
    
    let subviews = Subview.allCases
    
    var body: some View {
        List {
            switch selectedAirplaneSubview {
            case Subview.domestic:
                Text("Auckland 14.04.2020")
                Text("Wellington 10.05.2020")
            case Subview.international:
                Text("Sydney 17.04.2020")
                Text("Singapore 12.05.2020")
            }
        }
        
        .navigationTitle("Airplane Trips")
        
        .navigationBarItems(
            trailing:
                Picker("Airplane Trips", selection: $selectedAirplaneSubview) {
                    ForEach(self.subviews, id: \.self) { subview in
                        Text(subview.rawValue.capitalized)
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 250)
            
        )
    }
    
    enum Subview: String, CaseIterable {
        case domestic
        case international
    }
}
