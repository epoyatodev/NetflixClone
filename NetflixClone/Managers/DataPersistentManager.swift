//
//  DataPersistentManager.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 21/11/25.
//

import Foundation
import UIKit
import CoreData

class DataPersistentManager {
    
    static let shared = DataPersistentManager()
    
    private init() {}
    
    func downloadMovie(with model: Title) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        var movieItem: MovieItem = MovieItem(context: context)
        movieItem.original_title = model.original_title
        movieItem.overview = model.overview
        movieItem.release_date = model.release_date
        movieItem.poster_path = model.poster_path
        movieItem.media_type = model.media_type
        movieItem.id = Int64(model.id)
        movieItem.vote_average = model.vote_average
        movieItem.vote_count = Int64(model.vote_count)
        movieItem.original_name = model.original_name
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getMoviesFromDataBase() async throws -> [MovieItem] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw NSError() }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        
        return try context.fetch(request)
    }
    
    func deleteItem(movie: MovieItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(movie)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
