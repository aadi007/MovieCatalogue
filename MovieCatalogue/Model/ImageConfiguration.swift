//
//  ImageConfiguration.swift
//  MovieCatalogue
//
//  Created by Aadesh Maheshwari on 2/2/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import ObjectMapper

class ImageConfiguration: Mappable {
    var baseurl: String?
    var secureBaseUrl: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        self.baseurl      <- map["base_url"]
        self.secureBaseUrl <- map["secure_base_url"]
    }
}
class ImageConfiApiResponse: Mappable {
    var imageConfig: ImageConfiguration?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        self.imageConfig     <- map["images"]
    }
}


