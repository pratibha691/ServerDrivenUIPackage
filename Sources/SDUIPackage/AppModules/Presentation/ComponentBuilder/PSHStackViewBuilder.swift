//
//  PSHStackViewBuilder.swift
//  SDUSampleApp
//
//  Created by Pawan Sharma on 26/09/23.
//

import Foundation
import SwiftUI
struct PSHStackViewBuilder: UIComponentBuilder {
    
    typealias ComponentType = PSHStackView
    let viewModel: LaunchViewModelProtocol
    
    @FocusState var focusedField: String?
    init(viewModel: LaunchViewModelProtocol, focus: FocusState<String?>) {
        self.viewModel = viewModel
        _focusedField = focus
    }
    
    @MainActor
    func build(element: SubView) -> PSHStackView {
        PSHStackView(
            configuration: PSHStackViewConfiguration(
                content: {
                    ForEach(element.subviews ?? [], id: \.identifier) { field in
                        PSScreenBuilder(viewModel: viewModel, focus: _focusedField).createComponentView(field)
                    }
                },
                backgroundColor: element.properties.backgroundColor, 
                spacing: CGFloat(element.properties.spacing)
            )
        )
    }
}

