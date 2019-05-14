//
//  ViewController.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 09/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //populate()
    
    }
    
    func populate(){
        let ref: DatabaseReference! = Database.database().reference()
        let produtoRef = ref.child("Produto")
        let produtos = [Produto(nome_item: "Fralda", preco: "R$ 20,00", imagem: "", mes: "3"),
                        Produto(nome_item: "Carrinho de bebê", preco: "R$ 350,00", imagem: "", mes: "6"),
                        Produto(nome_item: "Mamadeira", preco: "R$ 15,00", imagem: "", mes: "5"),
                        Produto(nome_item: "Berço", preco: "R$ 400,00", imagem: "", mes: "6"),
                        Produto(nome_item: "Cômoda", preco: "R$ 300,00", imagem: "", mes: "6"),
                        Produto(nome_item: "Macacão", preco: "R$ 20,00", imagem: "", mes: "5"),
                        Produto(nome_item: "Fralda de pano", preco: "R$ 5,00", imagem: "", mes: "5"),
                        Produto(nome_item: "Pano umidecido", preco: "R$ 10,00", imagem: "", mes: "5"),
                        Produto(nome_item: "Banheira", preco: "R$ 350,00", imagem: "", mes: "5"),
                        Produto(nome_item: "Pote de leite", preco: "R$ 5,00", imagem: "", mes: "7")]
       
        for produto in produtos{
            let key = produtoRef.childByAutoId().key
            let prod = ["nome_item":produto.nome_item,"preco":produto.preco,"imagem": produto.imagem,"mes":produto.mes]
            produtoRef.child(key!).setValue(prod)
        }
    }


}

