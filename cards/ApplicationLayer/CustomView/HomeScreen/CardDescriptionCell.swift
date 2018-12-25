//
//  CardDescriptionCell.swift
//  cards
//
//  Created by Gaurang Lathiya on 24/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

class CardDescriptionCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    var cardDetailObj: CardDetail! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.viewContainer.backgroundColor = UIColor.white
        self.lblDescription.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblDescription.text = nil
    }
    
    func updateUI() {
        self.lblDescription.text = self.cardDetailObj.message ?? ""
    }

}
