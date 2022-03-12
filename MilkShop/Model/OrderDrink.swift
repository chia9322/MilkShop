import Foundation

struct OrderDrink {
    
    let id: String?
    var customerName: String = ""
    let drink: Drink
    var size: String
    var sugar: String
    var temperature: String
    var toppings: [String]
    
    var pricePerCup: Int = 0
    var numberOfCup: Int = 1
    
    mutating func updatePrice() {
        var toppingPrice: Int = 0
        for topping in self.toppings {
            if let price = toppingList[topping] {
                toppingPrice += price
            }
        }
        let priceOfSize: Int = size == "M" ? drink.priceM! : drink.priceL!
        self.pricePerCup = priceOfSize + toppingPrice
    }
    
    func printOrder() {
        var toppingString: String = ""
        for topping in self.toppings {
            toppingString += "\(topping)/"
        }
        print("\(self.drink.name)/\(self.size)/\(self.sugar)/\(self.temperature)/\(toppingString)$\(self.pricePerCup)/\(self.numberOfCup)杯")
    }
    
}

struct OrderDrinkData: Codable {
    let records: [Record]
    
    struct Record: Codable {
        
        let id: String?
        let fields: Fields

        struct Fields: Codable {
            let customerName: String?
            let drink: String
            let size: String
            let sugar: String
            let temperature: String
            let toppings: [String]?
            let pricePerCup: Int
            let numberOfCup: Int
            let orderNo: String?
        }
        
    }
}




// MARK: - Upload
func uploadOrderDrink(orderDrink: OrderDrink, orderNo: String) {
    let orderDrinkBody = getOrderDrinkBody(orderDrink: orderDrink, orderNo: orderNo)
    let urlString = "https://api.airtable.com/v0/\(appId)/OrderDrink?api_key=\(apiKey)"
    if let url = URL(string: urlString) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(orderDrinkBody)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP response status code: \(httpResponse.statusCode)")
            }
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
            }
        }.resume()
    }
}

func getOrderDrinkBody(orderDrink: OrderDrink, orderNo: String) -> OrderDrinkData {
    let orderDrinkBody = OrderDrinkData(
        records: [.init(
            id: nil,
            fields: .init(
                customerName: orderDrink.customerName,
                drink: orderDrink.drink.name,
                size: orderDrink.size,
                sugar: orderDrink.sugar,
                temperature: orderDrink.temperature,
                toppings: orderDrink.toppings,
                pricePerCup: orderDrink.pricePerCup,
                numberOfCup: orderDrink.numberOfCup,
                orderNo: orderNo
            )
        )])
    return orderDrinkBody
}
