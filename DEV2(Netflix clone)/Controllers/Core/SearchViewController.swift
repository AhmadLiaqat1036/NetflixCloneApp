//
//  SearchViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/16/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies = [Movie]()

    private let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UpcomingTitleTableViewCell.self, forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier)
        return table
    }()
    private let searchBar: UISearchController = {
       let controller = UISearchController(searchResultsController: ResultViewController())
        controller.searchBar.placeholder = "Search any Movie and TV Show"
        controller.searchBar.searchBarStyle = .minimal
        return controller

    
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemRed
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchSearchData()
        navigationItem.searchController = searchBar
        searchBar.searchResultsUpdater = self
        
    }
    private func fetchSearchData(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result{
            case.success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    func whatHappendToText(searchBar: UISearchBar, textDidChange searchText: String?) {
        if searchText == "" || searchText == nil {
            searchBar.setShowsCancelButton(false, animated: true)
        }else{
           
            searchBar.setShowsCancelButton(true, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        navigationController?.navigationBar.tintColor = .black
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTitleTableViewCell.identifier, for: indexPath) as? UpcomingTitleTableViewCell else {return UITableViewCell()}
        
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

extension SearchViewController: UISearchResultsUpdating, ResultViewControllerDelegate{
    func resultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, 
            !query.trimmingCharacters(in: .whitespaces).isEmpty,
            query.trimmingCharacters(in: .whitespaces).count > 3
        else {return}
        whatHappendToText(searchBar: searchBar, textDidChange: query)
        APICaller.shared.getSearchedResult(search: query) { results in
            switch results{
                
            case .success(let movies):
                //print(movies)
                DispatchQueue.main.async{
                    guard let moviesResultController = searchController.searchResultsController as? ResultViewController else { return }
                    moviesResultController.delegate = self
                    moviesResultController.movies = movies
                    
                    moviesResultController.searchCollectionView.reloadData()
                    moviesResultController.whatToShow()
                }
            case .failure(let error):
                print (error)
            }
        }
        
    }
}

