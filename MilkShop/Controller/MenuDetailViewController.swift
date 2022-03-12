import UIKit

class MenuDetailViewController: UIViewController {
    
    var drink: Drink
    
    init?(coder: NSCoder, drink: Drink) {
        self.drink = drink
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mLabel: UILabel!
    @IBOutlet var lLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var noCaffeineLabel: UILabel!
    @IBOutlet var noSugarLabel: UILabel!
    @IBOutlet var iceOnlyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Tap screen to go back to the previous page
        addTapRecognizer()
    }
    
    // MARK: - Update View
    func updateView() {
        imageView.image = UIImage(named: drink.name)
        nameLabel.text = drink.name
        if drink.priceM == nil {
            mLabel.isHidden = true
        }
        if drink.priceL == nil {
            lLabel.isHidden = true
        }
        
        descriptionTextView.text = drink.description
        
        noCaffeineLabel.isHidden = drink.noCaffeine ? false : true
        noSugarLabel.isHidden = drink.noSugar ? false : true
        iceOnlyLabel.isHidden = drink.iceOnly ? false : true
    }
    
    // MARK: - Tap screen to go back to the previous page
    func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(MenuDetailViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView() {
        self.performSegue(withIdentifier: "unwindToMenuView", sender: self)
    }

}
