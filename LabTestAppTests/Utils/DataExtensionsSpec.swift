//
//  DataExtensionsSpec.swift
//  LabTestAppTests
//
//  Created by Anna Zamora on 26/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Quick
import Nimble

@testable import LabTestApp

class DataExtensionsSpec: QuickSpec {
    
    override func spec() {
        describe("DataExtensions") {
            
            var date: Date!
            beforeEach {
                let calendar = Calendar.current
                let dateComponents = DateComponents(calendar: calendar, year: 2018, month: 2, day: 26)
                date = calendar.date(from: dateComponents)!
            }
            
            it ("should return properly formatted data string") {
                let stringDate = date.dateString(withFormat:"yyyy-MM-dd")
                expect(stringDate).to(equal("2018-02-26"))
                
            }
        }
    }
}
