//
//  CustomImageView.swift
//  NeoWidgetExtension
//
//  Created by Jordan Christensen on 7/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CustomImageView: View {
    @State var isPlaying: Bool
    var image: UIImage
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [UIColor.topGradientColor.color, UIColor.bottomGradientColor.color]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.4), radius: 25, x: 25, y: 25)
                    .shadow(color: Color.white.opacity(0.1), radius: 15, x: -15, y: -15)
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .font(Font.system(.headline).weight(.bold))
                    .foregroundColor(UIColor.buttonColor.color)
                    .frame(width: geometry.size.width - 10, height: geometry.size.height - 10, alignment: .center)
                    .background(LinearGradient(gradient: Gradient(colors: [UIColor.bottomGradientColor.color, UIColor.topGradientColor.color]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .edgesIgnoringSafeArea(.all)
                                    .clipShape(Circle()))
                    .clipShape(Circle())
                
                Image(uiImage: imageForPlaybackState())
                    .resizable()
                    .frame(width: geometry.size.width / 3, height: geometry.size.height / 3, alignment: .center)
                    .colorMultiply(.red)
                    .opacity(0.4)
                    
            }.accentColor(.blue)
        }
    }
    
    func imageForPlaybackState() -> UIImage {
        isPlaying ? .pause : .play
    }
}

struct CustomImageView_Previews: PreviewProvider {
    static var previews: some View {
        CustomImageView(isPlaying: false, image: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
