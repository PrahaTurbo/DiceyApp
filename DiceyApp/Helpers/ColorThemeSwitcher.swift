//
//  ColorThemeSwitcher.swift
//  DiceyApp
//
//  Created by Артем Ластович on 08.05.2022.
//

import Foundation
import SwiftUI



@MainActor final class ColorThemeSwitcher: ObservableObject {
    struct ColorSet {
        let name: LocalizedStringKey
        let type: ColorSetType
        let backgroundColor: Color
        let mainColor: Color
        let secondaryColor: Color
        let accentColor: Color
    }
    
    enum ColorSetType: Codable {
        case main, barbarian, bard, wizard, rogue, paladin, druid, fighter, ranger
    }
    
    let colorThemes = [
        ColorSet(name: "main", type: .main, backgroundColor: .white, mainColor: .black, secondaryColor: Color("Secondary"), accentColor: Color("MainAccent")),
        ColorSet(name: "barbarian", type: .barbarian, backgroundColor: .white, mainColor: Color("BarbarianMain"), secondaryColor: Color("Secondary"), accentColor: Color("BarbarianAccent")),
        ColorSet(name: "bard", type: .bard, backgroundColor: .white, mainColor: Color("BardMain"), secondaryColor: Color("Secondary"), accentColor: Color("BardAccent")),
        ColorSet(name: "wizard", type: .wizard, backgroundColor: .white, mainColor: Color("WizardMain"), secondaryColor: Color("Secondary"), accentColor: Color("WizardAccent")),
        ColorSet(name: "rogue", type: .rogue, backgroundColor: .white, mainColor: .black, secondaryColor: Color("Secondary"), accentColor: Color("RogueAccent")),
        ColorSet(name: "paladin", type: .paladin, backgroundColor: .white, mainColor: Color("PaladinMain"), secondaryColor: Color("Secondary"), accentColor: Color("PaladinAccent")),
        ColorSet(name: "druid", type: .druid,  backgroundColor: .white, mainColor: Color("DruidMain"), secondaryColor: Color("Secondary"), accentColor: Color("DruidAccent")),
        ColorSet(name: "fighter", type: .fighter, backgroundColor: .white, mainColor: Color("FighterMain"), secondaryColor: Color("Secondary"), accentColor: Color("FighterAccent")),
        ColorSet(name: "ranger", type: .ranger, backgroundColor: .white, mainColor: Color("RangerMain"), secondaryColor: Color("Secondary"), accentColor: Color("RangerAccent")),
    ]

    @Published var selectedTheme = ColorSetType.main {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(selectedTheme) {
                UserDefaults.standard.set(encoded, forKey: "Theme")
            }
        }
    }
    
    var currentTheme: ColorSet {
        switch selectedTheme {
        case .main:
            return colorThemes.filter { $0.type == .main } [0]
        case .barbarian:
            return colorThemes.filter { $0.type == .barbarian } [0]
        case .bard:
            return colorThemes.filter { $0.type == .bard } [0]
        case .wizard:
            return colorThemes.filter { $0.type == .wizard } [0]
        case .rogue:
            return colorThemes.filter { $0.type == .rogue } [0]
        case .paladin:
            return colorThemes.filter { $0.type == .paladin } [0]
        case .druid:
            return colorThemes.filter { $0.type == .druid } [0]
        case .fighter:
            return colorThemes.filter { $0.type == .fighter } [0]
        case .ranger:
            return colorThemes.filter { $0.type == .ranger } [0]
        }
    }
    
    func reloadColors() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(currentTheme.mainColor)]

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(currentTheme.mainColor)]
    }
    
    init() {
        if let savedTheme = UserDefaults.standard.data(forKey: "Theme") {
            if let decodedTheme = try? JSONDecoder().decode(ColorSetType.self, from: savedTheme) {
                selectedTheme = decodedTheme
                return
            }
        }
        selectedTheme = .main
    }
}
