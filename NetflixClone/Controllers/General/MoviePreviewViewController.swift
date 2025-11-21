//
//  MoviePreviewViewController.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 20/11/25.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Harry Potter"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is a best movie ever to watch as a kid!"
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(movieLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        view.addSubview(webView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // WebView
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            // Movie Label
            movieLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            movieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Overview Label
            overviewLabel.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Download Button
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    func configure(with model: MoviePreviewViewModel) {
        movieLabel.text = model.title
        overviewLabel.text = model.overview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId ?? "")?playsinline=1") else { return }
        
        webView.load(URLRequest(url: url))
    }
    
}
