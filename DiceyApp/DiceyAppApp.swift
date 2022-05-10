//
//  DiceyAppApp.swift
//  DiceyApp
//
//  Created by Артем Ластович on 09.04.2022.
//

import SwiftUI

@main
struct DiceyAppApp: App {
    @StateObject var colorSwitcher: ColorThemeSwitcher
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(.light)
                .environmentObject(colorSwitcher)
        }
    }
    
    init() {
        _colorSwitcher = StateObject(wrappedValue: ColorThemeSwitcher())
    }
}
