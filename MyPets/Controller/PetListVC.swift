//
//  PetListVC.swift
//  MyPets
//
//  Created by Mac on 19/12/22.
//

import UIKit
import Kingfisher

class PetListVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tblView: UITableView!
    
    var arrPets:[PetInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.register(PetTableCell.nib, forCellReuseIdentifier: PetTableCell.identifier)
        
        // Get pets data...
        getPetsData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Get pets data from pets_list.json file
    func getPetsData() {
        let jsonData = UIApplication.shared.readLocalJSONFile(forName: "pets_list")
        if let aData = jsonData {
            do {
                let decodedData = try JSONDecoder().decode(PetsData.self, from: aData)
                arrPets = decodedData.pets
            } catch {
                print("error: \(error)")
            }
        }

    }
}

extension PetListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell( withIdentifier: PetTableCell.identifier, for: indexPath) as? PetTableCell
        let aPetInfo = arrPets[indexPath.row]
        aCell?.imgViewPet.kf.setImage(with: URL(string: aPetInfo.image_url))
        aCell?.lblName.text = aPetInfo.title
        return aCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let aDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "PetDetailVC") as? PetDetailVC {
            aDetailVC.petInfo = arrPets[indexPath.row]
            self.navigationController?.pushViewController(aDetailVC, animated: true)
        }
    }
}

