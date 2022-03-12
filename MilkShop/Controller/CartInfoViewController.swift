import UIKit

class CartInfoViewController: UIViewController{
    
    var order = Order(orderNo: "", name: "", phone: "", store: "", date: "", memo: "")
    
    var totalPriceString: String = ""
    var totalNumberOfCupString: String = ""

    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var totalNumberOfCupLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = totalPriceString
        totalNumberOfCupLabel.text = totalNumberOfCupString
    }
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        if order.name == "" {
            showAlert(message: "請輸入訂購人姓名")
        } else if order.phone == "" {
            showAlert(message: "請輸入手機號碼")
        } else if order.store == "" {
            showAlert(message: "請選擇取貨門市")
        } else {
            uploadOrder(order: order)
        }
    }
    
    @IBAction func unwindToCartInfoView(_ segue: UIStoryboardSegue) {
        
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "欄位錯誤", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveOrderNoToUserDefault() {
        let userDefault = UserDefaults.standard
        if var orderNos = userDefault.array(forKey: "orderNos") {
            orderNos += [order.orderNo]
            userDefault.set(orderNos, forKey: "orderNos")
        } else {
            let orderNos = [order.orderNo]
            userDefault.set(orderNos, forKey: "orderNos")
        }
    }
    
    func uploadOrder(order: Order) {
        let orderBody = getOrderBody(order: order)
        let urlString = "https://api.airtable.com/v0/\(appId)/Order?api_key=\(apiKey)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(orderBody)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                        let orderData: OrderData = decodeJsonData(data)
                        // 取得AirTable自動生成的資料編號作為訂單編號
                        if let orderNo = orderData.records[0].id {
                            self.order.orderNo = orderNo
                    }
                }
                // 上傳訂購飲品資料(OrderDrink)
                for orderDrink in orderDrinks {
                    uploadOrderDrink(orderDrink: orderDrink, orderNo: self.order.orderNo)
                }
                // 將訂單編號儲存到UserDefault
                self.saveOrderNoToUserDefault()
                // 上傳完資料後回到訂購頁面
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeOrder", sender: nil)
                }
            }.resume()
        }
    }
    
    func getOrderBody(order: Order) -> OrderData {
        let orderBody = OrderData(
            records: [.init(
                id: nil,
                fields: .init(
                    name: order.name,
                    phone: order.phone,
                    store: order.store,
                    date: order.date,
                    memo: order.memo)
        )])
        return orderBody
    }
    

}
