//
//  UIView+Additions.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

extension UIView {
    func addGradient(colors: [CGColor], locations: [NSNumber], cornerRadius: CGFloat) {
        let layer = CAGradientLayer()
        layer.colors = colors
        layer.locations = locations
        layer.cornerRadius = cornerRadius
        layer.type = CAGradientLayerType.axial
        layer.frame = self.bounds
        self.layer.insertSublayer(layer, at: 0)
    }
}

extension UITableView {
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView(style: .gray)
        loadingFooter.frame.size.height = 50
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 50
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
    
}
