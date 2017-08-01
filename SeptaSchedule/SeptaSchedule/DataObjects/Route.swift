// SEPTA.org, created on 8/1/17.

import Foundation

public struct Route {
    let routeId: String
    let routeShortName: String
    let routeLongName: String
}

extension Route: Equatable {
    public static func == (lhs: Route, rhs: Route) -> Bool {
        return
            lhs.routeId == rhs.routeId &&
            lhs.routeShortName == rhs.routeShortName &&
            lhs.routeLongName == rhs.routeLongName
    }
}
