//
//  Button.swift
//  ourstory
//
//  Created by Songjeongpyeong on 9/11/24.
//

import SwiftUI

public struct MDIconButton: View {
    private let icon: Image
    private let size: CGSize
    private let accent: Bool
    private let action: () -> Void
    
    public init(_ icon: Image,
                accent: Bool = true,
                size: CGSize = CGSize(width: 19, height: 19),
                action: @escaping () -> Void
    ){
        self.icon = icon
        self.size = size
        self.accent = accent
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            VStack {
                icon
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: size.width, height: size.height)
        }
    }
}

public struct MDTextIconButton: View {
    private let icon: Image
    private var title: String?
    private let size: CGSize
    private let accent: Bool
    private let action: () -> Void
    
    public init(_ icon: Image,
                title:String?,
                accent: Bool = true,
                size: CGSize = CGSize(width: 70, height: 19),
                action: @escaping () -> Void
    ){
        self.icon = icon
        self.title = title
        self.size = size
        self.accent = accent
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                
                icon
                    .scaledToFit()
                
                MDTextView(text: "\(self.title ?? "")",
                           size: 20,
                           style: .bold,
                           color: .green,
                           maxLines: 2,
                           lineSpacing: 10,
                           alignment: .center)
            }
            .fixedSize(horizontal: true, vertical: true)
//            .frame(width: size.width, height: size.height)
        }
    }
}
