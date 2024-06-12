//
//  UpcomingViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/16/24.
//

import UIKit

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
       
        let movie = movies[indexPath.row]
        cell.configure(with: MovieViewModel(posterPath: movie.posterPath ?? "", title: movie.title, description: movie.overview))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let title = movies[indexPath.row]
        
        APICaller.shared.getMovies(with: title.title) { [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: title.title, overview: title.overview, youtubeView: videoElement))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
