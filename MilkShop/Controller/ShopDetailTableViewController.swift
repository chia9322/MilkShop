import UIKit

class ShopDetailTableViewController: UITableViewController {
    
    var drink: Drink
    var orderDrink: OrderDrink {
        didSet {
            performSegue(withIdentifier: "unwindToShopDetailView", sender: nil)
        }
    }
    
    var selectedToppingButtons: [UIButton] = []
    
    @IBOutlet var customerNameTextField: UITextField!
    @IBOutlet var sizeButtons: [UIButton]!
    @IBOutlet var temperatureButtons: [UIButton]!
    @IBOutlet var sugarButtons: [UIButton]!
    @IBOutlet var toppingButtons: [UIButton]!
    
    @IBOutlet var imageView: UIImageView!
    
    init?(coder: NSCoder, drink: Drink, orderDrink: OrderDrink) {
        self.drink = drink
        self.orderDrink = orderDrink
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        customerNameTextField.delegate = self
        customerNameTextField.addTarget(self, action: #selector(ShopDetailTableViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        orderDrink.customerName = customerNameTextField.text!
    }
    
    func updateUI() {
        imageView.image = UIImage(named: drink.name)
        
        if drink.priceM == nil {
            sizeButtons[0].isHidden = true
            sizeButtonPressed(sizeButtons[1])
        } else if drink.priceL == nil {
            sizeButtons[1].isHidden = true
            sizeButtonPressed(sizeButtons[0])
        } else {
            sizeButtonPressed(sizeButtons[0])
        }
        
        // Temperature Option
        changeButtonStatus(buttons: temperatureButtons, selectedButtons: [temperatureButtons[0]])
        if drink.iceOnly {
            for buttonIndex in 4...6 {
                temperatureButtons[buttonIndex].isHidden = true
            }
        }
        
        // Sugar Option
        if drink.noSugar {
            for sugarButton in sugarButtons {
                sugarButton.isHidden = true
            }
            sugarButtons[0].isHidden = false
        } else {
            changeButtonStatus(buttons: sugarButtons, selectedButtons: [sugarButtons[0]])
        }
    }
    
    // MARK: - Buttons
    @IBAction func sizeButtonPressed(_ sender: UIButton) {
        changeButtonStatus(buttons: sizeButtons, selectedButtons: [sender])
        let size = sender.titleLabel!.text!
        orderDrink.size = size == "M" ? "M" : "L"
    }
    
    @IBAction func temperatureButtonPressed(_ sender: UIButton) {
        orderDrink.temperature = temperatureList[sender.tag]
        changeButtonStatus(buttons: temperatureButtons, selectedButtons: [sender])
    }
    
    @IBAction func sugarButtonPressed(_ sender: UIButton) {
        orderDrink.sugar = sugarList[sender.tag]
        changeButtonStatus(buttons: sugarButtons, selectedButtons: [sender])
    }
    
    @IBAction func toppingButtonPressed(_ sender: UIButton) {
        
        if selectedToppingButtons.contains(sender) {
            selectedToppingButtons.removeAll(where: { $0 == sender} )
        } else {
            if selectedToppingButtons.count >= 2 {
                selectedToppingButtons = []
            }
            selectedToppingButtons += [sender]
        }
        
        orderDrink.toppings = []
        for toppingButton in selectedToppingButtons {
            let topping = toppingButton.titleLabel!.text!
            orderDrink.toppings += [topping]
        }
        changeButtonStatus(buttons: toppingButtons, selectedButtons: selectedToppingButtons)
    }
    
    func changeButtonStatus(buttons: [UIButton], selectedButtons: [UIButton]) {
        for button in buttons {
            button.configuration?.baseBackgroundColor = UIColor(named: "green1")
            button.configuration?.baseForegroundColor = UIColor(named: "green3")
        }
        for button in selectedButtons {
            button.configuration?.baseBackgroundColor = UIColor(named:"green3")
            button.configuration?.baseForegroundColor = .white
        }
        
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToShopDetailView" {
            let controller = segue.destination as! ShopDetailViewController
            controller.orderDrink = orderDrink
        }
    }
    
}


extension ShopDetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
