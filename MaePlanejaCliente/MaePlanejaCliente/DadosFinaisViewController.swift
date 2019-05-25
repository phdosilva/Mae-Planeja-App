//
//  DadosFinaisViewController.swift
//  MaePlanejaCliente
//
//  Created by Allyson Nascimento on 20/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class DadosFinaisViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var produtoTableView: UITableView!
    var produtos:[Produto] = []
    

    func hard_populate() {
        let imgs = ["img01","img02","img03"]
        produtos = [
            Produto(nome_item: "Fralda", preco: "R$ 20,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/fraldadescartavel.jpg?alt=media&token=29488770-8584-4c4b-8b7c-5a85ce366fa1", mes: "3",imagens:imgs),
            Produto(nome_item: "Carrinho de bebê", preco: "R$ 350,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/carrinhobebe.jpg?alt=media&token=530e368e-e003-4512-938f-ffd6b635be30", mes: "6",imagens:imgs),
            Produto(nome_item: "Mamadeira", preco: "R$ 15,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/mamadeira.jpg?alt=media&token=10df756b-b14c-4439-93c4-c89e59cfec05", mes: "5",imagens:imgs),
            Produto(nome_item: "Berço", preco: "R$ 400,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/berco.jpg?alt=media&token=468685fc-0163-411e-a78f-3807c927f342", mes: "6",imagens:imgs),
            Produto(nome_item: "Cômoda", preco: "R$ 300,00", imagem: "https://firebasestorage.googleapis.com/v0/b/maeplaneja.appspot.com/o/comoda.jpg?alt=media&token=203dfc0b-b4de-458b-8a70-2f181ac6ca90", mes: "6",imagens:imgs),
            ]
    }
    
    func populate() {
        if let produtosPref = Produto.getProdutos() {
            self.produtos = produtosPref
        }
        
        //self.produtos = Produto.getProdutos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.produtoTableView.dataSource = self
        self.produtoTableView.delegate = self
        populate()
        self.produtoTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("quantidade de produtos: \(produtos.count)")
        return produtos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdutosFinaisTableViewCell") as! ProdutosFinaisTableViewCell
        let produto = produtos[indexPath.row]
        cell.descProdutoTextView.text = produto.nome_item
        
        cell.precoTextView.text = produto.preco
        downloadImage(url: produto.imagem ?? "", downloadImageView: cell.ProdutoImageView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    @objc func downloadImage(url:String,downloadImageView:UIImageView) {
        let imageURL = URL(string:url)!
        
        let dataTask = URLSession.shared.dataTask(with: imageURL) {
            (data, reponse, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    downloadImageView.image = UIImage(data: data)
                }
            }
        }
        
        dataTask.resume()
    }
}
