//
//  ProdutosTableViewCell.swift
//  MaePlanejaCliente
//
//  Created by Allyson Manoel Nascimento Venceslau on 18/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class ProdutosTableViewCell: UITableViewCell {

    @IBOutlet weak var produtoImageView: UIImageView!
    @IBOutlet weak var descProdutoTextView: UILabel!
    @IBOutlet weak var lojaTextView: UILabel!
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
