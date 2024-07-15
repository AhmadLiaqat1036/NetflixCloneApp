//
//  HeroTabBarHeaderview.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/17/24.
//

import UIKit
import SDWebImage
protocol HeroTabBarHeaderviewDelegate: AnyObject{
    func playButtontapped(title: String)
    func showHUDForHeaderDownload(_ message: String)
    func dismissHUDForHeaderDownload()
    func pushVC(vc: TitlePreviewViewController)
}
class HeroTabBarHeaderview: UIView {
    var delegate: HeroTabBarHeaderviewDelegate?
    var movie: Movie?
    let heroImageView: UIImageView = {
        
       let image = UIImageView()
        image.image = UIImage(named: "kingkong")
    
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.layer.borderWidth=1
        image.layer.borderColor = UIColor.opaqueSeparator.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let backgroundImage: UIView = {
       let back = UIView()
        back.backgroundColor = .systemGray6
        return back
    }()
    
    private func addGradient(){
        let gradient = CAGradientLayer()
        gradient.colors=[
            UIColor.clear.cgColor,
            UIColor.systemFill.cgColor,
            UIColor.systemGray6.cgColor
        ]
        
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var playButton = {
     let pButton = UIButton()
        pButton.setTitle("Play", for: .normal)
        pButton.titleLabel?.font = .systemFont(ofSize: 16,weight: .medium)
        pButton.setTitleColor(.black.withAlphaComponent(0.8), for: .normal)
        pButton.backgroundColor = .quaternarySystemFill
        pButton.layer.borderColor = UIColor.black.cgColor
        pButton.layer.borderWidth = 1
        pButton.layer.cornerRadius = 4
        pButton.translatesAutoresizingMaskIntoConstraints = false
        pButton.addTarget(self, action: #selector(watchButton), for: .touchUpInside)
        return pButton
    }()
    private lazy var downloadButton = {
     let pButton = UIButton()
        pButton.setTitle("Download", for: .normal)
        pButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        pButton.setTitleColor(.black.withAlphaComponent(0.8), for: .normal)
        pButton.backgroundColor = .quaternarySystemFill
        pButton.layer.borderColor = UIColor.black.cgColor
        pButton.layer.borderWidth = 1
        pButton.layer.cornerRadius = 4
        pButton.translatesAutoresizingMaskIntoConstraints = false
        pButton.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
        return pButton
    }()
    lazy var imagetap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        gesture.addTarget(self, action: #selector(imageTapped))
        return gesture
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImage)
        addSubview(heroImageView)
        addGradient()
        addGestureRecognizer(imagetap)
        addSubview(stackView)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(downloadButton)
        applyConstraints()
    }
    public func configure(with model: Movie){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w185\(model.posterPath ?? "")") else {
            print("url not correct")
            return}
        heroImageView.sd_setImage(with: url, completed: nil)
        movie = model
    }
    private func applyConstraints(){
//        let playButtonConstraints = [
//            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
//            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
//            playButton.widthAnchor.constraint(equalToConstant: 100),
//            playButton.heightAnchor.constraint(equalToConstant: 35)
//        ]
//        let downloadButtonConstraints = [
//            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
//            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
//            downloadButton.widthAnchor.constraint(equalToConstant: 100),
//            playButton.heightAnchor.constraint(equalToConstant: 35)
//        ]
        let heroImageConstraints = [
            heroImageView.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 50),
            heroImageView.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: -50),
            heroImageView.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 30),
            heroImageView.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -3),
            heroImageView.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -3)
        ]
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stackView.heightAnchor.constraint(equalToConstant: 35)
        ]
//        NSLayoutConstraint.activate(playButtonConstraints)
//        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(heroImageConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImage.frame = bounds
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc func watchButton(){
        delegate?.playButtontapped(title: movie?.title ?? "")
    }
    @objc func downloadButtonPressed(){
        downloadButton.isHidden = true
        delegate?.showHUDForHeaderDownload("Downloading")
        DataPersistanceManager.shared.downloadMovieWith(model: movie!) { result in
            switch result{
            case .success(()):
                NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.async{[weak self] in
            self?.delegate?.dismissHUDForHeaderDownload()
        }
    }
    @objc func imageTapped(){
        delegate?.showHUDForHeaderDownload("")
        
        APICaller.shared.getMovies(with: movie?.title ?? "") { [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: self?.movie?.title ?? "", overview: self?.movie?.overview ?? "", youtubeView: videoElement, downloadButtonHidden: true, type: self?.movie?.mediaType ?? "movie"))
                    self?.delegate?.pushVC(vc: vc)
                    
                   
                    self?.delegate?.dismissHUDForHeaderDownload()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
