//
//  MovieFilterView.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

protocol MovieFilterViewDelegate: class {
    func filterCancelViewPressed()
    func validationError(errorMessage: String)
    func filterResult(minYear: Int, maxYear: Int)
}

class MovieFilterView: UIView {
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var minYearTextField: UITextField!
    @IBOutlet weak var maxYearTextField: UITextField!
    var view: UIView!
    weak var delegate: MovieFilterViewDelegate?
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
    func validateInput() -> (Bool, String?) {
        if let minYearText = minYearTextField.text, minYearText.count == 4,
            let maxYearText = maxYearTextField.text, maxYearText.count == 4,
            let minYear = Int(minYearText),
            let maxYear = Int(maxYearText) {
            let date = Date()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: date)
            if maxYear < minYear {
                return (false, "MaxYear should not be greater than MinYear")
            } else if maxYear > currentYear {
                return (false, "MaxYear should not be greater than current year \(currentYear)")
            } else {
                return (true, nil)
            }
        } else {
            return (false, "Please enter proper year (Must be of four digit e.g 2014)")
        }
    }
    @IBAction func filterButtonTapped(_ sender: Any) {
        let result = validateInput()
        if !result.0 {
            delegate?.validationError(errorMessage: result.1!)
        } else {
            let minYear = Int(minYearTextField.text!)
            let maxYear = Int(maxYearTextField.text!)
            delegate?.filterResult(minYear: minYear!, maxYear: maxYear!)
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.filterCancelViewPressed()
    }
}
