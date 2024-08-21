//
//  DynamicHeightSheet.swift
//  bbatm
//
//  Created by Полина Лущевская on 23.05.24.
//

import UIKit
import SwiftUI

struct DynamicHeightSheet<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let content: () -> Content
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard isPresented else { return }
        
        let sheetController = DynamicHeightSheetController(rootView: content(), isPresented: $isPresented)
        uiViewController.present(sheetController, animated: true)
    }
}
