//
//  WatchViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 7/15/24.
//

import UIKit
import WebKit

class WatchViewController: UIViewController {

    private let webView: WKWebView = {
       let view = WKWebView()
        view.isOpaque = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(webView)
        addConstraints()
    }
    

    private func addConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
    }
    func configure(with model: TitlePreviewViewModel){
        navigationController?.title = model.title
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId ?? "")")else {return}
        webView.load(URLRequest(url: url))

        
    }
}
