import SwiftUI

struct RequestGroup: Identifiable {
    var id: UUID
    var name: String
    
    var requests: [Request]
}

struct Request: Identifiable {
    let id = UUID()
    let url: String
    
    var name: String { url }
}

struct ContentView: View {
    
    let requestGroups = [
        RequestGroup(id: UUID(uuidString: "7bbd0224-3a31-4ba7-9dbb-b7138de7aaee") ?? UUID(), name: "httpbin.org", requests: [
            Request(url: "https://httpbin.org/get"),
            Request(url: "https://httpbin.org/post")
        ]),
        RequestGroup(id: UUID(uuidString: "6df253c4-3c91-4712-a398-605c67b1e5b5") ?? UUID(), name: "echo.websocket.org", requests: [
            Request(url: "wss://echo.websocket.org")
        ])
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(requestGroups) { group in
                    RequestGroupRow(group: group)
                }
            }
            .listStyle(SidebarListStyle())
        }
    }
}


struct RequestGroupRow: View {
    
    @SceneStorage("expandedGroups") var isExpanded: Set<UUID> = []
    
    let group: RequestGroup
    
    var isExpandedBinding: Binding<Bool> {
        Binding<Bool> {
            self.isExpanded.contains(self.group.id)
        } set: { isExpanded in
            if isExpanded {
                self.isExpanded.insert(self.group.id)
            } else {
                self.isExpanded.remove(self.group.id)
            }
        }
    }
    
    var body: some View {
        DisclosureGroup(group.name, isExpanded: isExpandedBinding) {
            
            ForEach(group.requests) { request in
                Text(request.url)
            }
        }
    }
}

extension Set: RawRepresentable where Element == UUID {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Set<UUID>.self, from: data) else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else { return "[]" }
        return result
    }
}
