//
//  ViewController.swift
//  MoviesDBApp
//
//  Created by Mingyong Zhu on 2/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var nameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let nextVC = segue.destination as! MoviesViewController
//        nextVC.navigationBar.backBarButtonItem?.title = ""
//
//        let customButton = UIBarButtonItem()
//        customButton.title = ""
//        navigationItem.hidesBackButton = true
//    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if let text = nameInput.text {
            //MARK: if the username less than 3 characters, show alert !
            if text.count < 3 {
                let alert = UIAlertController(title: "Warning!", message: "The name should be at least 3 characters!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { action in
                    print("OK clicked!")
                }
                alert.addAction(okAction)
                self.present(alert,animated: true,completion: nil)
                
                
            } else {
                defaults.setValue(text, forKey: "name")
            }
            
            //MARK: Change the window's root view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let moviesMainController = storyboard.instantiateViewController(identifier: "MovieNavigation")
                
                // This is to get the SceneDelegate object from the view controller
                // then call the change root view controller function to change to movies view controller
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(moviesMainController)
        }
    
    }

}
