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
