//
//  HomeViewController.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 16/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit
import FirebaseDatabase


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var produtoTableView: UITableView!
    var produtosList:[Produto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.produtoTableView.dataSource = self
        self.produtoTableView.delegate = self
        let produtoRef = Database.database().reference().child(EnumTables.Produto.rawValue)
        produtoRef.observe(.value) { (snap) in
            if snap.childrenCount > 0 {
                self.produtosList.removeAll()
                for produtos in snap.children.allObjects as! [DataSnapshot]{
                    let produtoObject = produtos.value as? [String: AnyObject]
                    let produtoNome = produtoObject?["nome_item"]
                    let produtoImagem = produtoObject?["imagem"]
                    //let produtoImagens = produtoObject?["imagens"]
                    let produtoMes = produtoObject?["mes"]
                    let produtoPreco = produtoObject?["preco"]
                    
                    let produto = Produto(nome_item: produtoNome as? String , preco: produtoPreco as? String,
                                          imagem: produtoImagem as? String,
                                          mes: produtoMes as? String, imagens: [""] )
                    self.produtosList.append(produto)
                }
            }
            self.produtoTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(produtosList.count)
        return produtosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdutoTableViewCell") as! ProdutoTableViewCell
        let produto = produtosList[indexPath.row]
        cell.nomeProduto.text = produto.nome_item
        if let month = produto.mes{
        cell.mesProduto.text = "Mês " + month
        }
        cell.precoProduto.text = produto.preco
        downloadImage(url: produto.imagem ?? "", downloadImageView: cell.imagemProduto)
        
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
