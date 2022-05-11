//
//  HistoryView.swift
//  DiceyApp
//
//  Created by Артем Ластович on 10.04.2022.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var diceRolls: FetchedResults<DiceRoll>
    @EnvironmentObject var colorSwitcher: ColorThemeSwitcher
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(diceRolls.reversed()) { roll in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey(String(roll.sides)))
                                    .font(.headline)
                                + Text(" sided")
                                    .font(.headline)
                                
                                Text(LocalizedStringKey(String(roll.diceAmount)))
                                    .font(.subheadline)
                                + Text(roll.diceAmount == 1 ? " piece" : " pieces")
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Text(String(roll.totalRolled))
                                .font(.title.bold())
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(colorSwitcher.currentTheme.accentColor)
                        .foregroundColor(colorSwitcher.currentTheme.mainColor)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(colorSwitcher.currentTheme.mainColor)
                            .font(.caption)
                            .padding(7)
                            .background(colorSwitcher.currentTheme.secondaryColor)
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("history")
                        .bold()
                        .foregroundColor(colorSwitcher.currentTheme.mainColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
