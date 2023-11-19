//
//  ViewContoller.swift
//  Concetration
//
//  Created by Admin on 02/11/2023.
//  Copyright © 2023 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.collectionViewLayout = configureLayout()
    }
    
    func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.size.width / 3 - 3 ,
                                 height: collectionView.frame.size.height / 3 - 3)
        layout.minimumInteritemSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        return layout
    }

}

//extension ViewController: UICollectionViewDelegate {
//
//}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)

        return cell
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
}
