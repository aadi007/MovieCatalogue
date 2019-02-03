//
//  MovieListViewCell.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListViewCell: UITableViewCell {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.addGradient(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.5).cgColor], locations: [0.0, 1.0], cornerRadius: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(movie: Movie, imageConfig: ImageConfiguration) {
        posterImageView.image = nil
        if let title = movie.title {
            movieTitle.text = title
        } else {
            movieTitle.text = ""
        }
        if let date = movie.releaseDate {
            releaseDate.text = date
        } else {
            releaseDate.text = ""
        }
        //post the images of the movies on the listing view
        if let baseUrl = imageConfig.secureBaseUrl, let pathUrl = movie.posterPath {
            let completeUrl = baseUrl + "w500" + pathUrl
            posterImageView.sd_setImage(with: URL(string: completeUrl)!, completed: nil)
        }
        popularityLabel.text = movie.popularity.description
        voteAverageLabel.text = movie.voteAverage.description
    }
}
