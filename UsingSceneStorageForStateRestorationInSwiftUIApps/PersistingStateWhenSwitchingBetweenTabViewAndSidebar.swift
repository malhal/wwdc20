// This is example code for persisting state with SceneStorage when switching between TabView and Sidebar made with iOS & iPadOS 14: 18A5301v
// It crashes very often within the framework when switching size class.
// There currently some issues with programmatic navigation:
// it doesn't highlight the row if it was selected programmatically
// it calls the selection binding twice, second time with nil, so we need to ignore the nil value. We can ignore nil value because this view is replaced with TabView in compact mode.

// Tabs now restore navigation without crashing but Domestic/International state currently isn't saved.
// I believe the crash was related to NavigationLink being bound to selection.
// It also needed the default detail view to show the selection.
// Previously selected sidebar row is shown in grey.
// The main idea here is the detail appearing is what drives the selection not the navigation link.
// Detail could possibly be replaced by the same Tab view perhaps with a page style?

import SwiftUI
struct ContentView: View {
    @SceneStorage("selectedItem") var selectedItem: NavigationItem = .car
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ViewBuilder var body: some View {
        if horizontalSizeClass == .compact {
            TabBarNavigation(selectedItem: $selectedItem)
        } else {
            SidebarNavigation(selectedItem: $selectedItem)
              //  .tabViewStyle(PageTabViewStyle())
        }
    }
}
enum NavigationItem: String {
    case car
    case tram
    case airplane
}
struct SidebarNavigation: View {
    
//    var navigationBinding: Binding<NavigationItem?> {
//        Binding<NavigationItem?> {
//            return self.selectedItem
//        } set: { value in
//            if let value = value {
//                self.selectedItem = value
//            }
//        }
//    }
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var selectedItem: NavigationItem
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Detail(item:.car, selectedItem: $selectedItem)) {
                    Label("Car Trips", systemImage: "car")
                }
                .listRowBackground(selectedItem == .car ? Color(UIColor.lightGray) : Color.clear)
                NavigationLink(destination: Detail(item:.tram, selectedItem: $selectedItem)) {
                    Label("Tram Trips", systemImage: "tram")
                }
                .listRowBackground(selectedItem == .tram ? Color(UIColor.lightGray) : Color.clear)
                NavigationLink(destination: Detail(item:.airplane, selectedItem: $selectedItem)) {
                    Label("Airplane Trips", systemImage: "airplane")
                }
                .listRowBackground(selectedItem == .airplane ? Color(UIColor.lightGray) : Color.clear)
            }
            .listStyle(SidebarListStyle())
            //Text("Select something.")
              //  .frame(maxWidth: .infinity, maxHeight: .infinity)
            Detail(item:selectedItem, selectedItem: $selectedItem)
                //.tabViewStyle(horizontalSizeClass == .compact ? PageTabViewStyle() : DefaultTabViewStyle())
        }
    }
}

struct Detail : View {
    let item: NavigationItem
    @Binding var selectedItem: NavigationItem
    @ViewBuilder
    var body: some View {
        switch item {
        case .car:
            CarTrips()
                .onAppear(){
                    selectedItem = .car
                }
        case .airplane:
            AirplaneTrips()
                .onAppear(){
                    selectedItem = .airplane
                }
        case .tram:
            TramTrips()
                .onAppear(){
                    selectedItem = .tram
                }
        }
    }
}

struct TabBarNavigation: View {
    @Binding var selectedItem: NavigationItem
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
            .tag(NavigationItem.airplane)
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
