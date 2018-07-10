//
//  CategoriesViewController.swift
//  LabTestApp
//
//  Created by Anna Zamora on 26/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerDelegate {
    func didChangeCategory()
}

private let reuseIdentifier = "Cell"

class CategoriesViewController: UICollectionViewController {
    
    let connectionManager: ConnectionManager
    let dataModel: DataModel
    var delegate: CategoriesViewControllerDelegate?
    
    init(connectionManager: ConnectionManager, dataModel: DataModel) {
        self.connectionManager = connectionManager
        self.dataModel = dataModel
        super.init(nibName: "CategoriesViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        let cellNib = UINib(nibName: "CategoryViewCell", bundle: nil)
        self.collectionView!.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)

        connectionManager.loadCategories(completionHandler: {
            self.collectionView?.reloadData()
            self.loadArticlesForSelectedCategory()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    func loadArticlesForSelectedCategory() {
        connectionManager.refreshArticlesList(dataModel.selectedCategoryId) {
            self.delegate?.didChangeCategory()
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.categories().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryViewCell
        let category = dataModel.categories()[indexPath.row]
        cell?.titleLabel.text = category.title
        return cell!
    }
    


    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = dataModel.categories()[indexPath.row]
        dataModel.selectedCategoryId = selectedCategory.id
        
        if selectedCategory.articles.isEmpty || selectedCategory.lastUpdate.timeIntervalSinceNow <= -0.1*60 {
            loadArticlesForSelectedCategory()
        } else {
            self.delegate?.didChangeCategory()
        }
    }
}
