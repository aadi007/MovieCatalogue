//
//  MovieFilterView.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class MovieFilterView: UIView {
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var minYearTextField: UITextField!
    @IBOutlet weak var maxYearTextField: UITextField!
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MovieFilterView", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        } else {
            return UIView()
        }
    }

    @IBAction func filterButtonTapped(_ sender: Any) {
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
}
