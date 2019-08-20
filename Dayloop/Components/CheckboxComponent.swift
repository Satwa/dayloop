//
//  CheckboxComponent.swift
//  Dayloop
//
//  Created by Joshua Tabakhoff on 20/08/2019.
//  Copyright © 2019 Joshua Tabakhoff. All rights reserved.
//

import SwiftUI

struct CheckboxComponent: View {
    @Binding var checked: Bool?
    var body: some View {
        Group{
            (checked ?? false) ? Image(systemName: "checkmark.circle.fill").resizable() : Image(systemName: "circle").resizable()
        }
        .foregroundColor(.init("accentColor"))
        .frame(width: 20.0, height: 20.0)
    }
}

struct CheckboxComponent_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxComponent(checked: .constant(false))
    }
}
