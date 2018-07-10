//
//  Category.swift
//  LabTestApp
//
//  Created by Anna Zamora on 26/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ArticleCategory {
    let title: String
    let id: String
}

extension ArticleCategory {
    static func fromJSON(jsonObject: JSON) -> ArticleCategory? {
        guard let title = jsonObject["webTitle"].string,
            let id = jsonObject["id"].string
            else {
                log.warning("invalid category JSON format")
                return nil
        }
        return ArticleCategory(title: title, id: id)
    }
}
