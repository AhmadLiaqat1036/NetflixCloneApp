//
//  DataPersistanceManager.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 6/11/24.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager{
    enum DatabaseErrors: Error{
        case failedToGetData,failedToFetchData,failedToDeleteData
    }
    static let shared = DataPersistanceManager()
    
    func downloadMovieWith(model: Movie, completion: @escaping (Result<Void,Error>)->Void ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        fetchTitlesFromDatabase { result in
            switch result{
            case .success(let titles):
                var movies = titles
                if (!movies.contains { titleItem in
                    titleItem.id == model.id
                }){
                    let item = TitleItem(context: context)
                    item.original_title = model.originalTitle
                    item.id = Int64(model.id)
                    item.adult = model.adult
                    item.backdrop_path = model.backdropPath
                    item.media_type = model.mediaType
                    item.orignal_language = model.originalLanguage
                    item.overview = model.overview
                    item.popularity = model.popularity
                    item.poster_path = model.posterPath
                    item.release_date = model.releaseDate
                    item.title = model.title
                    item.video = model.video
                    item.vote_average = model.voteAverage
                    item.vote_count = Int64(model.voteCount)
                
                    do{
                        try context.save()
                        completion(.success(()))
                    }catch{
                        completion(.failure(DatabaseErrors.failedToGetData))
                    }
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    func downloadTvWith(model: Tv, completion: @escaping (Result<Void,Error>)->Void ){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        fetchTitlesFromDatabase { result in
            switch result{
            case .success(let titles):
                var tvs = titles
                if (!tvs.contains { titleItem in
                    titleItem.id == model.id
                }){
                    let item = TitleItem(context: context)
                    item.original_title = model.originalName
                    item.id = Int64(model.id)
                    item.adult = model.adult
                    item.backdrop_path = model.backdropPath
                    item.media_type = model.mediaType
                    item.orignal_language = model.originalLanguage
                    item.overview = model.overview
                    item.popularity = model.popularity
                    item.poster_path = model.posterPath
                    item.release_date = model.firstAirDate
                    item.title = model.name
                    item.video = true
                    item.vote_average = model.voteAverage
                    item.vote_count = Int64(model.voteCount)
                
                    do{
                        try context.save()
                        completion(.success(()))
                    }catch{
                        completion(.failure(DatabaseErrors.failedToGetData))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
    }
    func fetchTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DatabaseErrors.failedToFetchData))
        }
    }
    func deleteTitlesFromDatabase(model: TitleItem, completion: @escaping (Result<Void, Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseErrors.failedToDeleteData))
        }
    }
}
