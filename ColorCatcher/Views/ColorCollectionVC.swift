//
//  ColorCollectionVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 01/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

private let reuseIdentifier = "colorCollectionCell"

class ColorCollectionVC: UIViewController, StoreProvider {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: String(describing: ColorCollectionCell.self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func hasColorIndex(_ index: Int) -> Bool {
        return retrieveLevel() > index
    }
    
}

extension ColorCollectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorManager.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorCollectionCell
        let color = ColorManager.colors[indexPath.row]
        cell.color = hasColorIndex(indexPath.row) ? color : nil
        return cell
    }
    
}

extension ColorCollectionVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard hasColorIndex(indexPath.row) else { return }
        print(ColorManager.colors[indexPath.row].desc)
    }

}
