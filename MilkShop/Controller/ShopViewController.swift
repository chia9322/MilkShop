import UIKit

class ShopViewController: UIViewController {
    
    var drinkCategories: [DrinkCategory] = []
    
    var totalNumberOfCup: Int = 0
    var totalPrice: Int = 0
    
    var lastScrollViewOffsetY: CGFloat = 0

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var numberOfCupLabel: UILabel!
    @IBOutlet var cartButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCartButton()
        
        // Collection View
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        configureCellSize()
        
        // Categorize drinks
        categorizeDrinks()
    }
    
    
    // MARK: - Segue
    @IBSegueAction func showShopDetail(_ coder: NSCoder) -> ShopDetailViewController? {
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return ShopDetailViewController(coder: coder, drink: allDrinks[0])}
        let section = indexPath[0][0]
        let row = indexPath[0][1]
        let drink = drinkCategories[section].drinks[row]
        return ShopDetailViewController(coder: coder, drink: drink)
    }
    
    @IBAction func unwindToShopView(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func updateOrderDrink(_ segue: UIStoryboardSegue) {
        updateCartButton()
    }
    
    @IBAction func completeOrder(_ segue: UIStoryboardSegue) {
        orderDrinks = []
        updateCartButton()
    }
    
    // MARK: - Cart Button
    func updateCartButton() {
        totalNumberOfCup = 0
        totalPrice = 0
        for orderDrink in orderDrinks {
            totalNumberOfCup += orderDrink.numberOfCup
            totalPrice += orderDrink.numberOfCup * orderDrink.pricePerCup
        }
        cartButton.configuration?.title = "購物車 $\(totalPrice)"
        guard let customFont = UIFont(name: "jf-openhuninn-1.1", size: 20) else { return }
        cartButton.configuration?.attributedTitle?.font = customFont
        if totalNumberOfCup > 0 {
            numberOfCupLabel.isHidden = false
            numberOfCupLabel.text = "\(totalNumberOfCup)"
        } else {
            numberOfCupLabel.isHidden = true
        }
        
    }
    
    // MARK: - Minimize cart button when scrolling down
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastScrollViewOffsetY = scrollView.contentOffset.y
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > lastScrollViewOffsetY {
            cartButton.configuration?.title = ""
        } else {
            cartButton.configuration?.title = "購物車 $\(totalPrice)"
            guard let customFont = UIFont(name: "jf-openhuninn-1.1", size: 20) else { return }
            cartButton.configuration?.attributedTitle?.font = customFont
        }
    }
    
    // MARK: - Categorize drinks
    func categorizeDrinks() {
        
        let categories = ["嚼對推薦", "愛茶的牛", "牧場鮮奶茶", "綠光牧場鮮奶", "手作特調"]
        for category in categories {
            drinkCategories += [DrinkCategory(name: category, drinks: [])]
        }
        
        for drink in allDrinks {
            if let categoryIndex = categories.firstIndex(of: drink.category) {
                drinkCategories[categoryIndex].drinks += [drink]
            }
        }
    }
    
}

// MARK: - Collection View
extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ShopCollectionViewSectionHeader.self)", for: indexPath) as! ShopCollectionViewSectionHeader
        headerView.sectionNameLabel.text = "\(drinkCategories[indexPath.section].name)"
        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return drinkCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinkCategories[section].drinks.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ShopCollectionViewCell.self)", for: indexPath) as! ShopCollectionViewCell
        let drink = drinkCategories[indexPath.section].drinks[indexPath.row]
        cell.imageView.image = UIImage(named: drink.name)
        cell.nameLabel.text = drink.name
        return cell
    }
    
    
    func configureCellSize() {
        let itemSpace: CGFloat = 0
        let columnCount: CGFloat = 2
        let flowLayout = UICollectionViewFlowLayout()
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount)
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.estimatedItemSize = .zero           // 讓cell尺寸依據設定的itemSize顯示
        flowLayout.minimumInteritemSpacing = itemSpace // 設定cell左右間距
        flowLayout.minimumLineSpacing = itemSpace      // 設定上下間距
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 50) // 設定Section Header高度
        flowLayout.sectionHeadersPinToVisibleBounds = true // 滑動時讓SectionHeader浮在最上方
        collectionView.collectionViewLayout = flowLayout
    }
    
}
