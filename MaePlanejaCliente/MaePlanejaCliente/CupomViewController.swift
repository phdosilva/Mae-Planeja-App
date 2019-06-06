//
//  CupomViewController.swift
//  MaePlanejaCliente
//
//  Created by Pedro Henrique de Oliveira Silva on 06/06/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class CupomViewController: UIViewController {
    
    var valorDesconto:Int = 0
    @IBOutlet weak var mensagem: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let valorDesconto = Int.random(in: 6...13)
        self.mensagem.text = "Apresente este QR Code na loja para ganhar " + String(valorDesconto) + "% de desconto."
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
