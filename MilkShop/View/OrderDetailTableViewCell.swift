import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var drinkImageView: UIImageView!
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var drinkDetailLabel: UILabel!
    @IBOutlet var numberOfCupLabel: UILabel!
    
    @IBOutlet var viewTopContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
