//
//  ViewController.swift
//  KisanHubAssignment
//
//  Created by Karan on 25/04/19.
//  Copyright © 2019 KisanHub. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let url = "https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice/Rainfall-England.json"
    var responseJson: Array<[String: Any]>?

    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        getWeatherData {
            if let _ = self.responseJson {
                self.weatherTableView.reloadData()
                self.locationLabel.text = "England"
                self.yearLabel.text = String(describing: self.responseJson![0]["year"] as! Int)
            } else {
                print("Failure")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getWeatherData(completion: @escaping () -> ()) {
        Alamofire.request(url).responseJSON { (response) in
            if response.response?.statusCode == 200,
                response.error == nil,
                response.data != nil {
                let jsonResponse = try! JSONSerialization.jsonObject(with: response.data!, options: []) as? Array<[String: Any]>
                self.responseJson = jsonResponse?.filter {
                    let year = $0["year"] as! Int
                    return year == 1910
                }
            } else {
                self.responseJson = nil
            }
            completion()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = responseJson {
            return response.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell.monthLabel.text = getMonth(responseJson![indexPath.row]["month"] as! Int)
        cell.valueLabel.text = String(describing: responseJson![indexPath.row]["value"] as! Double)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func getMonth(_ month: Int) -> String {
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return ""
        }
    }
}
