//
//  TitleCollectionViewCell.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/21/24.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell";
     
    private let posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.sd_cancelCurrentImageLoad()
        posterImageView.image = nil
    }
    public func configure(with model:String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w185\(model)")else {return}
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
