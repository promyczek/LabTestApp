//
//  Article.swift
//  LabTestApp
//
//  Created by Anna Zamora on 22/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article: NSObject {
    let title: String
    let id: String
    let publicationDate: Date
    let sectionId: String
    let contentURL: String
    
    
    init(title: String,
         id: String,
         publicationDate: Date,
         sectionId: String,
         contentURL: String) {
        self.title = title
        self.id = id
        self.publicationDate = publicationDate
        self.sectionId = sectionId
        self.contentURL = contentURL
        super.init()
    }
}

extension Article {
    var formattedDateString: String {
        return publicationDate.dateString(withFormat: "HH:mm MM-dd-yyyy")
    }
}

extension Article {
    
    static func fromJSON(jsonObject: JSON) -> Article? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        guard let title = jsonObject["webTitle"].string,
            let id = jsonObject["id"].string,
            let dateString = jsonObject["webPublicationDate"].string,
            let publicationDate = dateFormatter.date(from: dateString),
            let sectionId = jsonObject["sectionId"].string,
            let contentURL = jsonObject["webUrl"].string
            else {
                log.warning("Invalid json format")
                return nil
        }
        
        return Article(title: title,
                       id: id,
                       publicationDate: publicationDate,
                       sectionId: sectionId,
                       contentURL: contentURL)
        
    }
    
}
