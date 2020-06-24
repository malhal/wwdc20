//
//  UIApplication+endEditing.swift
//  ScrollToNewItem
//
//  Created by Наталия Панферова on 24/06/20.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
