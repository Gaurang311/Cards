//
//  CommentCell.swift
//  cards
//
//  Created by Gaurang Lathiya on 25/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var commentsObj: Comments! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.viewContainer.backgroundColor = UIColor.white
        self.lblMessage.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblMessage.text = nil
    }
    
    func updateUI() {
        self.lblMessage.text = self.commentsObj.message ?? ""
    }
}
