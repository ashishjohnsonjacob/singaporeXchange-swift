//
//  ViewController.swift
//  SingaporeXchange
//
//  Created by Ashish Jacob on 30/6/19.
//  Copyright © 2019 Ashish Jacob. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var inrLabel: UILabel!
    @IBOutlet weak var sgdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func convertLabel(_ sender: UIButton)
    {
        let value:Double? = Double(sgdTextField.text!)
        let session = URLSession.shared
        let url = URL(string: "https://api.currconv.com/api/v7/convert?q=SGD_INR&compact=ultra&apiKey=a7a2f090-9a3d-40df-869b-f7d7340139df")!
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                {
                    let rateDouble = json["SGD_INR"] as? Double
                    let amount: Double = Double(round(100*rateDouble!)/100)
                    let finalAmount: Double = Double(round(100*(value! * amount))/100)
                    print(finalAmount)
                    DispatchQueue.main.async {
                         self.inrLabel.text = String(value!) + " SGD = " + String(finalAmount) + " INR"
                    }
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
