//
//  SearchBarViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/28/24.
//

import UIKit
protocol ResultViewControllerDelegate: AnyObject{
    func resultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}
class ResultViewController: UIViewController {
    
    var movies = [Movie]()
   
    public weak var delegate: ResultViewControllerDelegate?
    let searchCollectionView:UICollectionView={
       let layout = UICollectionViewFlowLayout()
        layout.itemSize=CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()
    let NoResultLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "No results found"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchCollectionView)
        view.addSubview(NoResultLabel)
        whatToShow()
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
        NoResultLabel.frame = view.bounds
    }
    func applyContraints(){
        NSLayoutConstraint.activate([
            NoResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NoResultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    func whatToShow(){
        if movies.isEmpty{
            searchCollectionView.isHidden = true
            NoResultLabel.isHidden = false
        }else{
            searchCollectionView.isHidden = false
            NoResultLabel.isHidden = true
        }
    }
}

extension ResultViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        let movie = movies[indexPath.row]
        cell.configure(with: movie.posterPath ?? "")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = movies[indexPath.row]
        APICaller.shared.getMovies(with: title.title) { [weak self] result in
            switch result{
            case .success(let videoElement):
                self?.delegate?.resultViewControllerDidTapItem(TitlePreviewViewModel(title: title.title, overview: title.overview, youtubeView: videoElement))
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
}
