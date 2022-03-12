import UIKit

class OrderTableVIewCell: UITableViewCell {
    
    @IBOutlet var storeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
