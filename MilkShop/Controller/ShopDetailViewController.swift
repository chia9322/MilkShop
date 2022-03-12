import UIKit

class ShopDetailViewController: UIViewController {
    
    var drink: Drink
    var orderDrink: OrderDrink {
        didSet {
            orderDrink.updatePrice()
            orderDrink.printOrder()
            updateTotalPriceLabel()
        }
    }
    
    init?(coder: NSCoder, drink: Drink) {
        self.drink = drink
        let drinkSize: String
        drinkSize = drink.priceM != nil ? "M" : "L"
        self.orderDrink = OrderDrink(id: nil, drink: drink, size: drinkSize, sugar: sugarList[0], temperature: temperatureList[0], toppings: [])
        self.orderDrink.updatePrice()
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var totalNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = drink.name
        updateTotalPriceLabel()
    }
    
    @IBAction func numberStepper(_ sender: UIStepper) {
        orderDrink.numberOfCup = Int(sender.value)
        totalNumberLabel.text = "\(Int(sender.value))杯"
    }
    
    func updateTotalPriceLabel() {
        let totalPrice = orderDrink.pricePerCup * orderDrink.numberOfCup
        totalPriceLabel.text = "總金額：\(totalPrice)元"
    }
    
// MARK: - Segue
    @IBSegueAction func showOrderDetailTableView(_ coder: NSCoder) -> ShopDetailTableViewController? {
        return ShopDetailTableViewController(coder: coder, drink: drink, orderDrink: orderDrink)
    }
    
    @IBAction func unwindToShopDetailView(_ segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateOrderDrink" {
            orderDrinks += [orderDrink]
        }
    }
    
}
