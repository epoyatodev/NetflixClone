//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidSelectMovie(_ viewModel: MoviePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    var movies: [Title] = []
    private let moviesService: MoviesService = .init()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        guard let movieName = movie.original_title ?? movie.original_name else { return }
        
        Task { @MainActor in
            do {
                let videoElement = try await moviesService.getMovie(with: movieName)
                delegate?.searchResultViewControllerDidSelectMovie(.init(title: movieName, youtubeVideo: videoElement, overview: movie.overview ?? ""))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


