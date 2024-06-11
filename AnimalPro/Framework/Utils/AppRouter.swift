//
//  AppRouter.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import SwiftUI

final public class AppRouter: ObservableObject {
    // enum is used to specify the detail view type
    @Published var navPath = NavigationPath() // path which manages the navigations on NavigationStack
    
    // pusing the destination
    func push(to destination: any Hashable) {
        navPath.append(destination)
    }
    
    // pop pr remving the destination
    func pop() {
        navPath.removeLast()
    }
    
    // removing all presenters and showing root
    func popToRoot() {
        navPath.removeLast(navPath.count)
    }
}

// AppCoordinator
public protocol AppCoordinator {
    var appRouter: AppRouter { get }
    // pusing the destination
    func push(to destination: any Hashable)
    // pop pr remving the destination
    func pop()
    // removing all presenters and showing root
    func popToRoot()
}

// AppCoordinator default implementations
public extension AppCoordinator {
    // pusing the destination
    func push(to destination: any Hashable) {
        appRouter.push(to: destination)
    }
    // pop pr remving the destination
    func pop() {
        appRouter.pop()
    }
    // removing all presenters and showing root
    func popToRoot() {
        appRouter.popToRoot()
    }
}
