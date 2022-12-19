//
//  PetTableCell.swift
//  MyPets
//
//  Created by Mac on 19/12/22.
//

import UIKit

class PetTableCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imgViewPet: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    // Set the identifier for the custom cell
    static let identifier = "PetCell"

    // Returning the xib file after instantiating it
    static var nib: UINib {
           return UINib(nibName: String(describing: self), bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
