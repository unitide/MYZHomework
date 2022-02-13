//
//  MoviesViewController.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/11/22.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {

    
    @IBOutlet private weak var nameItem: UIBarButtonItem!
    
    @IBOutlet private weak var currentOption: UISegmentedControl!
    
    @IBOutlet private weak var moviesTableView: UITableView!
    
   // private var movies: [MoviesOverview]?
    private var vm = ViewModel()
    private var subscribers = Set<AnyCancellable>()
    
    var currentRow: Int?
    let cellIdentifer = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    
        displayNameOnToolbar()
        setupBinding()
        moviesTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! MovieDetailViewController
        if let row = self.currentRow {
            detailVC.currentRow = row
        }
        
    }
    
    private func setupBinding() {
        vm
        .$moviesOverview
        .receive(on: RunLoop.main)
        .sink { [weak self] _ in
                
                self?.moviesTableView.reloadData()
            }
        .store(in: &subscribers)
        
        vm.fetchMoviesData()
        
    }

    @IBAction func changeName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Change Name", message: "Enter your name", preferredStyle: .alert)
        alert.addTextField { name in
            let text = UserDefaults.standard.string(forKey: "name")
            name.placeholder =  text != nil ? text : "Input your name here"
            }
        
        let okAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            let savedText = alert.textFields![0] as UITextField
            if let name = savedText.text {
                if name.count >= 3 {
                    UserDefaults.standard.set(name, forKey: "name")
                    self.displayNameOnToolbar()
                    }
            }
        })
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert,animated: true,completion: nil)
            
        }
        
    
    
    func displayNameOnToolbar() {
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "name") {
            nameItem.title = "Hello: \(name)"
            nameItem.tintColor = .darkGray
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentRow = indexPath.row
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getTotalMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! customMovieTableViewCell
        let row = indexPath.row
       
        cell.movieTitle.text = vm.getMovieTitleByRow(row: row)
        cell.movieOverview.text = vm.getMovieOverviewByRow(row: row)
        if let image = vm.getMoviePosterImageByRow(row: row) {
            cell.movieImage.image = UIImage(data: image)
        }
        
        return cell
    }
}
