//
//  Travel.swift
//  TravelJournal
//
//  Created by GradByte on 12.01.2024.
//

import Foundation

class Travel: ObservableObject {
    @Published var items = [TravelItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([TravelItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}
