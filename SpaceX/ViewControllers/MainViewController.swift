//
//  MainViewController.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 18.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageRocket: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var nameRocketLabel: UILabel!
    @IBOutlet weak var firstLaunchDateLabel: UILabel!
    @IBOutlet weak var countryLaunchLabel: UILabel!
    @IBOutlet weak var costPerLaunchLabel: UILabel!
    @IBOutlet weak var firstStageEnginesCountLabel: UILabel!
    @IBOutlet weak var firstStageFuelAmountLabel: UILabel!
    @IBOutlet weak var firstStageBurnTimeLabel: UILabel!
    @IBOutlet weak var secondStageInfoLabel: UILabel!
    
    private var networkManager = NetworkManager.shared
    private var rockets = [Rocket]()
    
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
            self.getImage()
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
        
        let country = getCountry()
        
        nameRocketLabel.text = rockets.first!.name
        firstLaunchDateLabel.text = finishedDate
        countryLaunchLabel.text = country
        costPerLaunchLabel.text = costPerLaunch
        firstStageEnginesCountLabel.text = String(rockets.first!.firstStage.engines)
        firstStageBurnTimeLabel.text = String(rockets.first!.firstStage.burnTimeSec!)
        firstStageFuelAmountLabel.text = String(rockets.first!.firstStage.fuelAmountTons)
        secondStageInfoLabel.text = "\(rockets.first!.secondStage.engines) \n \(rockets.first!.secondStage.burnTimeSec!) \n \(rockets.first!.secondStage.fuelAmountTons)"
        secondStageInfoLabel.textColor = .white
    }
    
    private func getImage() {
        guard let urlString = rockets[0].flickrImages.randomElement() else { return }
        guard let url = URL(string: urlString) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        imageRocket.image = UIImage(data: data)
        imageRocket.contentMode = .scaleAspectFill
    }
    
    private func getCountry() -> String {
        let country = rockets[0].country
        
        switch country {
        case "Republic of the Marshall Islands":
            return "Маршалловы острова"
        case "United States":
            return "США"
        default:
            return "Нет данных"
        }
    }
}

extension Locale {
    func countryCode(by countryName: String) -> String? {
        return Locale.isoRegionCodes.first(where: { code -> Bool in
            guard let localizedCountryName = localizedString(forRegionCode: code) else {
                return false
            }
            return localizedCountryName.lowercased() == countryName.lowercased()
        })
    }
}
