//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 18/11/25.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRatedMovies = 4
}

class HomeViewController: UIViewController {
    private let moviesService: MoviesService = MoviesService()
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    private let sectionTitles: [String] = [
        "Trending Movies",
        "Trending TV",
        "Popular",
        "Upcoming Movies",
    ]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
    }
    
    private func configureHeroHeaderView() {
        Task {
            do {
                let selectedMovie = try await moviesService.getTrendingMovies().randomElement()
                self.randomTrendingMovie = selectedMovie
                let moviename = selectedMovie?.original_title ?? selectedMovie?.original_name ?? "Unknown"
                self.headerView?.configure(with: .init(movieName: moviename, posterURL: selectedMovie?.poster_path ?? ""))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .plain, target: self, action: nil)
        ]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func getTrendingMovies() async -> [Title] {
        do {
            return try await moviesService.getTrendingMovies()
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getTrendingTv() async -> [Title] {
        do {
            return try await moviesService.getTrendingTVShows()
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getUpcomingMovies() async -> [Title] {
        do {
            return try await moviesService.getUpcomingMovies()
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getPopularMovies() async -> [Title] {
        do {
            return try await moviesService.getPopularMovies()
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getTopRatedMovies() async -> [Title] {
        do {
            return try await moviesService.getTopRatedMovies()
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        Task {
            switch indexPath.section {
            case Sections.TrendingMovies.rawValue:
                cell.configure(with: await getTrendingMovies())
            case Sections.TrendingTv.rawValue:
                cell.configure(with: await getTrendingTv())
            case Sections.Popular.rawValue:
                cell.configure(with: await getPopularMovies())
            case Sections.UpcomingMovies.rawValue:
                cell.configure(with: await getUpcomingMovies())
            case Sections.TopRatedMovies.rawValue:
                cell.configure(with: await getTopRatedMovies())
            default:
                return UITableViewCell()
            }
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.textColor = .white
    }
    // TODO: Delete
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let defaultOffset = view.safeAreaInsets.top
    //        let offset = scrollView.contentOffset.y + defaultOffset
    //
    //        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    //    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
