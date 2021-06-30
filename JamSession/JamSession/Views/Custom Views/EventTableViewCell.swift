//
//  EventTableViewCell.swift
//  JamSession
//
//  Created by Gavin Craft on 6/21/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    //MARK: outletty bois
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instrumentsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var event: Event?{
        didSet{
            titleLabel.text = event?.title
            instrumentsLabel.text = event?.instruments
            LocationManager.sharedInstance.getAddressFromLatLon(event!.location) { res in
                switch res{
                case .success(let address):
                    DispatchQueue.main.async {
                        self.locationLabel.text = address
                    }
                case .failure(let err):
                    print(err)
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let event = event{
            titleLabel.text = event.title
            instrumentsLabel.text = event.instruments
            LocationManager.sharedInstance.getAddressFromLatLon(event.location) { res in
                switch res{
                case .success(let address):
                    DispatchQueue.main.async {
                        self.locationLabel.text = address
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
