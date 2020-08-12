//
//  NeoWidget.swift
//  NeoWidget
//
//  Created by Jordan Christensen on 7/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

//
//  NeoWidget.swift
//  NeoWidget
//
//  Created by Jordan Christensen on 7/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = PlayerController
    
    func placeholder(in context: Context) -> PlayerController {
        PlayerController()
    }
    
    func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
        // Player Configuration
        let player = Entry()
        
        
        completion(player)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(Timeline(entries: [Entry(date: Date())], policy: .atEnd))
    }
}

struct NeoWidgetView : View {
    @ObservedObject var player: PlayerController
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [UIColor.topGradientColor.color, UIColor.bottomGradientColor.color]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 2) {
                let song = player.currentSong
                
                HStack {
                    Text(song.title)
                        .font(Font.system(.subheadline).smallCaps())
                        .lineLimit(1)
                    
                    if song.isExplicit {
                        Image(systemName: "e.square.fill")
                    }
                }
                
                CustomImageView(isPlaying: true, image: song.artwork)

                Spacer()
            }
        }
    }
}

@main
struct NeoWidget: Widget {
    private let kind: String = "NeoWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { player in
            NeoWidgetView(player: player)
        }
            .configurationDisplayName("NeoWidget")
            .description("View your music through a widget.")
    }
}

struct NeoWidget_Previews: PreviewProvider {
    static var previews: some View {
        NeoWidgetView(player: PlayerController())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("NeoWidget")
            .environment(\.colorScheme, .dark)
    }
}
