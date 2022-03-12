import UIKit

class StoreViewController: UIViewController {
    
    let areaList: [String: [String]] = [
        "北部": ["臺北", "新北", "桃園", "新竹", "宜蘭", "基隆"],
        "中部": ["苗栗", "臺中", "彰化", "南投", "雲林"],
        "南部": ["嘉義", "臺南", "高雄", "屏東"],
        "其他": ["花蓮", "臺東", "金門"]
    ]
    
    var stores: [Store] = []
    var currentAreaButton: UIButton?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var areaButtons: [UIButton]!
    
    @IBOutlet var locationButtons: [UIButton]!
    @IBOutlet var locationView: UIView!
    @IBOutlet var locationScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        changeButtonStatus(buttons: areaButtons, selectedButton: areaButtons[0])
        locationScrollView.isHidden = true
        
        getAllStoreData()
        stores = allStores
    }
    
    // MARK: - Location Button Pressed
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let location = sender.titleLabel!.text!
        getStores(location: location)
        changeButtonStatus(buttons: locationButtons, selectedButton: sender)
        
        let scrollLimit = locationScrollView.contentSize.width - locationScrollView.frame.width
        let xOffset = sender.center.x - locationScrollView.frame.width/2
        if xOffset < 0 {
            locationScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if xOffset > scrollLimit {
            locationScrollView.setContentOffset(CGPoint(x: scrollLimit, y: 0), animated: true)
        } else {
            locationScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        }
    }
    
    func getStores(location: String) {
        stores = []
        for store in allStores {
            if store.name.contains(location) {
                stores += [store]
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Area Button Pressed
    @IBAction func areaButtonPressed(_ sender: UIButton) {
        if sender == currentAreaButton {
            locationScrollView.isHidden.toggle()
        } else {
            locationScrollView.isHidden = false
            let area = sender.titleLabel!.text!
            if let locations = areaList[area] {
                for idx in 0..<locationButtons.count {
                    if idx <= locations.count-1 {
                        locationButtons[idx].isHidden = false
                        locationButtons[idx].setTitle(locations[idx], for: .normal)
                    } else {
                        locationButtons[idx].isHidden = true
                    }
                }
                let buttonWidth = locationButtons[0].frame.size.width
                let space: CGFloat = 10
                locationView.frame.size.width = max((CGFloat(locations.count) * (buttonWidth + space) + space), locationScrollView.frame.width)
                locationScrollView.contentSize = CGSize(width: locationView.frame.width, height: 0)
                locationScrollView.setContentOffset(CGPoint(x:0, y: 0), animated: false)
                changeButtonStatus(buttons: locationButtons, selectedButton: locationButtons[0])
                getStores(location: locations[0])
            }
            currentAreaButton = sender
        }
        changeButtonStatus(buttons: areaButtons, selectedButton: sender)
        
    }
    
    // MARK: - Change Button Status
    func changeButtonStatus(buttons: [UIButton], selectedButton: UIButton) {
        for button in buttons {
            button.configuration?.baseBackgroundColor = UIColor(named: "green1")
            button.configuration?.baseForegroundColor = UIColor(named: "green3")
        }
        selectedButton.configuration?.baseBackgroundColor = UIColor(named:"green3")
        selectedButton.configuration?.baseForegroundColor = .white
    }
    
}


// MARK: - Table View
extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StoreTableViewCell.self)", for: indexPath) as! StoreTableViewCell
        let store = stores[indexPath.row]
        cell.nameLabel.text = store.name
        cell.addressLabel.text = store.address
        cell.phoneLabel.text = store.phone
        cell.openingHoursLabel.text = store.openingHours
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mapUrl = stores[indexPath.row].mapUrl {
            UIApplication.shared.open(mapUrl)
        }
    }
    
    
}
