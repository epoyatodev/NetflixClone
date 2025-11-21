//
//  MovieTableViewCell.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    static let identifier = "MovieTableViewCell"
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieLabel)
        contentView.addSubview(playButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Movie Poster
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            // Movie Label
            movieLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 20),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Play Button
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

        ])
    }
    
    func configure(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        moviePosterImageView.sd_setImage(with: url, completed: nil)
        movieLabel.text = model.movieName
    }
}
