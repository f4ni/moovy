//
//  ViewController.swift
//  moovy
//
//  Created by fârûqî on 25.03.2021.
//

import UIKit
import Kingfisher
import SearchTextField

class MainViewController: UIViewController {
    
    var viewController: MainViewController?
    
    var nowPlayinMoviesViewModel = [MovieViewModel]()
    
    var upcomingMovieViewModel = [MovieViewModel]()
    
    var searchedMoviesViewModel = [MovieViewModel]()
    
    fileprivate let npmCellID = "nowPlayingMovieCellID"
    fileprivate let upcMTVCellID = "nowPlayingMovieCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fetchMovies()
    }
    
    var nowPMPageCtrl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.tintColor = .gray
        return pc
    }()
    
    func setupViews() {
        
        view.addSubview(nowPlayingMoviesCV)
        nowPlayingMoviesCV.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingMoviesCV.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nowPlayingMoviesCV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nowPlayingMoviesCV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nowPlayingMoviesCV.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.backgroundColor = .white
        nowPlayingMoviesCV.register(nowPlayingMovieCell.self, forCellWithReuseIdentifier: npmCellID)
        
        view.addSubview(upcomingMTV)
        
        upcomingMTV.translatesAutoresizingMaskIntoConstraints = false
        upcomingMTV.topAnchor.constraint(equalTo: nowPlayingMoviesCV.bottomAnchor).isActive = true
        upcomingMTV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        upcomingMTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        upcomingMTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        navigationController?.title = "Moovy"
        self.navigationItem.largeTitleDisplayMode = .automatic
        configureNavigationBar(largeTitleColor: .black, backgoundColor: .white, tintColor: .blue, title: "Moovy", preferredLargeTitle: false)
        setupSearchController()
        
        view.addSubview(nowPMPageCtrl)
        nowPMPageCtrl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nowPMPageCtrl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nowPMPageCtrl.bottomAnchor.constraint(equalTo: nowPlayingMoviesCV.bottomAnchor, constant: -40).isActive = true
        nowPMPageCtrl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    var searchTextField: SearchTextField!
    
    func setupSearchController() {
        let stf = SearchTextField(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        searchTextField = stf
        
        searchTextField.backgroundColor = .white
        
        view.addSubview(searchTextField)
        
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchTextField.placeholder = "Search Movie"
        searchTextField.minCharactersNumberToStartFiltering = 3
        searchTextField.maxNumberOfResults = 10
        searchTextField.theme.font = .systemFont(ofSize: 16)


        
        searchTextField.userStoppedTypingHandler = {
            if let word = self.searchTextField.text, word.count > 2 {
                
                let url = "https://api.themoviedb.org/3/search/movie?api_key=5c3f14a468fe223a9d38df038fea07f8&query=\(word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "" )"
                self.searchTextField.showLoadingIndicator()
                APIService.instance.fetch(.get, url: url, requestModel: nil, model: MovieBundle.self, completion: { result in
                    switch result {
                    
                    case .success(let model):
                        let movies = model as! MovieBundle
                        self.searchedMoviesViewModel = movies.results.map({return MovieViewModel(movie: $0)})
                        let filtStrs = self.searchedMoviesViewModel.map({return $0.title}) as! [String]
                        self.searchTextField.filterStrings(filtStrs)
                        self.searchTextField.stopLoadingIndicator()
                   
                    case .failure(_):
                        print("failure")
                        break
                    }
                })
                
            }
        
        }
        searchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            
            for itm in self.searchedMoviesViewModel {
                if itm.title == item.title {
                    self.openMovieDetail(movie: itm)
                    break
                }
            }
        }
        
    }
    
    lazy var nowPlayingMoviesCV: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: l)
        v.backgroundColor = .white
        v.isPagingEnabled = true
        v.delegate = self
        v.dataSource = self
        v.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return v
    }()
    
    lazy var upcomingMTV: UITableView = {
       let v = UITableView()
        v.dataSource = self
        v.delegate = self
        v.register(upcomingMovieCell.self, forCellReuseIdentifier: self.upcMTVCellID)
        //v.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return v
    }()
    
    func fetchMovies() {
        var url = "https://api.themoviedb.org/3/movie/now_playing?api_key=5c3f14a468fe223a9d38df038fea07f8"
        APIService.instance.fetch(.get, url: url, requestModel: nil, model: MovieBundle.self, completion: { response in
            
            switch response {
            
            case .success(let model):
                let movies = model as! MovieBundle
                self.nowPlayinMoviesViewModel = movies.results.map({return MovieViewModel(movie: $0)})
                self.nowPlayingMoviesCV.reloadData()
                self.nowPMPageCtrl.numberOfPages = self.nowPlayinMoviesViewModel.count
            
            case .failure(_):
                print("failure")
                break
            }
        })
        url = "https://api.themoviedb.org/3/movie/upcoming?api_key=5c3f14a468fe223a9d38df038fea07f8"
        APIService.instance.fetch(.get, url: url, requestModel: nil, model: MovieBundle.self, completion: { response in
            
            switch response {
           
            case .success(let model):
                let movies = model as! MovieBundle
                self.upcomingMovieViewModel = movies.results.map({return MovieViewModel(movie: $0)})
                self.upcomingMTV.reloadData()
                self.upcomingMTV.endUpdates()
                
            case .failure(_):
               print("failure")
               break
           }
       })
    }
    
    func openMovieDetail(movie: MovieViewModel) {
        let vc = DetailViewController()
        vc.viewModel = movie
        self.present(vc, animated: true, completion: nil)
    }

}

extension UIViewController {
func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title

    } else {
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = title
    }
}}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return upcomingMovieViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: upcMTVCellID, for: indexPath) as! upcomingMovieCell
        cell.movie = self.upcomingMovieViewModel[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        openMovieDetail(movie: upcomingMovieViewModel[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nowPlayinMoviesViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: npmCellID, for: indexPath) as! nowPlayingMovieCell
        cell.movie = self.nowPlayinMoviesViewModel[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openMovieDetail(movie: nowPlayinMoviesViewModel[indexPath.row])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.nowPMPageCtrl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}


