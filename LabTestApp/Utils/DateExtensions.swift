//
//  DateExtensions.swift
//  LabTestApp
//
//  Created by Anna Zamora on 26/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import UIKit

extension Date {
    func dateString(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
