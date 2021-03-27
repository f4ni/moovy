//
//  DetailViewController.swift
//  moovy
//
//  Created by fârûqî on 26.03.2021.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var viewModel: MovieViewModel!
    {
        didSet{
            fetchMovieDetail(id: viewModel.id!)
            fetchSimilarMovies(id: viewModel.id!)
        }
    }
    var detailedModel: MovieViewModel! {
        didSet{
            let placeholder =  #imageLiteral(resourceName: "tmdb")
            posterIV.kf.setImage(with: viewModel.poster_url, placeholder: placeholder, options: [.transition(.flipFromLeft(0.3))])
            titleLbl.text = viewModel.title
            if let overview = viewModel.overview {
                movieDescTV.text = overview
            }
            if let star = detailedModel.vote_average {
                starLbl.text = star
            }
            if let date = detailedModel.release_date {
                dateLbl.text = date
            }

        }
    }
    
    fileprivate let similarMovieCellID = "similarMovieCellID"
    
    var similarMoviesViewModel = [MovieViewModel]()
    
    let posterIV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        return v
    }()
    
    
    var titleLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //l.backgroundColor = .yellow
        return l
    }()
    

    var starLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        l.textAlignment = .right
        //l.backgroundColor = .yellow
        return l
    }()

    var dateLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //l.backgroundColor = .yellow
        return l
    }()

    var similarMTitleLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //l.backgroundColor = .yellow
        l.text = "Similar Movies"
        return l
    }()

    var movieDescTV: UITextView = {
       let v = UITextView()
        v.font = UIFont.systemFont(ofSize: 18)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var mainStackView: UIStackView = {
       let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var bottomStackView: UIStackView = {
       let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 10
        
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var imdbBtn: UIButton = {
       let b = UIButton()
        b.setTitle("IMDB", for: .normal)
        b.backgroundColor = .systemYellow
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        setupViews()

    }
    
    func fetchMovieDetail(id: Int) {
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=5c3f14a468fe223a9d38df038fea07f8"
        
        APIService.instance.fetch(.get, url: url, requestModel: nil, model: Movie.self, completion: { result in
            switch result{
            case .success(let model):
                let movie = model as! Movie
                self.detailedModel = MovieViewModel(movie: movie)
            case .failure(_):
                print("Movie Detail fetch failed")
            }
        })
    }
    

    func fetchSimilarMovies(id: Int) {
        let url = "https://api.themoviedb.org/3/movie/\(id)/similar?api_key=5c3f14a468fe223a9d38df038fea07f8"
        
        APIService.instance.fetch(.get, url: url, requestModel: nil, model: MovieBundle.self, completion: { response in
            
            switch response {
            case .success(let model):
                let movies = model as! MovieBundle
                self.similarMoviesViewModel = movies.results.map({return MovieViewModel(movie: $0)})
                self.similarMoviesCV.reloadData()
            case .failure(_):
                print("failure")
                break
            }
        })
    }

    lazy var similarMoviesCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 10
        l.minimumInteritemSpacing = 10
        l.itemSize = CGSize(width: 120, height: 140)
        let v = UICollectionView(frame: .zero, collectionViewLayout: l)
        v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
//        v.isPagingEnabled = true
        v.delegate = self
        v.dataSource = self
        v.contentInset = UIEdgeInsets(top: -10, left: 10, bottom: 0, right: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        /*
         
         l.minimumLineSpacing = 0
         l.minimumInteritemSpacing = 0
         
         let v = UICollectionView(frame: .zero, collectionViewLayout: l)
         v.backgroundColor = .clear
         v.isPagingEnabled = true
         v.delegate = self
         v.dataSource = self
         v.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         
         return v
         
         */
        return v
    }()
    
    
    func setupViews() {
        
//        similarMoviesCV.register(similarMovieCellID.self, forCellWithReuseIdentifier: self.similarMovieCellID)
        
        view.backgroundColor = .white
        
        self.view.addSubview(mainStackView)
        
        
        mainStackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
               
        mainStackView.addArrangedSubview(posterIV)
        mainStackView.addArrangedSubview(titleLbl)
        mainStackView.addArrangedSubview(movieDescTV)
        mainStackView.addArrangedSubview(bottomStackView)
        mainStackView.addArrangedSubview(similarMTitleLbl)
        mainStackView.addArrangedSubview(similarMoviesCV)
        
        bottomStackView.addArrangedSubview(starLbl)
        bottomStackView.addArrangedSubview(dateLbl)
        bottomStackView.addArrangedSubview(imdbBtn)
        
        //posterIV.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        posterIV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        posterIV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        posterIV.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        
        //self.view.addSubview(titleLbl)
        //titleLbl.topAnchor.constraint(equalTo: self.posterIV.bottomAnchor).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 10).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //movieDescTV.heightAnchor.constraint(equalToConstant: 200).isActive = true
        movieDescTV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        movieDescTV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        //bottomStackView.topAnchor.constraint(equalTo: self.movieDescTV.bottomAnchor).isActive = true
        bottomStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        imdbBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        similarMTitleLbl.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 20).isActive = true
        similarMTitleLbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        similarMTitleLbl.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16).isActive = true
        
        similarMoviesCV.heightAnchor.constraint(equalToConstant: 250).isActive = true
        similarMoviesCV.register(SimilarMoviesCollectionViewCell.self, forCellWithReuseIdentifier: similarMovieCellID)
        
        starLbl.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16).isActive = true
        
    }
    
    @objc func openUrl() {
        
        if let url = URL(string: detailedModel.imdb_url ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMoviesViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: similarMovieCellID, for: indexPath) as! SimilarMoviesCollectionViewCell
        cell.movie = self.similarMoviesViewModel[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel = self.similarMoviesViewModel[indexPath.row]
    }
}
