//
//  TitlePreviewViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 6/10/24.
//

import UIKit
import WebKit
import MBProgressHUD

protocol TitlePreviewViewControllerDelegate: AnyObject{
    func downloadMovie(title: String, type: String)
}

class TitlePreviewViewController: UIViewController {
    
    var delegate: TitlePreviewViewControllerDelegate?
    var titleMovie = ""
    var type = ""
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let overviewLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "Hi my name ahmed liaqat how are you doing im fine thank you aur sunao kia chal rha ha mein bhi thek hon tumhari job kesi ha sab set ha"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let webView: WKWebView = {
       let view = WKWebView()
        view.isOpaque = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var downloadButton:UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        view.addSubview(webView)
        addConstraints()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .systemBackground
    }
    private func addConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with model: TitlePreviewViewModel){
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId ?? "")")else {return}
        webView.load(URLRequest(url: url))
        downloadButton.isHidden = model.downloadButtonHidden ?? false
        titleMovie = model.title
        type = model.type
        
        
    }
    @objc func downloadTapped(){
        downloadButton.isHidden = true
        delegate?.downloadMovie(title: titleMovie, type: type)
        
    }
}

