//
//  upcomingMoviesTableViewCell.swift
//  moovy
//
//  Created by fârûqî on 27.03.2021.
//

import UIKit

class upcomingMovieCell: UITableViewCell {
    
    var movie: MovieViewModel! {
        didSet{
            let placeHolder = #imageLiteral(resourceName: "tmdb")
            self.posterIV.kf.setImage(with: movie?.poster_url, placeholder: placeHolder)
            self.titleLbl.text = movie.title ?? "" + " (\(String(describing: movie?.year))"
            self.detailLbl.text = movie.overview
            if let date = movie.release_date {
                dateLbl.text = date 
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(posterIV)

        posterIV.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        posterIV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        //posterIV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        //posterIV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        posterIV.widthAnchor.constraint(equalToConstant: 100).isActive = true
        posterIV.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.addSubview(titleLbl)
        titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        //titleLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 16).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: self.posterIV.trailingAnchor, constant: 10).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(detailLbl)
        detailLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 0).isActive = true
        detailLbl.leadingAnchor.constraint(equalTo: posterIV.trailingAnchor, constant: 10).isActive = true
        detailLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        //detailLbl.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        self.addSubview(dateLbl)
        dateLbl.topAnchor.constraint(equalTo: self.detailLbl.bottomAnchor, constant: 10).isActive = true
        dateLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        dateLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        dateLbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dateLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    let posterIV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var dateLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        l.text = "date"
        //l.backgroundColor = .yellow
        return l
    }()
    
    var titleLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //l.backgroundColor = .yellow
        return l
    }()
    
    var detailLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        l.numberOfLines = 3
        //l.backgroundColor = .yellow
        return l
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

