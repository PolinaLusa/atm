//
//  DynamicHeightSheetController.swift
//  bbatm
//
//  Created by Полина Лущевская on 23.05.24.
//

import SwiftUI
import UIKit

final class DynamicHeightSheetController<Content: View>: UIHostingController<Content>, UIAdaptivePresentationControllerDelegate {
    @Binding var isPresented: Bool
    
    init(rootView: Content, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        super.init(rootView: rootView)
    }
    
    @available(*, unavailable)
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.isModalInPresentation = false
        self.presentationController?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.isPresented = false
    }
}
