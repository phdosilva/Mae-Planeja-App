//
//  Produto.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 14/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//
import UIKit
import Foundation
class Produto : Codable {
    
    var nome_item: String?
    var preco: String?
    var imagem: String?
    var imagens:[String]
    var mes: String?
    
    init(nome_item: String?, preco: String?, imagem: String?,mes:String?,imagens:[String]){
        self.nome_item = nome_item
        self.preco = preco
        self.imagem = imagem
        self.mes = mes
        self.imagens = imagens
    }
    
    static func save(itens:[Produto]) {
//        //UserDefaults.standard.set(["nome_item": item.nome_item, "preco": item.preco?, "imagem": item.imagem, "mes": item.mes], forKey: )
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: itens)
//        UserDefaults.standard.set(itens, forKey: "lista_produtos")
//
        if let encoded = try? JSONEncoder().encode(itens) {
            UserDefaults.standard.set(encoded, forKey: "lista_produtos")
        }
    }
    
    static func getProdutos() -> [Produto]? {
        //return UserDefaults.standard.value(forKey: "lista_produtos") as! [Produto]
        if let itemData = UserDefaults.standard.data(forKey: "lista_produtos"),
            let item = try? JSONDecoder().decode([Produto].self, from: itemData) {
            return item
        }
        
        return nil
    }
}
