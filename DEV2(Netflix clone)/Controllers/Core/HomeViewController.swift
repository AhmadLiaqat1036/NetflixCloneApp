//
//  HomeViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/16/24.
//

import UIKit


enum Sections: Int{
    case TrendingMovie = 0,
    TrendingTv = 1, TopRated = 2,
    Popular = 3, Upcoming = 4
}
class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Movie?
    private var headerView:HeroTabBarHeaderview?
    
    let sectionTitles = ["Trending movie","Trending TV", "Top Rated", "Popular", "Upcoming"]

    private let hometableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(hometableView)
        hometableView.delegate = self
        hometableView.dataSource = self
        configureNavBar()
        headerView = HeroTabBarHeaderview(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 490))
        hometableView.tableHeaderView = headerView
        hometableView.tableFooterView = FooterForTabBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height:70))
        configureHeaderView()
    }
    private func configureHeaderView(){
        APICaller.shared.getTrending { [weak self] result in
            switch result{
            case .success(let movies):
                let movie = movies.randomElement()
                self?.randomTrendingMovie = movie
                self?.headerView?.configure(with: MovieViewModel(posterPath: movie?.posterPath ?? "", title: movie?.title ?? "", description: movie?.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    private func configureNavBar(){
        var image = UIImage(named: "netflix")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: .none)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: nil, action: .none),
            UIBarButtonItem(image: UIImage(systemName: "play.circle"), style: .done, target: nil, action: .none)
        ]
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hometableView.frame = view.bounds
        hometableView.showsVerticalScrollIndicator = false
    }

    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        cell.sectionInTableView = indexPath.section
        switch indexPath.section{
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedTv { result in
                switch result{
                case .success(let Tv):
                    cell.configureTv(with: Tv)
                case .failure(_):
                   
                    print(APIErrors.failedToGetData)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv{ result in
                switch result{
                case .success(let Tv):
                    cell.configureTv(with: Tv)
                case .failure(_):
                  
                    print(APIErrors.failedToGetData)
                }
            }
        case Sections.TrendingMovie.rawValue:
            APICaller.shared.getTrending { result in
                switch result{
                case .success(let Movie):
                    cell.configureMovie(with: Movie)
                case .failure(_):
                    print(APIErrors.failedToGetData)
                }
            }
            break
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result{
                case .success(let Movie):
                    cell.configureMovie(with: Movie)
                case .failure(_):
                    print(APIErrors.failedToGetData)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .success(let movie):
                    cell.configureMovie(with: movie)
                case .failure(_):
                    print(APIErrors.failedToGetData)
                    
                }
            }
            
        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalizeEveryWord()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}

extension HomeViewController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, model: TitlePreviewViewModel) {
        DispatchQueue.main.async{ [weak self] in
            let vc = TitlePreviewViewController()
            
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
#Preview("HomeViewController") {
    var controller = HomeViewController()
    return controller
}
