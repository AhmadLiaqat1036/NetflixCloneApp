//
//  CollectionViewTableViewCell.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/16/24.
//

import UIKit
import MBProgressHUD

protocol CollectionViewTableViewCellDelegate:AnyObject{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model :TitlePreviewViewModel)
    
    func hideHudInCollection()
    
    func showHudInCollection(_ message: String)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let  identifier = "CollectionViewTableViewCell"
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    var movies:[Movie] = [Movie]()
    var Tvs:[Tv] = [Tv]()
    var sectionInTableView:Int?
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collection.backgroundColor = .systemGray6
        return collection
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    required init?(coder:NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        collectionView.showsHorizontalScrollIndicator = false
    }
    public func configureMovie(with movies: [Movie]){
        self.movies=movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    public func configureTv(with Tvs: [Tv]){
        self.Tvs=Tvs
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    private func downloadMovieAt(indexPath: IndexPath, sectionNo: Int){
        switch sectionNo{
        case Sections.Popular.rawValue, Sections.Upcoming.rawValue, Sections.TrendingMovie.rawValue:
            DataPersistanceManager.shared.downloadMovieWith(model: movies[indexPath.row]) { result in
                switch result{
                case .success(()):
                    NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue, Sections.TopRated.rawValue:
            DataPersistanceManager.shared.downloadTvWith(model: Tvs[indexPath.row]) { result in
                switch result{
                case .success(()):
                    NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            print("Not able to identify movie or tv...")
        }
        
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionInTableView{
        case Sections.TrendingTv.rawValue, Sections.TopRated.rawValue:
            
            return Tvs.count
            //im putting the number of tv or movie from the array i get
        case Sections.Popular.rawValue, Sections.Upcoming.rawValue, Sections.TrendingMovie.rawValue:
            print("items:\(section)")
            
            return movies.count
        default:
            
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        switch sectionInTableView{
            case Sections.Popular.rawValue, Sections.Upcoming.rawValue, Sections.TrendingMovie.rawValue:
                guard let pathMovie = movies[indexPath.row].posterPath else {return UICollectionViewCell()}
                cell.configure(with: pathMovie)
            case Sections.TrendingTv.rawValue, Sections.TopRated.rawValue:
                guard let pathTv = Tvs[indexPath.row].posterPath else {
                    return UICollectionViewCell()}
                cell.configure(with: pathTv)
            default:
                return UICollectionViewCell()
            }
        cell.backgroundColor = .purple
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showHudInCollection("")
        collectionView.deselectItem(at: indexPath, animated: true)
        let title :String
        let overview:String
        let type:String
        switch sectionInTableView{
        case Sections.Popular.rawValue, Sections.Upcoming.rawValue, Sections.TrendingMovie.rawValue:
            let movie = movies[indexPath.row]
            overview = movie.overview
            title = movie.title
            type = movie.mediaType ?? "movie"
        case Sections.TrendingTv.rawValue, Sections.TopRated.rawValue:
            let tv = Tvs[indexPath.row]
            overview = tv.overview
            title = tv.name
            type = tv.mediaType ?? "movie"
        default:
            title = ""
            overview = ""
            type = ""
        }
        APICaller.shared.getMovies(with: title + " trailer") { [weak self] result in
            switch result{
            case .success(let video):
               
                guard let strongSelf = self else {return}
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, model: TitlePreviewViewModel(title: title, overview: overview, youtubeView: video, downloadButtonHidden: true, type: type))
                DispatchQueue.main.async{
                    self?.delegate?.hideHudInCollection()
                }
            case .failure(let error):
                print(error.localizedDescription)
                }
            }
        }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else {
            return nil // No index path available
        }

        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] _ in
            let downloadAction = UIAction(title: "Download") { _ in
                self?.downloadMovieAt(indexPath: indexPath, sectionNo: self?.sectionInTableView ?? 0)
            }
            return UIMenu(options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
}
