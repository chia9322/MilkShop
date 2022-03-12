import UIKit

protocol CartTableViewCellDelegate {
    func didTapValueDownButton(with cellIndex: Int)
    func didTapValueUpButton(with cellIndex: Int)
}

class CartTableViewCell: UITableViewCell {
    
    var delagate: CartTableViewCellDelegate?
    
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var drinkImageView: UIImageView!
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var drinkDetailLabel: UILabel!
    @IBOutlet var numberOfCupLabel: UILabel!
    @IBOutlet var valueDownButton: UIButton!
    @IBOutlet var valueUpButton: UIButton!
    
    @IBOutlet var viewTopContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func valueDownButtonPressed(_ sender: UIButton) {
        delagate?.didTapValueDownButton(with: sender.tag)
    }
    
    @IBAction func valueUpButtonPressed(_ sender: UIButton) {
        delagate?.didTapValueUpButton(with: sender.tag)
    }
}
