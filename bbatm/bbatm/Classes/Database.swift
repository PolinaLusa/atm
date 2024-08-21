//
//  Database.swift
//  bbatm
//
//  Created by Полина Лущевская on 23.05.24.
//

import SwiftData

final class LocalATMDatabase {
    let container: ModelContainer
    
    var context: ModelContext {
        return ModelContext(self.container)
    }
    
    init() throws {
        self.container = try ModelContainer(for: LocalATM.self)
    }
}
