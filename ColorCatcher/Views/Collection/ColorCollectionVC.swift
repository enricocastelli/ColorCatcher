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
    
    @IBOutlet weak var gradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: String(describing: ColorCollectionCell.self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        configureBarForCollection()
    }
    
    func hasColorIndex(_ index: Int) -> Bool {
        return retrieveLevel() > index
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        velocity.y > 0 ? hideBar() : showBar()
    }
    
    private func hideBar() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.barView?.alpha = 0
        }, completion: nil)
    }
    
    private func showBar() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.barView?.alpha = 1
        }, completion: nil)
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
        let color = ColorManager.shared.colors[indexPath.row]
        showPopup(titleString: color.name, message: color.desc
            , button: "Ok", color: UIColor(hex: color.hex))
    }
}