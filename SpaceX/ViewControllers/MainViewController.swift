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
    @IBOutlet weak var heightRocketLabel: UILabel!
    @IBOutlet weak var diameterRocketLabel: UILabel!
    @IBOutlet weak var massRocketLabel: UILabel!
    @IBOutlet weak var payloadsWeightLabel: UILabel!
    
    private var networkManager = NetworkManager.shared
    private var rockets = [Rocket]()
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.contentInsetAdjustmentBehavior = .never
        setupLoader()
    }
}

extension MainViewController {
    
    // MARK: - Private methods
    private func setupLoader() {
        self.networkManager.fetchData(dataType: [Rocket].self, from: Links.rockets.rawValue, with: { (model) in
            switch model {
            case .success(let rockets):
                DispatchQueue.main.async {
                    self.rockets = rockets
                    self.setUI()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func setUI() {
        DispatchQueue.global().async {
            guard let imageData = self.networkManager.fetchImage(from: self.rockets[0].flickrImages.randomElement()) else { return }
            DispatchQueue.main.async {
                self.imageRocket.image = UIImage(data: imageData)
                self.imageRocket.contentMode = .scaleAspectFill
            }
        }
        
        let costPerLaunch = "$\(rockets.first!.costPerLaunch / 100000) млн"
        let finishedDate = getDate()
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
        heightRocketLabel.text = "\(rockets.first!.height.meters) \n Высота, m"
        diameterRocketLabel.text = "\(rockets.first!.diameter.meters) \n Диаметр, m"
        massRocketLabel.text = "\(rockets.first!.mass.kg) \n Масса, kg"
        payloadsWeightLabel.text = "\(rockets.first!.payloadWeights.first!.kg) \n Нагрузка, kg"
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
    
    private func getDate() -> String {
        let receivedDate = rockets.first!.firstFlight
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = dateFormatter.date(from: receivedDate) else { return "Нет данныx"}
        let dateF = DateFormatter()
        dateF.timeStyle = .none
        dateF.dateFormat = "dd MMMM, yyyy"
        return dateF.string(from: date)
    }
}
