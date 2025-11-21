//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 18/11/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let moviesService: MoviesService = .init()
    private var movies: [Title] = []
    
    private let searchTable: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchTable)
        searchTable.delegate = self
        searchTable.dataSource = self
        navigationItem.searchController = searchController
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    private func fetchDiscoverMovies() {
        Task { [weak self] in
            do {
                self?.movies = try await self?.moviesService.getDiscoverMovies() ?? []
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let title = movies[indexPath.row]
        let model = MovieViewModel(movieName: title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieName = movie.original_title ?? movie.original_name else { return }
        
        Task { @MainActor in
            do {
                let videoElement = try await moviesService.getMovie(with: movieName)
                let vc = MoviePreviewViewController()
                vc.configure(with: .init(title: movieName, youtubeVideo: videoElement, overview: movie.overview ?? ""))
                
                self.navigationController?.pushViewController(vc, animated: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    func searchResultViewControllerDidSelectMovie(_ viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultController.delegate = self
        Task { @MainActor in
            do {
                self.movies = try await moviesService.searchMovies(query: query)
                resultController.movies = self.movies
                resultController.searchResultsCollectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
