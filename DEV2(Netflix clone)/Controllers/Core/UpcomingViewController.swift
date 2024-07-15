//
//  UpcomingViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/16/24.
//

import UIKit
import MBProgressHUD

class UpcomingViewController: UIViewController {
    private var movies = [Movie]()

    private let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UpcomingTitleTableViewCell.self, forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromAPI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        navigationController?.navigationBar.tintColor = .black
        
    }
    private func fetchDataFromAPI(){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure( _):
                print(APIErrors.failedToGetData)
            }
        }
    }

}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTitleTableViewCell.identifier, for: indexPath) as? UpcomingTitleTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
       
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(posterPath: movie.posterPath ?? "", title: movie.title, description: movie.overview, index: indexPath))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHud("")
        tableView.deselectRow(at: indexPath, animated: true)
        let title = movies[indexPath.row]
        
        APICaller.shared.getMovies(with: title.title) { [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.delegate = self
                    vc.configure(with: TitlePreviewViewModel(title: title.title, overview: title.overview, youtubeView: videoElement, downloadButtonHidden: false, type: title.mediaType ?? "movie"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.hideHUD()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension UpcomingViewController: TitlePreviewViewControllerDelegate{
    func downloadMovie(title: String, type: String) {
        if type == "movie"{
            guard let movie = movies.first(where: { m in
                m.title == title
            }) else {return}
            DataPersistanceManager.shared.downloadMovieWith(model: movie) { result in
                switch result{
                case .success(()):
                    NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
extension UpcomingViewController {
    func showHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.animationType = .zoom
        hud.contentColor = .systemRed
        hud.bezelView.layer.cornerRadius = 40
        hud.isUserInteractionEnabled = true
        hud.isMultipleTouchEnabled = false
        hud.backgroundColor = .black.withAlphaComponent(0.3)
    }

    func hideHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
extension UpcomingViewController: UpcomingTitleTableViewCellDelegate{
    func watchButtonTapped(index:IndexPath) {
        print("inside delagate func")
        showHud("")
        let title = movies[index.row]
        APICaller.shared.getMovies(with: title.title) { [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = WatchViewController()
                    vc.configure(with: TitlePreviewViewModel(title: title.title, overview: title.overview, youtubeView: videoElement, downloadButtonHidden: false, type: title.mediaType ?? "movie"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.hideHUD()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
