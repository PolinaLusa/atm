//
//  ContentView.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var atms = [ATM]()
    @State private var shouldCenterOnUserLocation = false
    @State private var selectedATM: ATM?
    @State private var isSheetPresented = false
    @State private var sheetHeight = CGFloat.zero
    
    var body: some View {
        VStack {
            ZStack {
                GoogleMapsView(
                    shouldCenterOnUserLocation: $shouldCenterOnUserLocation,
                    selectedATM: $selectedATM
                )
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            self.shouldCenterOnUserLocation = true
                        } label: {
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .foregroundStyle(.green)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .tint(Color(uiColor: .systemBackground).opacity(0.75))
                    }
                }
                .padding(.bottom, 30)
                .padding(.trailing, 20)
            }
            .ignoresSafeArea(edges: .all)
            .onChange(of: selectedATM) { newATM in
                if newATM != nil {
                    self.isSheetPresented = true
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                if let selectedATM {
                    VStack {
                        Text("Банкомат")
                            .font(.system(size: 40, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Адрес: \(selectedATM.address.townName), \(selectedATM.address.streetName) \(selectedATM.address.buildingNumber)")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Основная валюта: \(selectedATM.baseCurrency)")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Принимаемые валюты: \(selectedATM.currencies.joined(separator: ","))")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if selectedATM.access24Hours {
                            Text("Работает 24 часа")
                                .font(.system(size: 20, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            ForEach(selectedATM.cards) { card in
                                CardImageView(imageName: card.imageName)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 40)
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                    .padding()
                    .overlay {
                        GeometryReader { geometry in
                            Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                        }
                    }
                    .onPreferenceChange(InnerHeightPreferenceKey.self, perform: { value in
                        self.sheetHeight = value
                    })
                    .presentationDetents([.height(self.sheetHeight)])
                }
            }
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LocalATM.self, inMemory: true)
}
