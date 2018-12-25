//
//  CardCommentsCountCell.swift
//  cards
//
//  Created by Gaurang Lathiya on 24/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

class CardCommentsCountCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var viewSeperator: UIView!
    
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
        self.lblCommentCount.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblCommentCount.text = nil
    }
    
    func updateUI() {
        var counts = 0
        if let arrComment = self.cardDetailObj.comments {
            counts  = arrComment.count
        }
        
        if counts > 0 {
            self.lblCommentCount.text = "View Comments(\(counts))"
        } else {
            self.lblCommentCount.text = "No comments available"
        }
        
    }

}
