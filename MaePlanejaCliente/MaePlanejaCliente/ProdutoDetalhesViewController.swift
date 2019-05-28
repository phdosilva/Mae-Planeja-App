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
    
    let localSource = [ImageSource(image: UIImage(named: "img1")!), ImageSource(image: UIImage(named: "img2")!)]
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    
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
