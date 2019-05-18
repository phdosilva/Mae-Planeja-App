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

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let interactor = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populate()
        //populateLoja()
        //popularEndereco()
        popularCliente()
    }
    
    func populateLoja() {
        let ref = Database.database().reference()
        let lojaRef = ref.child("Loja")
        let key = lojaRef.childByAutoId().key
        let item = ["nome":"teste", "outro_item": "2"]
        
        lojaRef.child(key!).setValue(item)
        print("foi")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlidingViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
        }
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
    
    /* ----- MENU ----- */
    
    func populate(){
        let ref: DatabaseReference! = Database.database().reference()
        let produtoRef = ref.child("Produto")
        let imgs = ["img01","img02","img03"]
        let produtos = [Produto(nome_item: "Fralda", preco: "R$ 20,00", imagem: "", mes: "3",imagens:imgs),
                        Produto(nome_item: "Carrinho de bebê", preco: "R$ 350,00", imagem: "", mes: "6",imagens:imgs),
                        Produto(nome_item: "Mamadeira", preco: "R$ 15,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Berço", preco: "R$ 400,00", imagem: "", mes: "6",imagens:imgs),
                        Produto(nome_item: "Cômoda", preco: "R$ 300,00", imagem: "", mes: "6",imagens:imgs),
                        Produto(nome_item: "Macacão", preco: "R$ 20,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Fralda de pano", preco: "R$ 5,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Pano umidecido", preco: "R$ 10,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Banheira", preco: "R$ 350,00", imagem: "", mes: "5",imagens:imgs),
                        Produto(nome_item: "Pote de leite", preco: "R$ 5,00", imagem: "", mes: "7",imagens:imgs)]
       
        for produto in produtos{
            let key = produtoRef.childByAutoId().key
            let prod = ["nome_item":produto.nome_item,"preco":produto.preco,"imagem": produto.imagem,"mes":produto.mes]
            produtoRef.child(key!).setValue(prod)
        }
    }

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
    
    func popularLoja() {
        
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

}

