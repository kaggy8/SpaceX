//
//  MainViewController.swift
//  SpaceX
//
//  Created by Stanislav Demyanov on 18.07.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainScrollView.contentInsetAdjustmentBehavior = .never
        guard let url = URL(string: "https://api.spacexdata.com/v4/rockets") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "no error description")
                print(data as Any)
                return
            }
            
            do {
                let json = try JSONDecoder().decode([Rocket].self, from: data)
                print(json)
            } catch let error {
                print(error)
            }
        }.resume()
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
