//
//  MovieDetailPosterViewCell.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
class MovieDetailPosterViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(posterPath: String?, imageConfig: ImageConfiguration) {
        posterImageView.image = nil
        //post the images of the movies on the listing view
        if let baseUrl = imageConfig.secureBaseUrl, let pathUrl = posterPath {
            let completeUrl = baseUrl + "w500" + pathUrl
            posterImageView.sd_setImage(with: URL(string: completeUrl)!, completed: nil)
        }
    }
}
