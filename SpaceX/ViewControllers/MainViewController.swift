//
//  MainViewController.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 18.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var nameRocketLabel: UILabel!
    @IBOutlet weak var firstLaunchDateLabel: UILabel!
    @IBOutlet weak var countryLaunchLabel: UILabel!
    @IBOutlet weak var costPerLaunchLabel: UILabel!
    
    
    
    
    private var networkManager = NetworkManager()
    private var rockets = [Rocket]()
    
    override func loadView() {
        super.loadView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        updateRocket()
    }
}

extension MainViewController {
    
    // MARK: - Private methods
    private func updateRocket() {
        networkManager.getData { result in
            self.rockets = result
            self.setUI()
        }
    }
    
    private func setUI() {
        let costPerLaunch = "$\(rockets.first!.costPerLaunch / 100000) млн"
        
        let receivedDate = rockets.first!.firstFlight
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = dateFormatter.date(from: receivedDate) else { return }
        let dateF = DateFormatter()
        dateF.timeStyle = .none
        dateF.dateFormat = "dd MMMM, yyyy"
        let finishedDate = dateF.string(from: date)
        
        
        
        nameRocketLabel.text = rockets.first!.name
        firstLaunchDateLabel.text = finishedDate
        countryLaunchLabel.text = rockets.first!.country
        costPerLaunchLabel.text = costPerLaunch
    }
}
