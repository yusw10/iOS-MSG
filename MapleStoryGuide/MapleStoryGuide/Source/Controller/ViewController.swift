//
//  ViewController.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/01/31.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: 임시
        view.backgroundColor = .red
        
        let endPoint = EndPoint(query: .jsonQuery)
        let urlSessionManager = URLSessionManager(endpoint: endPoint)
        let jsonManager = JSONManager()
        let task = Task {
            let data = try await urlSessionManager.fetchData()
            let jsonData: [JobInfo] = jsonManager.decodeToInfoList(from: data)!
            
            print(jsonData)
        }
    }


}

