//
//  ViewController.swift
//  ContextMenuInCollectionView
//
//  Created by CDI on 8/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    let imageNames = Array(1...6).map { "image\($0)" }
    
    var favorites = [Int]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }


}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/2)-4, height: (view.frame.size.width/2)-4)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let open = UIAction(
                    title: "Open",
                    image: UIImage(systemName: "link"),
                    identifier: nil,
                    discoverabilityTitle: nil,
                    state: .off) { action in
                        print("tapped open \(self?.imageNames[indexPath.row] ?? "-")")
                    }
                
                let favorite = UIAction(
                    title: self?.favorites.contains(indexPath.row) == true ? "Remove Favorite" : "Favorite",
                    image: UIImage(systemName: self?.favorites.contains(indexPath.row) == true ? "star" : "star.fill"),
                    identifier: nil,
                    discoverabilityTitle: nil,
                    state: .off) { _ in
                        if self?.favorites.contains(indexPath.row) == true {
                            self?.favorites.removeAll(where: { $0 == indexPath.row })
                        } else {
                            self?.favorites.append(indexPath.row)
                        }
                        print("tapped favorite \(self?.imageNames[indexPath.row] ?? "-")")
                    }
                
                let search = UIAction(
                    title: "Search",
                    image: UIImage(systemName: "magnifyingglass"),
                    identifier: nil,
                    discoverabilityTitle: nil,
                    state: .off) { _ in
                        print("tapped favorite \(self?.imageNames[indexPath.row] ?? "-")")
                    }
                
                return UIMenu(
                    title: "Actions",
                    image: nil,
                    identifier: nil,
                    options: UIMenu.Options.displayInline,
                    children: [open, favorite, search])
                
//                return UIMenu(
//                    title: "Option",
//                    subtitle: nil,
//                    image: nil,
//                    identifier: nil,
//                    options: UIMenu.Options.displayInline,
//                    children: [])
                
                
            }
        
        return config
    }
}




 
class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
