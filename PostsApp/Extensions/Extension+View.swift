//
//  Extension+View.swift
//  PostsApp
//
//  Created by MacBook Pro on 08/03/23.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true:
            self.hidden()
            //self.opacity(0.6).disabled(true)
        case false:
            self
        }
    }
}


