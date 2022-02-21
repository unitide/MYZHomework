//
//  MovieDetailViewController.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/12/22.
//

import UIKit
import Combine

enum Section: Int {
    case Title = 0
    case Overview 
    case Poster
    case ProductCompanyLabel
    case ProductCompanies
    case Favorite
    
    
}

class MovieDetailViewController: UIViewController {
    var movieID: Int?
    var vm: ViewModel?
    private var movieDetail: MoviesOverview?
    private var subscribers = Set<AnyCancellable>()

    @IBOutlet  var collecView: UICollectionView!
    
    let imageCell = "imageCell"
    let textCell = "textCell"
    let favoriteCell = "favoriteCell"
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = "Movies"
        setupBinding()
        if let id = movieID {
            print("the current movie id \(id)")
        } else {
                print("Movie ID is not available")
            }
      
        
       
      
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            var itemsPerRow: Int
            
            if sectionIndex == Section.ProductCompanies.rawValue {
                itemsPerRow = 1
            } else {
                itemsPerRow = 1
           //  itemsPerRow = sectionIndex + 3
            }
            
            
            
            let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
            let inset: CGFloat = 2.5
            
            // Item
            let heightFraction: Double
            
            switch sectionIndex {
            case Section.Title.rawValue:
                heightFraction = 0.3
               
            case Section.Overview.rawValue:
                heightFraction = 0.9
                
            case Section.Poster.rawValue:
                heightFraction = 1
                
            case Section.ProductCompanyLabel.rawValue:
                heightFraction = 0.4
                
            case Section.ProductCompanies.rawValue:
                heightFraction = 0.6
                
            case Section.Favorite.rawValue:
                heightFraction = 0.5
                
            default:
                heightFraction = 1
                
            }
            
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(heightFraction))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            // Group
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(heightFraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
          //   group.interItemSpacing = .fixed(2)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            let  vSpace = CGFloat(10)
            section.interGroupSpacing = vSpace
           
            
            

           section.orthogonalScrollingBehavior = .groupPaging
         //   section.orthogonalScrollingBehavior = .continuous
            
    //        // Supplementary Item
    //        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
    //        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
    //        section.boundarySupplementaryItems = [headerItem]
            
            
            return section
        })

        
       
        
        // Create collection view with list layout
        collecView = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout)
        view.addSubview(collecView)

        
        
        // Make collection view take up the entire view
        collecView.translatesAutoresizingMaskIntoConstraints = false
        collecView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collecView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collecView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collecView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       
        self.collecView.delegate = self
        self.collecView.dataSource = self
      
      
        self.collecView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: self.imageCell)
      
        self.collecView.register(TextCollectionViewCell.self, forCellWithReuseIdentifier: self.textCell)
      
        self.collecView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: self.favoriteCell)
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // collecView.
    }
    
    private func setupBinding() {
        if let vm = vm {
            vm
            .$movieDetail
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                   // self?.movieDetail
                self?.collecView.reloadData()
                }
            .store(in: &subscribers)
            
            if self.movieID != nil {
              vm.fetchMoviesData(movieID: self.movieID!)
            }
        }
    }

}

extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       return
    }

}

extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Section.ProductCompanies.rawValue {
            if let number = vm?.getChosenMovieProductionLogo()?.count {
                print("production logo \(number)")
                   return number
            }
            print("production logo 0")
            return 0
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case Section.Title.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.textCell, for: indexPath) as! TextCollectionViewCell
            if let movie = vm?.getChosenMovie() {
                cell.label.text   = movie.title
                self.navigationItem.title = movie.title
              
           
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .center
                cell.backgroundColor = .yellow
                cell.label.textColor = .red
              //  cell.label.font.withSize(30)
                cell.label.font = UIFont.boldSystemFont(ofSize: 20)
            }
           
            return cell
            
        case Section.Overview.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.textCell, for: indexPath) as! TextCollectionViewCell
            if let movie = vm?.getChosenMovie() {
                cell.label.text = movie.overview
                cell.label.numberOfLines = 0
                cell.backgroundColor = .lightGray
                cell.label.textColor = .black
                cell.label.textAlignment = .left
                
                cell.label.font.withSize(16)
            }
            return cell
            
        case Section.Poster.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.imageCell, for: indexPath) as! ImageCollectionViewCell
            
            if let movie = vm?.getChosenMovie() {
               
               
                if let image = movie.posterImage {
                    cell.image.image = UIImage(data: image)
                }
            }
            cell.image.contentMode = .scaleAspectFit
            return cell

            
        case Section.ProductCompanyLabel.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.textCell, for: indexPath) as! TextCollectionViewCell
            
            
                cell.label.text   = "Product Companies"
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .left
                cell.backgroundColor = .yellow
                cell.label.textColor = .black
                cell.label.font.withSize(20)
            
            return cell

            
        case Section.ProductCompanies.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.imageCell, for: indexPath) as! ImageCollectionViewCell
            
            if let data = vm?.getChosenMovieProductionLogo() {
                
                cell.image.image = UIImage(data: data[indexPath.row])
            
            }
            cell.image.contentMode = .scaleAspectFit
            
            return cell

            
        case Section.Favorite.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.favoriteCell, for: indexPath) as! FavoriteCollectionViewCell
            cell.backgroundColor = .cyan
            if let status = vm?.getMovieDetailFavoriteStatus() {
                cell.favorite.setOn(status, animated: false)
            }
            cell.delegate = self
            return cell

            
        default:
             let cell = UICollectionViewCell()
            return cell

            
        }
        
        // Configure cell appearance
       
      
    }

}

//MARK: the protocol to get the status when user clicks the favorite switch 
extension MovieDetailViewController: MoviesFavoriteStatusProtocol {
    func setMoviesFavoriteStatus(status: Bool) {
        self.vm?.setMovieDetailFavoriteStatus(status: status)
    }
}
