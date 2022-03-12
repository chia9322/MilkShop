import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet var drinkImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mSizeLabel: UILabel!
    @IBOutlet var lSizeLabel: UILabel!
    @IBOutlet var mPriceLabel: UILabel!
    @IBOutlet var lPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
