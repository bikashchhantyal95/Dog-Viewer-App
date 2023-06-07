//
//  DogBreedTableView_CustomRowCell.swift
//  A2_WebServices
//
//  Created by Bikash Chhantyal on 2023-06-06.
//

import UIKit

class DogBreedTableView_CustomRowCell: UITableViewCell {

    @IBOutlet weak var breedNameLabel: UILabel!
    
    @IBOutlet weak var subBreedNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
