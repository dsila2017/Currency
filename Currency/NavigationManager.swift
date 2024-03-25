//
//  NavigationManager.swift
//  Currency
//
//  Created by David on 3/25/24.
//

import Foundation
import SwiftUI

enum Destination {
    case secondView(model: GraphViewModel)
}

class NavigationManager: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(to destination: Destination) {
        path.append(destination)
    }
    
    func back() {
        path.removeLast()
    }
    
    func backToRoot() {
        path.removeLast(path.count)
    }
}

extension Destination: Hashable {
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        switch(lhs, rhs) {
        case (.secondView(let lhsx), .secondView(let rhsx)):
            return lhsx.id == rhsx.id
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}

//func hash(into hasher: inout Hasher) {
//    hasher.combine(hashValue)
//}
//
//static func == (lhs: Destination, rhs: Destination) -> Bool {
//    switch (lhs, rhs) {
//    case(.mainViews, .mainViews):
//        return true
//    case (.mainView(model: let lhsModel), .mainView(model: let rhsModel)):
//        return lhsModel.id == rhsModel.id
//    case (.mainView(model: let model), .mainViews):
//        <#code#>
//    case (.mainViews, .mainView(model: let model)):
//        <#code#>
//    }
//}
