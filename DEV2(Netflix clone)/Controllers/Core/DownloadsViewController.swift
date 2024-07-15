//
//  DownloadsViewController.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/16/24.
//

import UIKit
import MBProgressHUD

class DownloadsViewController: UIViewController {
    
    private var titles:[TitleItem] = [TitleItem]()
    private let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UpcomingTitleTableViewCell.self, forCellReuseIdentifier: UpcomingTitleTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromDatabase()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchDataFromDatabase()
        }
    }
    private func fetchDataFromDatabase(){
        DataPersistanceManager.shared.fetchTitlesFromDatabase { [weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTitleTableViewCell.identifier, for: indexPath) as? UpcomingTitleTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        let title = titles[indexPath.row]
        cell.configure(with: MovieViewModel(posterPath: title.poster_path ?? "", title: title.title ?? title.original_title ?? "", description: title.overview ?? "", index: indexPath))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            DataPersistanceManager.shared.deleteTitlesFromDatabase(model: titles[indexPath.row]) {[weak self] result in
                switch result{
                case .success(()):
                    print("item deleted from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHud("")
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        APICaller.shared.getMovies(with: titles[indexPath.row].title ?? titles[indexPath.row].original_title ?? "") { [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let title = self?.titles[indexPath.row]
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(
                        title: title?.title ?? title?.original_title ?? "",
                        overview: title?.overview ?? "",
                        youtubeView: videoElement, downloadButtonHidden: true, type: title?.media_type ?? "movie"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.hideHUD()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension DownloadsViewController {
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
extension DownloadsViewController: UpcomingTitleTableViewCellDelegate{
    func watchButtonTapped(index:IndexPath) {
        print("inside delagate func")
        showHud("")
        let title = titles[index.row]
        APICaller.shared.getMovies(with: title.title ?? "") { [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = WatchViewController()
                    vc.configure(with: TitlePreviewViewModel(title: title.title ?? "", overview: title.overview ?? "", youtubeView: videoElement, downloadButtonHidden: false, type: title.media_type ?? "movie"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    self?.hideHUD()
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
