//
//  Alertable.swift
//  StockTracker
//
//  Created by Ankit Sharma on 10/01/24.
//

import SwiftUI

struct AlertModel {
    let title: String
    @Binding var message: String
}

extension View {
    func showAlert(isPresented: Binding<Bool>, model: AlertModel, completion: (() -> Void)? = nil) -> some View {
        modifier(AlertModifier(isPresented: isPresented, model: model, completion: completion))
    }
}

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let model: AlertModel
    let completion: (() -> Void)?
    
    func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            Alert(title: Text(model.title), message: Text(model.message), dismissButton: .default(Text("OK"), action: {
                completion?()
            }))
        }
    }
}

