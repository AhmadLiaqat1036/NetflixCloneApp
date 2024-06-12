//
//  UpcomingTitleTableViewCell.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/24/24.
//

import UIKit

class UpcomingTitleTableViewCell: UITableViewCell {
    
    static let identifier = "UpcomingTitleTableViewCell"
    private let playButton:UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        return button
    }()
    private let image:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let titleLabel:UILabel = {
        let title = UILabel()
        title.text = "Hi my name ahmed liaqat how are you doing im fine thank you aur sunao kia chal rha ha mein bhi thek hon tumhari job kesi ha sab set ha"
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private let subTitleLabel:UILabel = {
        let sub = UILabel()
        sub.text = "Hi my name ahmed liaqat how are you doing im fine thank you aur sunao kia chal rha ha mein bhi thek hon tumhari job kesi ha sab set ha"
        sub.font = .systemFont(ofSize: 12, weight: .light)
        sub.numberOfLines = 3
        sub.translatesAutoresizingMaskIntoConstraints = false
        return sub
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(image)
        contentView.addSubview(playButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        applyConstraints()
    }
    private func applyConstraints(){
        let imageConstraints = [
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            image.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -30),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        ]
        let subTitleLabelConstraints = [
            subTitleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            subTitleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -30),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ]
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalToConstant: 35),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(subTitleLabelConstraints)
    }
    public func configure(with model: MovieViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w185\(model.posterPath)") else{return}
        image.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.title
        subTitleLabel.text = model.description
        
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
