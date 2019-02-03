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
    private var backgroundView: UIView?
    private var filterView: MovieFilterView?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        viewModel = MovieListViewModel(networkProvider: AppProvider.networkManager)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.fetchConfig { [weak self] (errorMessage) in
            guard let `self` = self else { return }
            if errorMessage == nil {
                self.fetchMovies()
            } else {
                self.displayErrorAlert(errorMessage: errorMessage ?? "Unknown Error")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func fetchMovies() {
        self.viewModel.fetchMovies(completionHandler: { [weak self] (errorMessage) in
            guard let `self` = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            if errorMessage != nil {
                DispatchQueue.main.async(execute: {
                    self.displayErrorAlert(errorMessage: errorMessage ?? "Unknown Error")
                })
            } else {
                //reload the data
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.tableView.hideLoadingFooter()
                })
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "TMDB List"
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        if filterView == nil {
            addFilterView()
        }
    }
    func addFilterView() {
        backgroundView = UIView()
        backgroundView?.frame = self.view.frame
        backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(backgroundView!)
        //display the filter view
        filterView = MovieFilterView()
        filterView?.delegate = self
        filterView?.frame = CGRect(x: 0, y: self.navigationController?.navigationBar.frame.size.height ?? 44, width: self.view.bounds.width, height: 250)
        self.view.addSubview(filterView!)
    }
    func removeFilterView() {
        backgroundView?.removeFromSuperview()
        filterView?.removeFromSuperview()
        backgroundView = nil
        filterView = nil
    }
}
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.count - 1 && !viewModel.isLastPage() && !tableView.isLoadingFooterShowing() {
            tableView.showLoadingFooter()
            self.fetchMovies()
        }
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
        let movie = viewModel.movies[indexPath.row]
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            viewController.movieId = movie.id
            viewController.imageConfig = viewModel.imageConfig!
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
extension MovieListViewController: MovieFilterViewDelegate {
    func filterResult(minYear: Int, maxYear: Int) {
        self.removeFilterView()
        _ = viewModel.setfilterQuery(minyear: minYear, maxYear: maxYear)
        self.tableView.reloadData()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.fetchMovies()
    }
    func validationError(errorMessage: String) {
        displayErrorAlert(errorMessage: errorMessage)
    }
    func filterCancelViewPressed() {
        self.removeFilterView()
    }
}
