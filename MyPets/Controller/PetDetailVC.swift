//
//  PetDetailVC.swift
//  MyPets
//
//  Created by Mac on 19/12/22.
//

import UIKit
import WebKit

class PetDetailVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!

    // MARK: - Properties
    var petInfo: PetInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupData()
    }
    
    func setupData() {
        guard let aURL = URL(string: petInfo?.content_url ?? "") else { return }
        webView.load(URLRequest(url: aURL))
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
