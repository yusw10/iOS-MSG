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
        
        let repository: APIJobInfoRepository = DefaultJobInfoRepository()
//        let useCase = CommonJobInfoUseCase(repository: repository)
        let viewModel = JobInfoViewModel(repository: repository)
        
        viewModel.jobListInfo.bind { jobinfo in
            print(jobinfo)
        }
        
        let task = Task {
            await viewModel.trigger(query: .jsonQuery)
        }
    }


}

