import Foundation

struct Store {
    let name: String
    let address: String
    let mapUrl: URL?
    let phone: String
    let openingHours: String
}

struct StoreData: Codable {
    let items: [Item]
    struct Item: Codable {
        let name: String
        let address: String
        let map_url: String
        let phone: String
        let opening_hours: String
    }
}

func getAllStoreData() {
    let data = loadJsonFile("stores")
    let storesData: StoreData = decodeJsonData(data)
    allStores = []
    for item in storesData.items {
        // 由於地圖網址字串包含中文字元，需加入下列程式碼才能轉換成URL型式
        let urlString: String = item.map_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let newStore = Store(name: item.name, address: item.address, mapUrl: URL(string: urlString), phone: item.phone, openingHours: item.opening_hours)
        allStores += [newStore]
    }
}
