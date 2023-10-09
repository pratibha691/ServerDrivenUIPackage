////
////  PSScrollViewBuilder.swift
////  SDUSampleApp
////
////  Created by Pawan Sharma on 22/09/23.
////

import Foundation
import SwiftUI

struct PSScrollViewViewBuilder: UIComponentBuilder {
    
    typealias ComponentType = PSScrollView
    let viewModel: LaunchViewModelProtocol
    @FocusState var focusedField: String?
    init(viewModel: LaunchViewModelProtocol, focus: FocusState<String?>) {
        self.viewModel = viewModel
        _focusedField = focus
    }
    @MainActor
    func build(element: SubView) -> PSScrollView {
        PSScrollView(configuration: PSScrollViewConfig(content: {
            ForEach(element.subviews ?? [], id: \.identifier) { field in
                PSScreenBuilder(viewModel: viewModel, focus: _focusedField).createComponentView(field)
            }
        }), focusedField: _focusedField)
        
    }
}
