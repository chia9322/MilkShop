import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var openingHoursLabel: UILabel!
    
    @IBOutlet var addressImageView: UIImageView! {
        didSet {
            addressImageView.image = UIImage(named: "place")?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var openingHoursImageView: UIImageView! {
        didSet {
            openingHoursImageView.image = UIImage(named: "time")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
