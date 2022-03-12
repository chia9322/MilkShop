import UIKit

class SearchStoreTableViewController: UITableViewController {
    
    var filteredStores: [Store] = allStores

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add search controller
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false   // keep showing search bar when scrolling
        searchController.searchResultsUpdater = self
        
        getAllStoreData()
        // show all stores information as default
        filteredStores = allStores
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchStoreTableViewCell", for: indexPath)
        let store = filteredStores[indexPath.row]
        cell.textLabel?.text = store.name
        return cell
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCartInfoTableView" {
            let controller = segue.destination as! CartInfoTableViewController
            let store = filteredStores[tableView.indexPathForSelectedRow!.row]
            controller.store = store.name
        }
    }
}

extension SearchStoreTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                filteredStores = allStores.filter({ store in
                    let isContainedInName = store.name.localizedStandardContains(searchText)
                    let isContainedInAddress = store.address.localizedStandardContains(searchText)
                    if isContainedInName || isContainedInAddress {
                        return true
                    } else {
                        return false
                    }
                })
            } else {
                filteredStores = allStores
            }
            tableView.reloadData()
        }
    }
}



