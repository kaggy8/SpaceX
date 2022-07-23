//
//  MainViewController.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 18.07.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    private var networkManager = NetworkManager()
    private var rockets: [Rocket] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        mainScrollView.contentInsetAdjustmentBehavior = .never
        networkManager.getData { result in
            self.rockets = result
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
