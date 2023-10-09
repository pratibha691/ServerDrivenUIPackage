//
//  PSViewBuilder.swift
//  SDUSampleApp
//
//  Created by Pratibha Gupta on 22/09/23.
//

import Foundation
import SwiftUI
struct PSViewBuilder: UIComponentBuilder {
    
    typealias ComponentType = PSView
    let viewModel: LaunchViewModelProtocol
    
    @FocusState var focusedField: String?
    init(viewModel: LaunchViewModelProtocol, focus: FocusState<String?>) {
        self.viewModel = viewModel
        _focusedField = focus
    }
    
    @MainActor
    func build(element: SubView) -> PSView {
        PSView(
            configuration: PSViewConfiguration(
                content: {
                    ForEach(element.subviews ?? [], id: \.identifier) { field in
                        PSScreenBuilder(viewModel: viewModel, focus: _focusedField).createComponentView(field)
                    }
                },
                backgroundColor: element.properties.backgroundColor
            )
        )
    }
}
