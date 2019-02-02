//
//  MoveiDetailInfoViewCell.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class MoveiDetailInfoViewCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, value: Any) {
        var info = title
        if let valueText = value as? String {
            info += valueText
        } else if let valueDouble = value as? Double {
            info += valueDouble.description
        } else if let valueBool = value as? Bool {
            info += valueBool.description
        }
        infoLabel.text = info
    }
}
