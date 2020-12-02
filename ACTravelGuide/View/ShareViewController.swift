//
//  ShareViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 5/30/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit



class ShareViewController: UIViewController {
    
  
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var ShareCollectionView: UICollectionView!
    var shareArray:[shareItem] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func shareButton(_ sender: Any) {
        let items = [scrollView.screenshot()]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    override func viewDidLoad() {
        load()
        super.viewDidLoad()
        
       let layout = ShareCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
               layout.itemSize = CGSize(width: 96, height: 128)
    //    ShareCollectionView.collectionViewLayout.collectionViewContentSize
    
    }
    
    private func load(){
        let shareItem1 = shareItem(name: "Knox", imageURL:  "https://acnhcdn.com/latest/NpcIcon/chn11.png")
        let shareItem2 = shareItem(name: "Apollo", imageURL:  "https://acnhcdn.com/latest/MenuIcon/Fish5.png")

        shareArray += [shareItem1]
        for _ in 0...10{
            
                shareArray += [shareItem2]
        }
    
    }
    
}


extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareCollectionViewCell", for: indexPath)
        if let label = cell.viewWithTag(101)as? UILabel{
            label.text = shareArray[indexPath.row].name
        }
        if let image = cell.viewWithTag(99)as? UIImageView{
            image.kf.setImage(with: URL(string: shareArray[indexPath.row].imageURL))
        }
        return cell
    }

}

fileprivate extension UIScrollView {
    func screenshot() -> UIImage? {
        let savedContentOffset = contentOffset
        let savedFrame = frame

        UIGraphicsBeginImageContext(contentSize)
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        contentOffset = savedContentOffset
        frame = savedFrame

        return image
    }
}
