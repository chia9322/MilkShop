import Foundation

struct Drink: Equatable {
    let name: String
    let priceM: Int?
    let priceL: Int?
    let noCaffeine: Bool
    let noSugar: Bool
    let iceOnly: Bool
    let description: String
    let category: String
}

struct DrinkData: Codable {
    let records: [Record]
    
    struct Record: Codable {
        
        let id: String
        let fields: Fields
        
        struct Fields: Codable {
            let name: String
            let priceM: Int?
            let priceL: Int?
            let noCaffeine: String
            let noSugar: String
            let iceOnly: String
            let description: String
            let category: String
        }
    }
    
}

struct DrinkCategory {
    let name: String
    var drinks: [Drink]
}
