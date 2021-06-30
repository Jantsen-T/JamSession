//
//  SearchEventsViewController.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import UIKit

class SearchEventsViewController: UITableViewController, UISearchBarDelegate {
    //MARK: vars n outlest n shtuff
    var pulledEvents: [Event] = []
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: tavle biew data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pulledEvents.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "borpCell") as? EventTableViewCell else { return UITableViewCell()}
        cell.event = pulledEvents[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "borp", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "quickLook") as? EventQuickLookViewController else { return}
        vc.event = pulledEvents[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
    //MARK: search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return}
        
        
        //step one get document
        DispatchQueue.main.async {
            EventController.sharedInstance.fetchDocuments(term: searchText) { complete in
                switch complete{
                case true:
                    DispatchQueue.main.async {
                        EventController.sharedInstance.docsToEvents { events in
                            self.pulledEvents = events
                            self.tableView.reloadData()
                        }
                    }
                case false:
                    print("false")
                }
            }
        }
    }
}
