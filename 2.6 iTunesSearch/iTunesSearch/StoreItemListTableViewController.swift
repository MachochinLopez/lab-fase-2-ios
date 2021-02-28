
import UIKit

class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    var storeItemController = StoreItemController()
    // update the items array to the [StoreItem] type
    var items = [StoreItem]()
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchMatchingItems() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            
            // set up query dictionary
            let queryDictionary = [
                "term": searchTerm,
                "media": mediaType,
                "limit": "10",
                "lang": "en_us"
            ]
            
            
            // use the item controller to fetch items
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise, print an error to the console
            storeItemController.fetchItems(matching: queryDictionary) { (result) in
                switch result {
                case .success(let storeItems):
                    self.items = storeItems
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        // set cell.titleLabel to the item's name
        cell.titleLabel.text = item.name
        // set cell.detailLabel to the item's artist
        cell.detailLabel.text = item.artist
        // set cell.itemImageView to the system image "photo"
        cell.itemImageView.image = UIImage(systemName: "photo")
        // initialize a network task to fetch the item's artwork
        let task = URLSession.shared.dataTask(with: item.artworkURL)
           { (data, response, error) in
            
            // if successful, use the main queue capture the cell, to initialize a UIImage, and set the cell's image view's image to the
            if let error = error {
                print(error)
            } else if let data = data {
                DispatchQueue.main.async {
                    cell.itemImageView.image = UIImage(data: data)
                }
            }
        }

        task.resume()
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}
