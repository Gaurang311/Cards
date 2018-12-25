//
//  CardImageCell.swift
//  cards
//
//  Created by Gaurang Lathiya on 24/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit
import Kingfisher

class CardImageCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
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
        self.imgView.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
    }
    
    func updateUI() {
        if let strURL = self.cardDetailObj.image, let urlImg = URL(string: strURL) {
            let resource = ImageResource(downloadURL: urlImg)
            let imgSize = CGSize(width: Constants.SCREEN_SIZE.size.width, height: Constants.SCREEN_SIZE.size.width)
            let processor = ResizingImageProcessor.init(referenceSize: imgSize, mode: .aspectFill)
            self.imgView.kf.indicatorType = .activity
            self.imgView.kf.setImage(with: resource,
                                     placeholder: nil,
                                     options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
            ], progressBlock: nil) { result in
                // we can handle the failure
            }
        } else {
            self.imgView.image = nil
        }
    }
}
