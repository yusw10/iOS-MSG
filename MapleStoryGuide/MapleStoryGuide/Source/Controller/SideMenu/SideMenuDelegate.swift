//
//  SideMenuDelegate.swift
//  MapleStoryGuide
//
//  Created by 유한석 on 2023/02/07.
//

protocol SideMenuDelegate: AnyObject {
    func menuButtonTapped()
    func itemSelected(item: ContentViewControllerPresentation)
    func configureOpacity(state: Bool)
}
