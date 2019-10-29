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
    var oldY: CGFloat  = 0
    var barHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: String(describing: ColorCollectionCell.self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: reuseIdentifier)
        configureBarForCollection()
    }
    
    func hasColorIndex(_ index: Int) -> Bool {
        return retrieveLevel() > index
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > oldY {
            hideBar()
        } else {
            showBar()
        }
        if offsetY > 0 && offsetY < 553 {
            oldY = scrollView.contentOffset.y
        }
    }
    
    private func hideBar() {
        guard barHidden == false else { return }
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.barView?.alpha = 0
        }, completion: { (done) in
            self.barHidden = true
        })
    }
    
    private func showBar() {
        guard barHidden == true else { return }
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.barView?.alpha = 1
        }, completion: { (done) in
            self.barHidden = false
        })
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
