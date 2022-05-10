//
//  DiceView-ViewModel.swift
//  DiceyApp
//
//  Created by Артем Ластович on 10.04.2022.
//

import Foundation
import CoreData
import SwiftUI

extension MainView {
    @MainActor class ViewModel: ObservableObject {
        let sides = [2, 4, 6, 8, 10, 12, 20, 100]

        @Published var diceAmount = 1
        @Published var currentSides = 6
        @Published var rolledNumber = ""
        
        var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        var timeRemaining = 3
        @Published var timerIsActive = false
        
        @Published var showingHistory = false
        @Published var showingSettings = false
        
        var feedback = UINotificationFeedbackGenerator()
        @Published var vibrationIsOn = true {
            didSet {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(vibrationIsOn) {
                    UserDefaults.standard.set(encoded, forKey: "Vibration")
                }
            }
        }
        
        func roll() {
            let range = currentSides * diceAmount
            rolledNumber = String(Int.random(in: diceAmount...range))
            
            if vibrationIsOn {
                feedback.notificationOccurred(.success)
            }
        }
        
        func save(moc: NSManagedObjectContext) {
            let dice = DiceRoll(context: moc)
            dice.sides = Int16(currentSides)
            dice.diceAmount = Int16(diceAmount)
            dice.totalRolled = Int16(rolledNumber) ?? Int16(12)
            
            if moc.hasChanges {
                try? moc.save()
            }
            
            limitObjects(moc: moc)
        }
        
        func limitObjects(moc: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<DiceRoll> = DiceRoll.fetchRequest()
            
            if let results = try? moc.fetch(fetchRequest) {
                if results.count > 50 {
                    for index in 0..<results.count - 50 {
                        moc.delete(results[index])
                    }
                    try? moc.save()
                }
            }
        }
        
        func numberFlick(moc: NSManagedObjectContext) {
            
            if timeRemaining > 0 {
                timeRemaining -= 1
                roll()
            } else {
                stopTimer()
                timeRemaining = 3
                save(moc: moc)
            }
        }
        
        func stopTimer() {
            timer.upstream.connect().cancel()
            timerIsActive = false
        }
        
        func startTimer() {
            if vibrationIsOn {
                feedback.prepare()
            }
            
            timerIsActive = true
            objectWillChange.send()
            timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        }
        
        init() {
            if let savedVibration = UserDefaults.standard.data(forKey: "Vibration") {
                if let decodedVibration = try? JSONDecoder().decode(Bool.self, from: savedVibration) {
                    vibrationIsOn = decodedVibration
                    return
                }
            }
            vibrationIsOn = true
        }
    }
}
