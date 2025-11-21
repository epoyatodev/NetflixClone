//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 18/11/25.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private let moviesService: MoviesService = .init()
    private var titles: [Title] = []
    
    private let upcomingTable: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        Task { [weak self] in
            do {
                self?.titles = try await self?.moviesService.getUpcomingMovies() ?? []
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: .init(movieName: title.original_title ?? title.original_name ?? "Unknown", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = titles[indexPath.row]
        
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
