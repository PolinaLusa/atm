//
//  View+Ext.swift
//  bbatm
//
//  Created by Полина Лущевская on 23.05.24.
//

import SwiftUI

extension View {
    func dynamicHeightSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping(() -> Content)) -> some View {
        self.background(DynamicHeightSheet(isPresented: isPresented, content: content))
    }
}
