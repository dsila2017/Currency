//
//  UIApplicationExtension.swift
//  Currency
//
//  Created by David on 3/21/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
