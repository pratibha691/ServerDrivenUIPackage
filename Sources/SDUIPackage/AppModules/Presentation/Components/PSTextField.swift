//
//  CustomTextField.swift
//  SDUSampleApp
//
//  Created by Pawan Sharma on 21/09/23.
//

import SwiftUI

//public enum FormFields: String, Hashable {
//    case first_name_text_field, middle_name_text_field, last_name_text_field, noValue
//}

protocol PSTextFieldConfiguration {
    var text: Binding<String> { get set }
    var keyboardType: UIKeyboardType { get }
    var placeHolder: String { get }
    var height: CGFloat { get }
    var width: CGFloat { get }
    var backgroundColor: String { get }
    var padding: EdgeInsets { get }
    var validation: ValidationRules? { get }
    var error: Binding<String>? { get set }
    var isErrorMessage: Bool { get }
    var identifier: String { get set}
}

struct PSTextFieldConfig: PSTextFieldConfiguration {
    var text: Binding<String>
    var keyboardType: UIKeyboardType
    var placeHolder: String
    var height: CGFloat
    var width: CGFloat
    var backgroundColor: String
    var padding: EdgeInsets
    var validation: ValidationRules?
    var error: Binding<String>?
    var isErrorMessage: Bool
    var identifier: String
}

struct PSTextField : View {
    var configuration: PSTextFieldConfiguration
    @State var textFieldText: String
    @State private var errorMessage: String = ""
    @State var isValid: Bool = false
    @FocusState var focusedField: String?
    var nextFocus: (String) -> Void
    init(configuration: PSTextFieldConfiguration, focus: FocusState<String?> , nextFocusIdentifer: @escaping (String) -> Void) {
        self.configuration = configuration
        _textFieldText = State(initialValue: configuration.text.wrappedValue)
        _focusedField = focus
        nextFocus = nextFocusIdentifer
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) { // Wrap in VStack to display error message
            
            TextField(configuration.placeHolder, text: $textFieldText)
                .keyboardType(configuration.keyboardType)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: configuration.height)
                .frame(maxWidth: configuration.width == 0 ? .infinity : configuration.width)
                .padding([.horizontal], 8)
                .cornerRadius(3)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(hex: configuration.backgroundColor))
                )
                .padding(configuration.padding)
                .focused($focusedField, equals: configuration.identifier)
                .onChange(of: textFieldText,
                          perform: { newValue in
                    configuration.text.wrappedValue = newValue
                    (isValid, errorMessage) = newValue.isValid(validations: configuration.validation)
                    if isValid {
                        configuration.error?.wrappedValue = ""
                    }
                    print("\(textFieldText)")
                }).onAppear {
                    if self.textFieldText.count == 0 {
                        configuration.text.wrappedValue = ""
                    }
                }.onSubmit() {
                    self.nextFocus(configuration.identifier)
                }.submitLabel(.next)
                
            
            if configuration.isErrorMessage {
                Text(errorMessage.count > 0 ? errorMessage : (isValid ? "" : (configuration.error?.wrappedValue ?? "")))
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 8)
                    .padding(.bottom, errorMessage.isEmpty ? 0 : 8)
            }
        }
    }
}
