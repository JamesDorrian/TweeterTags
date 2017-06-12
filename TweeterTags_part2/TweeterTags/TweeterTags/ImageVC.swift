//
//  File.swift
//  TweeterTags
//
//  Created by James Dorrian on 26/03/2017.
//  Copyright © 2017 JD_13369451. All rights reserved.
//

import UIKit
class ImageVC: UIViewController, UIScrollViewDelegate {
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    open var  imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageView.frame = CGRect(origin: CGPoint.zero, size: imageView.frame.size)
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView?.minimumZoomScale = min(0.2, scrollView.bounds.size.width / scrollView.contentSize.width)
        scrollView?.maximumZoomScale = 1.0
        scrollView?.zoomScale = scrollView.maximumZoomScale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                Thread.sleep(forTimeInterval: 0.8)
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if  url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERE WE ARE")
        scrollView.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
