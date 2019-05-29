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

import NavigationDrawer

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var produtoTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var valorTotal: UILabel!
    
    var produtosList:[Produto] = []
    var produtosListFinal: [Produto] = []
    let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        //populate()
        //populateLoja()
        //popularEndereco()
       // popularCliente()
        self.produtoTableView.dataSource  = self
        self.produtoTableView.delegate = self
        let produtoRef = Database.database().reference().child(EnumTables.Produto.rawValue)
        produtoRef.queryOrdered(byChild: "nome_loja").observe(.value) { (snap) in
            if snap.childrenCount > 0 {
                self.produtosList.removeAll()
                for produtos in snap.children.allObjects as! [DataSnapshot]{
                    let produtoObject = produtos.value as? [String: AnyObject]
                    let produtoNome = produtoObject?["nome_item"]
                    let produtoImagem = produtoObject?["imagem"]
                    let produtoImagens = produtoObject?["imagens"]
                    let produtoMes = produtoObject?["mes"]
                    let produtoPreco = produtoObject?["preco"]
                    let nomeLoja = produtoObject?["nome_loja"]
                    let recomendacao = produtoObject?["recomendacao"]
                    let descProduto = produtoObject?["descProduto"]
                    let taNaLista = produtoObject?["taNaLista"]
                    let produto = Produto(nome_item: produtoNome as? String , preco: produtoPreco as? String,
                                          imagem: produtoImagem as? String, mes: produtoMes as? String, imagens: produtoImagens as! [String],
                                          nome_loja: nomeLoja as? String,recomendacao: recomendacao as? String, descProduto: descProduto as? String, taNaLista: taNaLista as? Int)
                    self.produtosList.append(produto)
                }
            }
            self.produtoTableView.reloadData()
        }
        
        estilizarViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        atualizarValoresEListaFinal()
    }
    
    func atualizarValoresEListaFinal() {
        produtosListFinal = Produto.getProdutos() ?? []
        
        var valorT:Double = 0.0
        for produto in produtosListFinal {
            valorT += getValue(valor: produto.preco ?? "") ?? 0.0
        }
        valorTotal.text = "R$ " + String(valorT)
    }
    
    func estilizarViews() {
        valorTotal.layer.borderWidth = 0.1
        valorTotal.layer.cornerRadius = 5
    }

    /** TableView **/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(produtosList.count)
        return produtosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProdutosTableViewCell") as! ProdutosTableViewCell
        let produto = produtosList[indexPath.row]
        cell.descProdutoTextView.text = produto.nome_item
        cell.precoTextView.text = produto.preco
        cell.lojaTextView.text = produto.nome_loja
        cell.recomendacaoTextView.text = Produto.getRecomendacao(nivel: produto.recomendacao ?? "Recomendado")
        downloadImage(url: produto.imagem ?? "", downloadImageView: cell.produtoImageView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
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
    
    /* ----- MENU ----- */
    
    @IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSlidingMenu", sender: nil)
    }
    
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.performSegue(withIdentifier: "showSlidingMenu", sender: nil)
        }
    }
    
    @IBAction func finalizar(_ sender: Any) {
        print(produtosListFinal.count)
        Produto.save(itens: produtosListFinal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlidingViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
        }else if let destinationViewController = segue.destination as? ProdutoDetalhesViewController {
            destinationViewController.produto = sender as? Produto
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let produto = produtosList[indexPath.row]
        self.performSegue(withIdentifier: "showProduto", sender: produto)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let add = AddAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [add])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Remover") { (action, view, completion) in
            if self.produtosListFinal.contains(self.produtosList[indexPath.row]){
                if let index = self.produtosListFinal.index(of: self.produtosList[indexPath.row]){
                    self.produtosListFinal.remove(at: index)
                    if let valorT = self.produtosList[indexPath.row].preco{
                        self.decTotal(valor: valorT)
                        print("Excluído!")
                    }
                }
            }
            //self.produtoTableView.deleteRows(at: [indexPath], with: .right)
            completion(true)
        }

        action.image = #imageLiteral(resourceName: "cancelar")
        action.backgroundColor = .red

        return action
    }
    
    func AddAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Adicionar") { (action, view, completion) in
             if !self.produtosListFinal.contains(self.produtosList[indexPath.row]){
                self.produtosListFinal.append(self.produtosList[indexPath.row])
                print("Adicionado \(String(describing: self.produtosListFinal.last?.nome_item))")
                self.incTotal(valor: self.produtosList[indexPath.row].preco ?? "20")
            }
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "adicionar")
        action.backgroundColor = .green
        
        return action
    }
    
    func incTotal(valor: String){
        if let val = getValue(valor: valor),let valorT = self.valorTotal.text, let val2 = getValue(valor:valorT){
            let total = val + val2
            let texto = "R$ " + String(total).replace(target: ".", withString: ",")
            self.valorTotal.text = texto
            print("T \(texto)")
        }

    }
    
    func decTotal(valor: String){
        if let val = getValue(valor: valor),let valorT = self.valorTotal.text, let val2 = getValue(valor:valorT){
            let total = val2 - val
            let texto = "R$ " + String(total).replace(target: ".", withString: ",")
            self.valorTotal.text = texto
            print("T \(texto)")
        }
    }
    
    func getValue(valor: String) -> Double?{
        let index = valor.index(valor.startIndex, offsetBy: 3)
        let value = valor[index...]
        let valString = String(value).replace(target: ",", withString: ".")
        return valString.toDouble()
    }
    
    
    /* ----- MENU ----- */
    
//    func populate(){
//        let ref: DatabaseReference! = Database.database().reference()
//        let produtoRef = ref.child(EnumTables.ProdutoLoja.rawValue)
//        let imgs = ["img01","img02","img03"]
//        let produtos = [Produto(nome_item: "Fralda", preco: "R$ 20,00", imagem: "img01", mes: "3",imagens:imgs,nome_loja: "",recomendacao: ""),
//                        Produto(nome_item: "Carrinho de bebê", preco: "R$ 350,00", imagem: "img01", mes: "6",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Mamadeira", preco: "R$ 15,00", imagem: "img01", mes: "5",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Berço", preco: "R$ 400,00", imagem: "img01", mes: "6",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Cômoda", preco: "R$ 300,00", imagem: "img01", mes: "6",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Macacão", preco: "R$ 20,00", imagem: "img01", mes: "5",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Fralda de pano", preco: "R$ 5,00", imagem: "img01", mes: "5",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Pano umidecido", preco: "R$ 10,00", imagem: "img01", mes: "5",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Banheira", preco: "R$ 350,00", imagem: "img01", mes: "5",imagens:imgs,nome_loja: "tes",recomendacao: "1"),
//                        Produto(nome_item: "Pote de leite", preco: "R$ 5,00", imagem: "img01", mes: "7",imagens:imgs,nome_loja: "tes",recomendacao: "1")]
//
//        for produto in produtos{
//            let key = produtoRef.childByAutoId().key
//            let prod = ["nome_item":produto.nome_item ?? "nome","preco":produto.preco ?? "R$100,00","imagem": produto.imagem ?? "img","mes":produto.mes ?? "3","imagens":produto.imagens,"nome_loja":produto.nome_loja ?? "Loja","recomendacao":produto.recomendacao ?? "1"] as [String : Any]
//            produtoRef.child(key!).setValue(prod)
//        }
//    }

    func popularEndereco()
    {
        let ref = Database.database().reference()
        let lojaRef = ref.child("Endereco")
        
        let itens = [
            Endereco(rua: "rua" , bairro: "bairro", cep: "cep", numero: "123")
        ]
        
        for item in itens {
            let key = lojaRef.childByAutoId().key
            lojaRef.child(key!).setValue(["rua": item.rua, "bairro": item.bairro, "CEP": item.cep, "numero": item.numero])
//            lojaRef.child(key!).set
        }
    }
    
   
    
    func popularCliente() {
        let ref = Database.database().reference()
        let lojaRef = ref.child("Usuario")
        
        let pessoas = [
            Cliente(sexoBb: Sexo.feminino.rawValue, mesesGestacao: "9")
        ]
        
        for pessoa in pessoas {
            let key = lojaRef.childByAutoId().key
            let aux = ["sexoBB": pessoa.sexoBb, "mesesGestacao": pessoa.mesesGestacao]
            lojaRef.child(key!).setValue(aux)
        }
    }
    
    
    //ajustar
    func popularLoja() {
        let ref = Database.database().reference()
        let lojaRef = ref.child("Loja")
        let key = lojaRef.childByAutoId().key
        let item = ["nome":"teste", "outro_item": "2"]
        
        lojaRef.child(key!).setValue(item)
        print("foi")
    }
    

}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    func toDouble() -> Double {
        if let unwrappedNum = Double(self) {
            return unwrappedNum
        } else {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Double")
            return 0.0
        }
    }
}
