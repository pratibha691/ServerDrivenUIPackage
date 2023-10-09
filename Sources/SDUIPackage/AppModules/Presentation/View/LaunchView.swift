//
//  LaunchView.swift
//  SDUSampleApp
//
//  Created by Pawan Sharma on 21/09/23.
//

import SwiftUI

public struct LaunchView: View {
    
    @ObservedObject private var psViewModel: LaunchViewModel
    @FocusState var focusedField: String?
    public init(screenIdentifier: String) {
        self.psViewModel = LaunchViewModel(useCase: LaunchUseCase(repository: LaunchViewRepository(service: LocalService())))
        self.psViewModel.screenIdentifier = screenIdentifier
        _focusedField = .init()
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            NavigationView {
                ForEach(psViewModel.currentScreenData?.body.subviews ?? [], id: \.identifier) { element in
                    PSScreenBuilder(viewModel: psViewModel, focus: _focusedField).createComponentView(element)
                }
                
                NavigationLink(
                    "", destination: LaunchView(screenIdentifier: psViewModel.screenIdentifier)
                )
                
            }.onAppear {
                Task {
                    await psViewModel.getScreenData()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//       // LaunchView(screenIdentifier: "onboarding")
//    }
//}
