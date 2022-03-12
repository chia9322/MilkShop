import UIKit

class CartInfoTableViewController: UITableViewController {
    
    var order: Order?
    
    var store: String = "" {
        didSet {
            order?.store = store
            storeTextField.text = store
            // go to memoTextView after selecting store
            nameTextField.resignFirstResponder()
            phoneTextField.resignFirstResponder()
            memoTextView.becomeFirstResponder()
        }
    }
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var storeTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        phoneTextField.delegate = self
        storeTextField.isEnabled = false
        memoTextView.delegate = self
        
        nameTextField.becomeFirstResponder()
        
        nameTextField.addTarget(self, action: #selector(CartInfoTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(CartInfoTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        performSegue(withIdentifier: "unwindToCartInfoView", sender: nil)
    }
    
    @IBAction func unwindToCartInfoTableView(_ segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCartInfoView" {
            let controller = segue.destination as! CartInfoViewController
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-M-d"
            let todayString = dataFormatter.string(from: Date.now)
            order = Order(
                orderNo: "",
                name: nameTextField.text!,
                phone: phoneTextField.text!,
                store: store,
                date: todayString,
                memo: memoTextView.text!)
            controller.order = order!
        }
    }
    
}

extension CartInfoTableViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField && storeTextField.text == "" {
            performSegue(withIdentifier: "showSearchStoreController", sender: nil)
        }
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // close keyboard when entering "return" in memoTextView
        if text == "\n" {
            memoTextView.resignFirstResponder()
            performSegue(withIdentifier: "unwindToCartInfoView", sender: nil)
            return false
        }
        return true
    }
}

