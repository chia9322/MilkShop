import UIKit

class OrderTableViewController: UITableViewController {
    
    var orderNos: [String] = []
    var orders: [Order] = []
    var orderDetails: [[OrderDrink]] = []
    
    var orderDetail: [OrderDrink] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDefault = UserDefaults.standard
        if let orderNos = userDefault.array(forKey: "orderNos") as? [String] {
            self.orderNos = orderNos
        }
        showLoadingView()
        fetchOrderData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderTableView(_ segue: UIStoryboardSegue) {
        
    }

    @IBSegueAction func showOrderDetail(_ coder: NSCoder) -> OrderDetailTableViewController? {
        let idx = tableView.indexPathForSelectedRow!.row
        return OrderDetailTableViewController(coder: coder, orderDrinksInOrder: orderDetails[idx],order: orders[idx])
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableVIewCell.self)", for: indexPath) as! OrderTableVIewCell
        let order = orders[indexPath.row]
        fetchOrderDrinkData(orderNo: order.orderNo, orderNoIndex: indexPath.row)
        cell.storeLabel.text = order.store
        cell.dateLabel.text = order.date
        cell.nameLabel.text = "訂購人：\(order.name)"
        cell.phoneLabel.text = "手機號碼：\(order.phone)"
        return cell
    }
    
    // MARK: - Fetch Order Data
    func fetchOrderData() {
        self.orders = []
        self.orderDetails = []
        let urlString = "https://api.airtable.com/v0/\(appId)/Order?api_key=\(apiKey)"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let orderData: OrderData = decodeJsonData(data)
                    orderDrinks = []
                    for record in orderData.records {
                        if let id = record.id {
                            if self.orderNos.contains(id) {
                                let memo = record.fields.memo ?? ""
                                let order = Order(
                                    orderNo: id,
                                    name: record.fields.name,
                                    phone: record.fields.phone,
                                    store: record.fields.store,
                                    date: record.fields.date,
                                    memo: memo)
                                self.orders += [order]
                                self.orderDetails += [[]]
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }.resume()
        }
    }
    
    func fetchOrderDrinkData(orderNo: String, orderNoIndex: Int){
        let urlString = "https://api.airtable.com/v0/\(appId)/OrderDrink?api_key=\(apiKey)"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let orderDrinkData: OrderDrinkData = decodeJsonData(data)
                    var drinksInOrder: [OrderDrink] = []
                    for record in orderDrinkData.records {
                        if record.fields.orderNo == orderNo {
                            let drink = allDrinks.first(where: {$0.name == record.fields.drink})
                            let customerName = record.fields.customerName == nil ? "" : record.fields.customerName
                            let toppings = record.fields.toppings == nil ? [] : record.fields.toppings
                            let orderDrink = OrderDrink(
                                id: record.id,
                                customerName: customerName!,
                                drink: drink!,
                                size: record.fields.size,
                                sugar: record.fields.sugar,
                                temperature: record.fields.temperature,
                                toppings: toppings!,
                                pricePerCup: record.fields.pricePerCup,
                                numberOfCup: record.fields.numberOfCup)
                            drinksInOrder += [orderDrink]
                        }
                    }
                    self.orderDetails[orderNoIndex] = drinksInOrder
                }
            }.resume()
        }
    }
    
    func showLoadingView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "LoadingViewController")
        secondVC.modalPresentationStyle = .overFullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        present(secondVC, animated: true, completion: nil)
    }
}
