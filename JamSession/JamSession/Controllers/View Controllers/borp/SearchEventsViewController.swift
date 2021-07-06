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
        kyboardDissapear()
        searchBar.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        searchBar.inputAccessoryView = toolBar
        getThings(searchText: "") {
            //self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getThings(searchText: ""){}
    }
    
    //MARK: tavle biew data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pulledEvents.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "borpCell") as? EventTableViewCell else {
            return UITableViewCell()}
        cell.event = pulledEvents[indexPath.row]
        let gest = UIGestureRecognizer(target: self, action: #selector(tapped))
        cell.addGestureRecognizer(gest)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "borp", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "quickLook") as? EventQuickLookViewController else {
            return}
        vc.event = pulledEvents[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
    //MARK: search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            pulledEvents = []
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return}
        
        
        //step one get document
        getThings(searchText: searchText){}
        
    }
    func getThings(searchText: String, completion: @escaping()->Void){
        if !(searchText.isEmpty){
            EventController.sharedInstance.fetchDocuments(term: searchText) { complete in
                DispatchQueue.main.async {
                    switch complete{
                    case true:
                        EventController.sharedInstance.docsToEvents { events in
                            self.pulledEvents = events
                            self.tableView.reloadData()
                            completion()
                        }
                    case false:
                        print("false")
                    }
                }
            }
        }else{
            EventController.sharedInstance.fetchDocuments() { complete in
                DispatchQueue.main.async {
                    switch complete{
                    case true:
                        EventController.sharedInstance.docsToEvents { events in
                            self.pulledEvents = events
                            self.tableView.reloadData()
                            completion()
                        }
                    case false:
                        print("false")
                    }
                }
            }
        }
    }
    @objc func tapped(){
        print("t")
    }
    func kyboardDissapear() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func didTapDone() {
        searchBar.resignFirstResponder()
    }
}// End of class

