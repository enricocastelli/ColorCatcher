//
//  ColorCollectionVC.swift
//  ColorCatcher
//
//  Created by Enrico Castelli on 01/03/2019.
//  Copyright © 2019 Enrico Castelli. All rights reserved.
//

import UIKit

private let reuseIdentifier = "colorCollectionCell"

class ColorCollectionVC: ColorController, AlertProvider {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: String(describing: ColorCollectionCell.self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        configureBarForCollection()
    }
    
    func hasColorIndex(_ index: Int) -> Bool {
        return retrieveColorCatched().index > index
    }
}

extension ColorCollectionVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorManager.shared.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorCollectionCell
        let color = ColorManager.shared.colors[indexPath.row]
        cell.color = hasColorIndex(indexPath.row) ? color : nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let colorCell = cell as? ColorCollectionCell else { return }
        colorCell.animateShowing()
    }
    
    
    func didDismissPopup() {
        
    }
}

extension ColorCollectionVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard hasColorIndex(indexPath.row) else { return }
        let catched = retrieveColorCatched().catched[indexPath.row]
        let color = ColorManager.shared.colors[indexPath.row]
        var model = PopupModel(titleString: color.name, message: color.desc)
        model.color = UIColor(hex: color.hex)
        let subtitleString: String = {
            var str = "Catched \(catched.date.string)"
            if let loc = catched.location {
                str.append(contentsOf: " in \(loc)")
            }
            return str
        }()
        model.subtitleString = subtitleString
        showPopup(model)
    }
}
