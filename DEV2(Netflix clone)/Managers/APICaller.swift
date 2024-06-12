//
//  APICaller.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 5/20/24.
//

import Foundation

class Constants{
    static let baseURL = "https://api.themoviedb.org"
    static let APIKey = "cf06870d5d3401f0918f969b71f9ee15"
    static let Youtube_APIKey = "AIzaSyDOFsijSJCpRqhWvbbkbHw5xjOz_jCbelE"
    static let Youtube_BaseURL = "https://youtube.googleapis.com/youtube/v3/search"
}

enum APIErrors: Error{
    case failedToGetData
}
class APICaller{
    static let shared = APICaller()
    func getTrending(completion: @escaping (Result<[Movie], Error>) ->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/week?api_key=\(Constants.APIKey)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            
            do{
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIErrors.failedToGetData))
            }
        }
        task.resume()
    }
    func getTrendingTv(completion: @escaping (Result<[Tv], Error>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/week?api_key=\(Constants.APIKey)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            
            do{
                let results = try JSONDecoder().decode(TvResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIErrors.failedToGetData))
            }
        }
        task.resume()
    }
    func getTopRatedTv(completion: @escaping (Result<[Tv], Error>)->Void){
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=cf06870d5d3401f0918f969b71f9ee15") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            
            do{
                let results = try JSONDecoder().decode(TvResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIErrors.failedToGetData))
            }
        }
        task.resume()
    }
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.APIKey)") else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            do{
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)

                completion(.success(results.results))
            }catch{
                completion(.failure(APIErrors.failedToGetData))
            }
        }
        task.resume()
    }
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>)->Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.APIKey)")else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data=data, error==nil else{return}
            do{
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIErrors.failedToGetData))
            }
        }
        task.resume()
    }
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>)->Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.APIKey)")else{return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data=data, error==nil else{return}
            do{
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIErrors.failedToGetData))
            }
        }
        task.resume()
    }
    func getSearchedResult(search query:String, completion: @escaping (Result<[Movie], Error>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.APIKey)&query=\(query)")else{return}
       
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data=data, error==nil else{return}
            do{
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIErrors.failedToGetData))
            }
        }
        task.resume()
    }
    func getMovies(with query:String, completion: @escaping (Result<VideoElement, Error>)->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.Youtube_BaseURL)?q=\(query)&type=video&key=\(Constants.Youtube_APIKey)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data=data, error==nil else{return}
            do{
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(results)
                let results = try JSONDecoder().decode(YoutubeResponse.self, from: data)
                completion(.success(results.items[0]))
                print("going to print results")
                print(results.items[0])
            }catch{
                print("not going to print results")
                completion(.failure(APIErrors.failedToGetData))
                print(error)
            }
        }
        task.resume()
    }
}
