//
//  DigitalWatch.swift
//  Watchkit Extension
//
//  Created by adi on 2024/10/2.
//

import SwiftUI

struct DigitalWatch: View {
    
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    @EnvironmentObject var config: Config

    @GestureState var press = false
    
    @State var digitOne = "1"
    @State var digitTwo = "0"
    @State var digitColon = "colon"
    @State var digitThree = "2"
    @State var digitFour = "1"
    @State var glowing = false
    @State var lastTime = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let width = 32.0
    
    func updateClock() {
        let date = Date()
        let calendar = Calendar.current
        var hour = String(calendar.component(.hour, from: date))
        var minutes = String(calendar.component(.minute, from: date))
        if hour.count == 1 {
            hour = "0" + hour
        }
        if minutes.count == 1 {
            minutes = "0" + minutes
        }
        digitOne = String(hour.prefix(1))
        digitTwo = String(hour.suffix(1))
        digitThree = String(minutes.prefix(1))
        digitFour = String(minutes.suffix(1))
    }
    
    var body: some View {
        ZStack {
            glowing ? config.theme.colorAGlow : config.theme.colorA
            VStack {
                Image("digital-watch-top-line").renderingMode(.template).interpolation(.none).resizable().frame(height: 4).foregroundColor(glowing ? config.theme.colorBGlow : config.theme.colorB)
                Spacer()
            }
            HStack (spacing: 0) {
                Image("digit-" + digitOne).renderingMode(.template).interpolation(.none).resizable().aspectRatio(contentMode: .fit).frame(width: width).foregroundColor(glowing ? config.theme.colorCGlow : config.theme.colorC)
                Image("digit-" + digitTwo).renderingMode(.template).interpolation(.none).resizable().aspectRatio(contentMode: .fit).frame(width: width).foregroundColor(glowing ? config.theme.colorCGlow : config.theme.colorC)
                Image(digitColon).renderingMode(.template).interpolation(.none).resizable().aspectRatio(contentMode: .fit).frame(width: width / 2.5).foregroundColor(glowing ? config.theme.colorCGlow : config.theme.colorC)
                Image("digit-" + digitThree).renderingMode(.template).interpolation(.none).resizable().aspectRatio(contentMode: .fit).frame(width: width).foregroundColor(glowing ? config.theme.colorCGlow : config.theme.colorC)
                Image("digit-" + digitFour).renderingMode(.template).interpolation(.none).resizable().aspectRatio(contentMode: .fit).frame(width: width).foregroundColor(glowing ? config.theme.colorCGlow : config.theme.colorC)
            }.onReceive(timer) { _ in
                self.digitColon = self.digitColon == "colon" && !isLuminanceReduced ? "colon-blank" : "colon"
                if glowing && Int(Date().timeIntervalSince1970) - lastTime > 3 {
                    glowing = false
                }
                updateClock()
            }.onAppear(perform: updateClock)
            VStack {
                Spacer()
                HStack (alignment: .bottom, spacing: 0) {
                    ZStack {
                        Image("mouse-b").renderingMode(.template).interpolation(.none).resizable().aspectRatio(contentMode: .fit).frame(height: 44).foregroundColor(glowing ? config.theme.colorBGlow : config.theme.colorB)
                        Image("mouse-c").renderingMode(.template).interpolation(.none).resizable().aspectRatio(contentMode: .fit).frame(height: 44).foregroundColor(glowing ? config.theme.colorCGlow : config.theme.colorC)
                    }
                    Image("digital-watch-line").renderingMode(.template).interpolation(.none).resizable().frame(height: 44).foregroundColor(glowing ? config.theme.colorBGlow : config.theme.colorB)
                }
            }
        }.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ touch in
                    glowing = true
                    lastTime = Int(Date().timeIntervalSince1970)
                })
                .onEnded({ touch in
                    glowing = false
                })
        )
    }
}

struct DigitalWatch_Previews: PreviewProvider {
    static var previews: some View {
        DigitalWatch().environmentObject(Config()).ignoresSafeArea(.all).navigationBarHidden(true).previewDevice("Apple Watch Series 6 - 40mm")
    }
}

