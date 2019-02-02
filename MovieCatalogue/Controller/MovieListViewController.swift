//
//  MovieListViewController.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import MBProgressHUD

final class MovieListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MovieListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        viewModel = MovieListViewModel(networkProvider: AppProvider.networkManager)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.fetchConfig { [weak self] (errorMessage) in
            guard let `self` = self else { return }
            if errorMessage == nil {
                //fetch the list data
                self.viewModel.fetchMovies(completionHandler: { [weak self] (errorMessage) in
                    guard let `self` = self else { return }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if errorMessage != nil {
                        //show the error Message
                    } else {
                        //reload the data
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                })
            } else {
               MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
    }

}
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListViewCell", for: indexPath) as? MovieListViewCell {
            let movie = viewModel.movies[indexPath.row]
            cell.configure(movie: movie, imageConfig: viewModel.imageConfig!)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
