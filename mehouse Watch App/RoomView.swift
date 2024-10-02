//
//  RoomView.swift
//  mehouse Watch App
//
//  Created by adi on 2024/10/2.
//

import SwiftUI

struct RoomView: View {
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    private let imageSize: CGFloat = 500  // 固定的圖片大小
    private let screenSize: CGFloat = 200  // 假設 Apple Watch 的屏幕大小為 200x200
    
    var body: some View {
        ZStack {
            Image("back-bedroom")
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)  // 固定背景圖片大小
                .offset(x: offset.width + lastOffset.width, y: offset.height + lastOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // 計算新的偏移量
                            let newOffset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                            
                            // 限制偏移量，防止圖片移出邊界
                            self.offset = CGSize(
                                width: max(min(newOffset.width, (imageSize - screenSize) / 2), -(imageSize - screenSize) / 2),
                                height: max(min(newOffset.height, (imageSize - screenSize) / 2), -(imageSize - screenSize) / 2)
                            )
                        }
                        .onEnded { _ in
                            // 偏移量累積
                            self.lastOffset = self.offset
                            self.offset = .zero  // 重置臨時的 offset
                        }
                )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct RoomView_Preview: PreviewProvider {
    static var previews: some View {
        RoomView()
    }
}
