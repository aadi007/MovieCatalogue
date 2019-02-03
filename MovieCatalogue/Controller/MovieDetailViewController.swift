//
//  MovieDetailViewController.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import MBProgressHUD
final class MovieDetailViewController: UIViewController {
    var movieId: Double!
    var imageConfig: ImageConfiguration!
    private var viewModel: MovieDetailViewModel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailViewModel(networkProvider: AppProvider.networkManager)
        self.navigationItem.title = "Movie Detail"
        self.tableView.separatorStyle = .none
        self.fetchDetails()
    }
    func fetchDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.fetchMovieDetails(id: movieId) {[weak self] (errorMessage) in
            guard let `self` = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorMessage != nil {
                self.displayErrorAlert(errorMessage: errorMessage ?? "Unknown Error")
            } else {
                self.tableView.reloadData()
            }
        }
    }
}
extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieDetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = viewModel.movieDetail[indexPath.row]
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailPosterViewCell", for: indexPath) as? MovieDetailPosterViewCell {
                cell.configure(posterPath: value as? String, imageConfig: imageConfig)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MoveiDetailInfoViewCell", for: indexPath) as? MoveiDetailInfoViewCell {
                let title = viewModel.movieDisplayTitle[indexPath.row]
                cell.configure(title: title, value: value)
                return cell
            }
        }
        return UITableViewCell()
    }
}

