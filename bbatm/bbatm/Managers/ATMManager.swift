//
//  ATMManager.swift
//  bbatm
//
//  Created by Полина Лущевская on 16.05.24.
//

import SwiftUI
import SwiftData

final class ATMManager: ObservableObject {
    @Published var atms = [ATM]() {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    private let database: LocalATMDatabase
    
    init() {
        do {
            self.database = try LocalATMDatabase()
        } catch {
            fatalError("Error\n\(error.localizedDescription)")
        }
        
        BBProvider().loadAtms { [weak self] atms, error in
            if let atms {
                let fetchedAtms = atms.map({ $0.atm })
                self?.atms = fetchedAtms
                self?.saveOrUpdateLocalAtms(fetchedAtms)
            } else {
                self?.atms = self?.readATM() ?? []
            }
        }
    }
    
    private func saveOrUpdateLocalAtms(_ atms: [ATM]) {
        let fetchDescriptor = FetchDescriptor<LocalATM>()
        
        let context = self.database.context
        atms.forEach({ context.insert($0.toSwiftData) })
        
        do {
            try context.save()
        } catch {
            fatalError("Error\n\(error.localizedDescription)")
        }
    }
    
    func readATM() -> [ATM] {
        let fetchDescriptor = FetchDescriptor<LocalATM>()
        let context = self.database.context
        
        do {
            let atms = try context.fetch(fetchDescriptor)
            return atms.map({ $0.toATM })
        } catch {
            fatalError("Error\n\(error.localizedDescription)")
        }
    }
}
