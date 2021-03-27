//
//  SimilarMoviesCollectionViewCell.swift
//  moovy
//
//  Created by fârûqî on 26.03.2021.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    var movie: MovieViewModel? {
        didSet{
            let placeHolder = #imageLiteral(resourceName: "tmdb")
            self.posterIV.kf.setImage(with: movie?.poster_url, placeholder: placeHolder)
            self.titleLbl.text = movie?.title
            if let year = movie?.year {
                yearLbl.text = year
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {

        self.addSubview(posterIV)
        self.addSubview(titleLbl)
        self.addSubview(yearLbl)
        
        posterIV.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 ).isActive = true
        posterIV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        posterIV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        posterIV.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLbl.topAnchor.constraint(equalTo: posterIV.bottomAnchor).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: posterIV.leadingAnchor).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: posterIV.trailingAnchor).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        

        yearLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor).isActive = true
        yearLbl.leadingAnchor.constraint(equalTo: posterIV.leadingAnchor).isActive = true
        yearLbl.trailingAnchor.constraint(equalTo: posterIV.trailingAnchor).isActive = true
        yearLbl.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    let posterIV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        
        return v
    }()
    
    var yearLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //l.backgroundColor = .yellow
        return l
    }()
    
    var titleLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //l.backgroundColor = .yellow
        return l
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
