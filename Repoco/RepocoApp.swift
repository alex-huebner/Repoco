//
//  RepocoApp.swift
//  Repoco
//
//  Created by Alexander Huebner on 18.11.22.
//

import SwiftUI

@main
struct RepocoApp: App {
    
    @StateObject var bleSession = BLESession()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bleSession)
        }
    }
}
