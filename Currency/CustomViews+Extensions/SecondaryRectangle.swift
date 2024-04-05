//
//  SecondaryRectangle.swift
//  Currency
//
//  Created by David on 3/21/24.
//

import Foundation
import SwiftUI

struct secondaryRectangle: View {
    @StateObject var model: mainPageViewModel
    var text: String
    var result: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .continuous)
                .frame(maxWidth: .infinity, maxHeight: 56)
                .foregroundStyle(.color)
            HStack {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(result)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .foregroundStyle(.customText)
            .font(.subheadline.weight(.medium))
        }
    }
}
