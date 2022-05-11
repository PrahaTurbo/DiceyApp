//
//  SettingsView.swift
//  DiceyApp
//
//  Created by Артем Ластович on 07.05.2022.
//

import SwiftUI

struct SettingsView: View {    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var colorSwitcher: ColorThemeSwitcher
    
    @Binding var vibration: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section("color-theme") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ScrollViewReader { proxy in
                                HStack {
                                    ForEach(colorSwitcher.colorThemes, id: \.type) { colorSet in
                                        Button {
                                            withAnimation {
                                                colorSwitcher.selectedTheme = colorSet.type
                                            }
                                        } label: {
                                            VStack {
                                                ZStack {
                                                    colorSet.backgroundColor
                                                    
                                                    VStack {
                                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                            .fill(colorSet.accentColor)
                                                            .frame(maxHeight: 50)
                                                            .padding([.top, .horizontal], 10)
                                                        
                                                        HStack(spacing: 5) {
                                                            ForEach(0..<2) { _ in
                                                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                                    .fill(colorSet.secondaryColor)
                                                                    .frame(maxHeight: 20)
                                                            }
                                                        }
                                                        .padding(.horizontal, 10)
                                                        
                                                        Spacer()
                                                        
                                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                            .fill(colorSet.mainColor)
                                                            .frame(maxHeight: 20)
                                                            .padding(10)
                                                        
                                                    }
                                                    
                                                }
                                                .frame(width: 100, height: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                        .stroke(lineWidth: 3)
                                                        .fill(colorSwitcher.selectedTheme == colorSet.type ? colorSet.mainColor : .clear)
                                                )
                                                
                                                Text(colorSet.name)
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                            }
                                        }
                                        .buttonStyle(ScaledButton())
                                        .padding(.horizontal, 5)
                                        .id(colorSet.type)
                                    }
                                }
                                .onAppear {
                                    proxy.scrollTo(colorSwitcher.selectedTheme, anchor: UnitPoint(x: 1.05, y: 1))
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listRowBackground(colorSwitcher.currentTheme.secondaryColor)
                .foregroundColor(colorSwitcher.currentTheme.mainColor)

                
                Toggle("vibration", isOn: $vibration)
                    .listRowBackground(colorSwitcher.currentTheme.secondaryColor)
                    .foregroundColor(colorSwitcher.currentTheme.mainColor)
                    .tint(colorSwitcher.currentTheme.mainColor)
                
            }
            .background(colorSwitcher.currentTheme.backgroundColor)
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
                    Text("settings")
                        .bold()
                        .foregroundColor(colorSwitcher.currentTheme.mainColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(vibration: .constant(true))
            .environmentObject(ColorThemeSwitcher())
    }
}
