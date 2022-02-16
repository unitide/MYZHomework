//
//  MovieDetailViewController.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/12/22.
//

import UIKit
import Combine

enum Section: Int {
    case Title  = 0
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
                itemsPerRow = 2
            } else {
                itemsPerRow = 1
           //  itemsPerRow = sectionIndex + 3
            }
            
            
            
            let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
            let inset: CGFloat = 2.5
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            let  vSpace = CGFloat(30)
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
    
    private func setupBinding() {
        if let vm = vm {
            vm
            .$moviesOverview
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                   // self?.movieDetail
           //     self?.displayMovieDetail()
                }
            .store(in: &subscribers)
            
            if self.movieID != nil {
              vm.fetchMoviesData(movieID: self.movieID!)
            }
        }
    }
    
//    func displayMovieDetail() {
//        if let movie = vm?.getChosenMovie() {
//            titleLabel.text = movie.title
//            overviewLabel.text = movie.overview
//            if let image = movie.posterImage {
//                posterImAGE.image = UIImage(data: image)
//            }
//        }
        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieDetailViewController: UICollectionViewDelegate {

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
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .center
                cell.label.textColor = .red
              //  cell.label.font.withSize(30)
                cell.label.font = UIFont.boldSystemFont(ofSize: 24)
            }
            return cell
            
        case Section.Overview.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.textCell, for: indexPath) as! TextCollectionViewCell
            if let movie = vm?.getChosenMovie() {
                cell.label.text = movie.overview
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .left
           //     cell.label.textColor = .red
                cell.label.font.withSize(14)
            }
            return cell
            
        case Section.Poster.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.imageCell, for: indexPath) as! ImageCollectionViewCell
            
            if let movie = vm?.getChosenMovie() {
               
               
                if let image = movie.posterImage {
                    cell.image.image = UIImage(data: image)
                }
            }
            return cell

            
        case Section.ProductCompanyLabel.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.textCell, for: indexPath) as! TextCollectionViewCell
            
            
                cell.label.text   = "Product Companies"
                cell.label.numberOfLines = 0
                cell.label.textAlignment = .left
                cell.label.textColor = .red
                cell.label.font.withSize(20)
            
            return cell

            
        case Section.ProductCompanies.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.imageCell, for: indexPath) as! ImageCollectionViewCell
            
            if let data = vm?.getChosenMovieProductionLogo() {
                
                cell.image.image = UIImage(data: data[indexPath.row])
            
            }
            
            return cell

            
        case Section.Favorite.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.favoriteCell, for: indexPath) as! FavoriteCollectionViewCell
            return cell

            
        default:
             let cell = UICollectionViewCell()
            return cell

            
        }
        
        // Configure cell appearance
       
      
    }

}
