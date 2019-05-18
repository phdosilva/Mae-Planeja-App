//
//  File.swift
//  MaePlanejaCliente
//
//  Created by Allyson Manoel Nascimento Venceslau on 16/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import Foundation

class Loja {
    let nome:String?
    let endereco:Endereco?
    var produtos:[Produto]?
    
    init(nome:String, endereco:Endereco, produtos:[Produto]) {
        self.nome = nome
        self.endereco = endereco
        self.produtos = produtos
    }
}
