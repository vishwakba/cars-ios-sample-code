//
//  CIDataCell.swift
//  cars-ios-interview
//
//  Created by Vishwak on 21/03/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit
import SDWebImage

class CIDataCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var shortDescription: UILabel!
    
    @IBOutlet weak var aImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCellWithData(_ data: [String:Any]?) {
        self.aImageView?.image = UIImage(named: "api_registration.png")
        
        if let imageEntities: [Any] = data!["imageEntities"] as? [Any] {
            let aImageEntity:[String:Any] = imageEntities[0] as! [String : Any]
            let largeImage = aImageEntity["largeImage"]
            self.aImageView?.sd_setImage(with: URL(string: largeImage as! String), placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), completed: { _, _, _, _ in
            })

        }
        if let aName = data!["name"] as? String {
            self.name?.text = aName
        }
        
        if let aDescription = data!["shortDescription"] as? String {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: (aDescription.html2AttributedString)!)
            self.shortDescription?.attributedText = attributedString
        }
    }
}
