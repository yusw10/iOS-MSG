//
//  ViewControllerPresentation.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/07.
//

import UIKit

enum ContentViewControllerPresentation {
    case embed(ContentViewController)
    case push(UIViewController)
    case modal(UIViewController)
}
