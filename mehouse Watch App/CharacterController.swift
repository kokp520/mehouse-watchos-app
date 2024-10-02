//
//  CharacterController.swift
//  mehouse Watch App
//
//  Created by adi on 2024/10/2.
//

import SwiftUI

//enum Direction{
//    case up
//    case down
//    case right
//    case left
//}
enum Direction {
    case up, down, right, left
}

class CharacterController: ObservableObject {
    @Published var postition: CGPoint = CGPoint(x: 100, y:100)
    
    private let step: CGFloat = 10.0
    
    func move(direction: Direction){
        switch direction {
        case .up:
            postition.y -= step
        case .down:
            postition.y += step
        case .right:
            postition.x += step
        case .left:
            postition.x -= step
        }
        // Logging 移動後的位置
        print("Character moved to: \(postition)")
    }
    
    func getDragDirection(translation: CGSize) -> Direction {
        if abs(translation.width) > abs(translation.height){
            return translation.width > 0 ? .right : .left
        } else {
            return translation.height > 0 ? .down : .up
        }
    }
}
