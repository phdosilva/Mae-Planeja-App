//
//  ProdutoTableViewCell.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 16/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagemProduto: UIImageView!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var precoProduto: UILabel!
    @IBOutlet weak var mesProduto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
