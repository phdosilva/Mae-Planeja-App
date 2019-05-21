//
//  ProdutosFinaisTableViewCell.swift
//  MaePlanejaCliente
//
//  Created by Allyson Nascimento on 20/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class ProdutosFinaisTableViewCell: UITableViewCell {
    @IBOutlet weak var ProdutoImageView: UIImageView!
    @IBOutlet weak var descProdutoTextView: UILabel!
    @IBOutlet weak var LojaTextView: UILabel!
    @IBOutlet weak var precoTextView: UILabel!
    @IBOutlet weak var recomendacaoTextView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
