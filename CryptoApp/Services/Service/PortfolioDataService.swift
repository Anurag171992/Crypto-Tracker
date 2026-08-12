//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Anurag on 10/08/26.
//

import Foundation
import CoreData
import Combine

class PortfolioDataService {
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    init() {
        self.container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Loading core data \(error)")
            }
            self.getPortfolioValues()
        }
    }
    
    //MARK: Public
    func updatePortfolio(coin: CoinModel, amount: Double) {
        //Check if coin is in portfolio
        if let entityValue = savedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(entityName: entityValue, amount: amount)
            } else {
                delete(entityName: entityValue)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    //MARK: Private
    private func getPortfolioValues() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            self.savedEntities = try container.viewContext.fetch(request)
        }catch(let error) {
            debugPrint("Error fetching portfolio \(error.localizedDescription)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entityName: PortfolioEntity, amount: Double) {
        entityName.amount = amount
        applyChanges()
    }
    
    private func delete(entityName: PortfolioEntity) {
        container.viewContext.delete(entityName)
        applyChanges()
    }
    
    private func applyChanges() {
        saveContext()
        getPortfolioValues()
    }
    
    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            debugPrint("Error saving to core data \(error.localizedDescription)")
        }
    }
    
}
