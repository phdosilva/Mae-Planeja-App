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
        //localSource = [ImageSource(image: UIImage(named: produto?.imagens[0] ?? "img1")!), ImageSource(image: UIImage(named: produto?.imagens[1] ?? "")!),ImageSource(image: UIImage(named: produto?.imagens[2] ?? "img1")!)]
        localSource = [ImageSource(image: UIImage(named: "img1")!), ImageSource(image: UIImage(named: "img2")!)]
        slideShow.setImageInputs(localSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProdutoDetalhesViewController.didTap))
        slideShow.addGestureRecognizer(recognizer)
        
        /* IMAGE SLIDE */
    }
    
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
