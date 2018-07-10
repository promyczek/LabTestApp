//
//  ArticleMock.swift
//  LabTestAppTests
//
//  Created by Anna Zamora on 26/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Foundation
@testable import LabTestApp

extension Article {
    static var defaultDate: Date {
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar, year: 2018, month: 2, day: 26)
        return calendar.date(from: dateComponents)!
    }
    
    class func mock(title: String = "title",
              id: String = "id",
              publicationDate: Date = defaultDate,
              sectionId: String = "sectionId",
              contentURL: String = "URL") -> Article {
        return Article(title: title,
                       id: id,
                       publicationDate: publicationDate,
                       sectionId: sectionId,
                       contentURL: contentURL)
    }
    
}
