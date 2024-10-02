//
//  ContentView.swift
//  mehouse Watch App
//
//  Created by adi on 2024/10/2.
//

import SwiftUI

struct ContentView: View {
    // 初始人物位置
    @StateObject private var character = CharacterController()
    @State private var backgroundOffset: CGSize = .zero
    private let step: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // background
                Image("back-bedroom")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .offset(x: backgroundOffset.width, y: backgroundOffset.height)
                    .frame(width: geometry.size.width * 2, height: geometry.size.height * 2)  // 背景比螢幕大，允許滑動
                
                // 顯示人物
                Image("Pink_Monster")
                   .resizable()
                   .frame(width: 50, height: 50)
                   .position(character.postition)
            }
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                            // 在手勢移動過程中動態更新背景偏移
                            updateBackgroundOffset(translation: value.translation, screenWidth: geometry.size.width, screenHeight: geometry.size.height)
                        }
                    .onEnded { value in
                        // 計算滑動的方向
                        let dragDirection = character.getDragDirection(translation: value.translation)
                        character.move(direction: dragDirection)
//                        updateBackgroundOffset(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
                    }
            )
        }
    }
    
    // 更新背景的 offset，限制背景偏移在合理範圍內
    func updateBackgroundOffset(translation: CGSize, screenWidth: CGFloat, screenHeight: CGFloat) {
        let maxOffsetX = (screenWidth * 0.5)  // 設置背景橫向最大可偏移量
        let maxOffsetY = (screenHeight * 0.5)  // 設置背景縱向最大可偏移量
        
        // 動態更新背景的水平和垂直偏移，限制移動範圍
        let newOffsetX = backgroundOffset.width - translation.width / 10
        let newOffsetY = backgroundOffset.height - translation.height / 10
        
        backgroundOffset.width = max(min(newOffsetX, maxOffsetX), -maxOffsetX)
        backgroundOffset.height = max(min(newOffsetY, maxOffsetY), -maxOffsetY)
        
        // Logging 更新後的背景偏移
        print("Updated background offset: \(backgroundOffset)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
