//
//  BrickPhoneWidgetBundle.swift
//  BrickPhoneWidget
//
//  Created by Marcelo Monsalve on 11/27/24.
//

import WidgetKit
import SwiftUI

@main
struct BrickPhoneWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        BrickPhoneWidget()
        BlankWidget()
    }
}
