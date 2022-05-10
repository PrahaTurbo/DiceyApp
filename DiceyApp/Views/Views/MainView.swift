//
//  ContentView.swift
//  DiceyApp
//
//  Created by Артем Ластович on 09.04.2022.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var moc
    
    @StateObject private var viewModel: ViewModel
    @EnvironmentObject var colorSwitcher: ColorThemeSwitcher
    
    var body: some View {
        NavigationView {
            ZStack {
                colorSwitcher.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(colorSwitcher.currentTheme.accentColor)
                        
                        
                        Text(viewModel.rolledNumber)
                            .font(.system(size: 100).bold())
                            .foregroundColor(viewModel.timerIsActive == true ? colorSwitcher.currentTheme.mainColor.opacity(0.5) : colorSwitcher.currentTheme.mainColor)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading) {
                        Text("dice-amount")
                            .font(.headline)
                            .foregroundColor(colorSwitcher.currentTheme.mainColor)
                        
                        HStack {
                            ForEach(1..<7) { amount in
                                Button {
                                    viewModel.diceAmount = amount
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(viewModel.diceAmount == amount ? colorSwitcher.currentTheme.accentColor : colorSwitcher.currentTheme.secondaryColor)
                                            .aspectRatio(1, contentMode: .fit)
                                        
                                        Text(String(amount))
                                            .font(.title2.bold())
                                            .foregroundColor(colorSwitcher.currentTheme.mainColor)
                                    }
                                    .frame(maxWidth: 70)
                                }
                                .buttonStyle(ScaledButton())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("dice-sides")
                            .font(.headline)
                            .padding(.horizontal)
                            .foregroundColor(colorSwitcher.currentTheme.mainColor)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.sides, id:\.self) { side in
                                    Button {
                                        viewModel.currentSides = side
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                                .fill(viewModel.currentSides == side ? colorSwitcher.currentTheme.accentColor : colorSwitcher.currentTheme.secondaryColor)
                                            
                                            Text(String(side))
                                                .font(.largeTitle.bold())
                                                .foregroundColor(colorSwitcher.currentTheme.mainColor)
                                        }
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(maxHeight: 100)
                                    }
                                    .buttonStyle(ScaledButton())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        viewModel.startTimer()
                    } label: {
                        Text("roll")
                            .font(.title.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(colorSwitcher.currentTheme.mainColor)
                            .foregroundColor(colorSwitcher.currentTheme.backgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    }
                    .buttonStyle(ScaledButton())
                    .padding(.vertical)
                    .padding(.horizontal)
                }
                .onReceive(viewModel.timer) { time in
                    viewModel.numberFlick(moc: moc)
                }
                .onAppear {
                    viewModel.stopTimer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.showingHistory = true
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(colorSwitcher.currentTheme.mainColor)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.showingSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(colorSwitcher.currentTheme.mainColor)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("DiceyApp")
                            .bold()
                            .foregroundColor(colorSwitcher.currentTheme.mainColor)
                    }
                    
                }
                .sheet(isPresented: $viewModel.showingHistory) {
                    HistoryView()
                }
                .sheet(isPresented: $viewModel.showingSettings) {
                    SettingsView(vibration: $viewModel.vibrationIsOn)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    init() {
        UITableView.appearance().backgroundColor = .white
        
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ColorThemeSwitcher())
    }
}

