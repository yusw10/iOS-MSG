//
//  WebViewController.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/04/11.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    var url: String = ""
    
    private let webView = WKWebView()

    init(url: String) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
