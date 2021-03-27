//
//  nowPlayingMovieCollectionViewCell.swift
//  moovy
//
//  Created by fârûqî on 26.03.2021.
//

import UIKit

class nowPlayingMovieCell: UICollectionViewCell {
    
    var movie: MovieViewModel? {
        didSet{
            let placeHolder = #imageLiteral(resourceName: "tmdb")
            self.posterIV.kf.setImage(with: movie?.poster_url, placeholder: placeHolder)
            self.titleLbl.text = movie?.title ?? "" + " (\(String(describing: movie?.year)))"
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(posterIV)

        posterIV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        posterIV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        posterIV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        posterIV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //posterIV.heightAnchor.constraint(equalToConstant: 250).isActive = true
     
        
        self.addSubview(titleLbl)
        titleLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    let posterIV: UIImageView = {
        let v = UIImageView()
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    var titleLbl: UILabel = {
      let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        l.textColor = .white
        l.textAlignment = .center
        //l.backgroundColor = .yellow
        return l
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
