//
//  ProdutoDetalhesViewController.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 23/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProdutoDetalhesViewController: UIViewController, UIScrollViewDelegate {

    var produto: Produto?
    var localSource: [ImageSource] = []
   
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var descProduto: UILabel!
    @IBOutlet weak var nomeLoja: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* IMAGE SLIDE */
        slideShow.slideshowInterval = 5.0
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideShow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideShow.pageIndicator = pageControl
        
        nomeProduto.text = produto?.nome_item
        descProduto.text = produto?.descProduto
        nomeLoja.text = produto?.nome_loja
        
        for urlString in produto?.imagens ?? ["img1"]{
            if urlString != ""{
                let url = URL(string: urlString)!
                downloadImage(from: url)
            }
            else{
                localSource.append(ImageSource(image: UIImage(named: "img1")!))
            }
        }
       
        
    }
    
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                if let image = UIImage(data: data){
                    self.localSource.append(ImageSource(image: image))
                    if(self.localSource.count>=2){
                        self.slideShow.setImageInputs(self.localSource)
                        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProdutoDetalhesViewController.didTap))
                        self.slideShow.addGestureRecognizer(recognizer)
                    }
                }
            }
        }
    }
}
