//
//  MockSection.swift
//  MapleStoryGuide
//
//  Created by brad on 2023/02/01.
//

import Foundation
import UIKit

enum MockSection {
    struct MainImage {
        let image: UIImage
    }
    
    struct Link {
        let title: String
        let image: UIImage
        let desc: String
    }
    
    struct Reinforce {
        let title: String
        let image: UIImage
        let desc: String
    }
    
    struct Matrix {
        let title: String
        let image: UIImage
        let desc: String
    }
    
    case mainImage([MainImage])
    case link([Link])
    case reinforce([Reinforce])
    case matrix([Matrix])
}


enum MockData {
    static let dataSource = [
        MockSection.mainImage(
            [
                .init(image: UIImage(named: "은월")!)
            ]
        ),
        .link(
            [
                .init(
                    title: "스피릿 오브 프리덤",
                    image: UIImage(named: "스피릿 오브 프리덤")!,
                    desc: "자유를 염원하는 레지스탕스가 가진 혼의 힘이다.\n월드 내 서로 다른 레지스탕스 직업군이 존재할 경우 한 캐릭터에 최대 4번 중복해서 링크 스킬 지급이 가능하다."
                )
            ]
        ),
        .reinforce(
            [
                .init(title: "폭류권", image: UIImage(named: "폭류권")!, desc: ""),
                .init(title: "귀참", image: UIImage(named: "귀참")!, desc: ""),
                .init(title: "소혼 장막", image: UIImage(named: "소혼 장막")!, desc: ""),
                .init(title: "여우령", image: UIImage(named: "여우령")!, desc: ""),
                .init(title: "정령의 화신", image: UIImage(named: "정령의 화신")!, desc: "")
            ]
        ),
        .matrix(
            [
                .init(title: "정령 집속", image: UIImage(named: "정령 집속")!, desc: ""),
                .init(title: "진 귀참", image: UIImage(named: "진 귀참")!, desc: ""),
                .init(title: "귀문진", image: UIImage(named: "귀문진")!, desc: ""),
                .init(title: "파쇄 연권", image: UIImage(named: "파쇄 연권")!, desc: ""),
            ]
        )
    ]
}
