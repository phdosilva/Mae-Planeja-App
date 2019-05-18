//
//  Endereco.swift
//  MaePlanejaCliente
//
//  Created by Allyson Manoel Nascimento Venceslau on 18/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import Foundation

class Endereco {
    let rua:String
    let bairro:String
    let cep:String
    let numero:String
    
    init(rua:String,
    bairro:String,
    cep:String,
    numero:String) {
        self.rua = rua
        self.bairro = bairro
        self.cep = cep
        self.numero = numero
    }
}

