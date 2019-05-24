//
//  ProdutoDetalhesViewController.swift
//  MaePlanejaCliente
//
//  Created by Otavio Vera Cruz Gomes on 23/05/19.
//  Copyright © 2019 Cin Ufpe. All rights reserved.
//

import UIKit

class ProdutoDetalhesViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var produto: Produto?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[Slide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        //downloadImage(url: produto?.imagem ?? "", downloadImageView: self.imageView)
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        if let imgUrl = produto?.imagem{
            downloadImage(url: imgUrl, downloadImageView: slide1.imageView)
        }
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        if let imgUrl = produto?.imagem{
            downloadImage(url: imgUrl, downloadImageView: slide1.imageView)
        }
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        if let imgUrl = produto?.imagem{
            downloadImage(url: imgUrl, downloadImageView: slide1.imageView)
        }
        
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        //scrollView.isPagingEnabled = true
        //scrollView.alwaysBounceVertical = false
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    @objc func downloadImage(url:String,downloadImageView:UIImageView){
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
