//
//  FooterForTabBar.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/22/24.
//

import UIKit

class FooterForTabBar: UIView {

    private let netflixLogo:UIImageView = {
        let img = UIImageView(image: UIImage(named: "Netflix Long"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    private let textWithLogo:UILabel={
        let text = UILabel(frame: .zero)
        text.text = "Netflix.com"
        text.textColor = .red
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    private let textSubWithlogo: UILabel = {
        let text = UILabel(frame: .zero)
        text.text = "This is a clone app"
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private func applyConstraints(){
        let netflixLogoConstraints = [
                netflixLogo.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 5),
                netflixLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
                netflixLogo.widthAnchor.constraint(equalToConstant: 150),
                netflixLogo.heightAnchor.constraint(equalTo: heightAnchor)
            ]
        let textWithLogoConstraints = [
            textWithLogo.leadingAnchor.constraint(equalTo: netflixLogo.trailingAnchor, constant: 0),
            textWithLogo.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ]
        let textSubWithLogoConstraints = [
            textSubWithlogo.leadingAnchor.constraint(equalTo: netflixLogo.trailingAnchor, constant: 0),
            textSubWithlogo.topAnchor.constraint(equalTo: textWithLogo.bottomAnchor, constant: 0)
        ]
        
        let allConstraints = netflixLogoConstraints + textWithLogoConstraints + textSubWithLogoConstraints
            
            // Activate all constraints at once
            NSLayoutConstraint.activate(allConstraints)
        }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(netflixLogo)
        addSubview(textWithLogo)
        addSubview(textSubWithlogo)
        applyConstraints()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        netflixLogo.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

}
