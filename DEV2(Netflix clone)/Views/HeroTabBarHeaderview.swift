//
//  HeroTabBarHeaderview.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/17/24.
//

import UIKit
import SDWebImage
class HeroTabBarHeaderview: UIView {
//hello test commit
    let heroImageView: UIImageView = {
        
       let image = UIImageView()
        image.image = UIImage(named: "kingkong")
    
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let backgroundImage: UIView = {
       let back = UIView()
        back.backgroundColor = .systemGray3
        return back
    }()
    
    private func addGradient(){
        let gradient = CAGradientLayer()
        gradient.colors=[
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    private let playButton = {
     let pButton = UIButton()
        pButton.setTitle("Play", for: .normal)
        pButton.titleLabel?.font = .systemFont(ofSize: 16,weight: .medium)
        pButton.setTitleColor(.black.withAlphaComponent(0.8), for: .normal)
        pButton.backgroundColor = .quaternarySystemFill
        pButton.layer.borderColor = UIColor.black.cgColor
        pButton.layer.borderWidth = 1
        pButton.layer.cornerRadius = 4
        pButton.translatesAutoresizingMaskIntoConstraints = false
        return pButton
    }()
    private let downloadButton = {
     let pButton = UIButton()
        pButton.setTitle("Download", for: .normal)
        pButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        pButton.setTitleColor(.black.withAlphaComponent(0.8), for: .normal)
        pButton.backgroundColor = .quaternarySystemFill
        pButton.layer.borderColor = UIColor.black.cgColor
        pButton.layer.borderWidth = 1
        pButton.layer.cornerRadius = 4
        pButton.translatesAutoresizingMaskIntoConstraints = false
        return pButton
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImage)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    public func configure(with model: MovieViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w185\(model.posterPath)") else {
            print("url not correct")
            return}
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    private func applyConstraints(){
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 35)
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            downloadButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 35)
        ]
        let heroImageConstraints = [
            heroImageView.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 20),
            heroImageView.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -20),
            heroImageView.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 30),
            heroImageView.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -3),
            heroImageView.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -3)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(heroImageConstraints)
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImage.frame = bounds
//        heroImageView.frame = bounds
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

}
