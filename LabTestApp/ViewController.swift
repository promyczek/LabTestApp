//
//  ViewController.swift
//  LabTestApp
//
//  Created by Anna Zamora on 22/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let connectionManager = ConnectionManager()
        connectionManager.articlesList(itemsLimit: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

