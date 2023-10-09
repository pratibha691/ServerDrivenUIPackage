//
//  PSTextFieldBuilder.swift
//  SDUSampleApp
//
//  Created by Pawan Sharma on 22/09/23.
//

import Foundation
import SwiftUI

struct PSTextFieldBuilder: UIComponentBuilder {
    
    typealias ComponentType = PSTextField
    let viewModel: LaunchViewModelProtocol
    @FocusState var focusedField: String?

    init(viewModel: LaunchViewModelProtocol, focusV: FocusState<String?>) {
        self.viewModel = viewModel
        _focusedField = focusV
    }
    @MainActor
    func build(element: SubView) -> PSTextField {
        let binding = Binding(
            get: { viewModel.getTextFieldValue(for: element.identifier) },
            set: { newValue in viewModel.setTextFieldValue(for: element.identifier, value: newValue, validation: element.properties.validation) }
        )
        let errorBinding = Binding(
            get: {  viewModel.textFieldErrorMessage[element.identifier] ?? "" }, 
            set: { newValue in
                viewModel.setErrorTextFieldValue(for: element.identifier, value: newValue)
            }
        )
        let keyboard = element.properties.keyboardType ?? ""
        let configuration = PSTextFieldConfig(text: binding, 
                                              keyboardType: keyboard.keyboardType(),
                                              placeHolder: element.properties.placeHolder,
                                              height: CGFloat(element.properties.size.height),
                                              width: CGFloat(element.properties.size.width),
                                              backgroundColor: element.properties.backgroundColor, 
                                              padding: EdgeInsets(top: CGFloat(element.properties.padding.top),
                                                                  leading: CGFloat(element.properties.padding.paddingLeft),
                                                                  bottom: CGFloat(element.properties.padding.bottom),
                                                                  trailing: CGFloat(element.properties.padding.paddingRight)),
                                              validation: element.properties.validation,
                                              error: errorBinding, 
                                              isErrorMessage: element.properties.isErrorMessage,
                                              identifier: element.identifier)
        let customTextField = PSTextField(configuration: configuration, focus: _focusedField, nextFocusIdentifer: { formValue in
            if let index = self.viewModel.formFields.firstIndex(where: {$0 == formValue}) {
                self.focusedField = self.viewModel.formFields.indices.contains(index + 1) ? self.viewModel.formFields[index + 1] : ""
            }
        })
        return customTextField
    }
}
