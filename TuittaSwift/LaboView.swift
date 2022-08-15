//
//  LaboView.swift
//  TuittaSwift
//
//  Created by 小暮準才 on 2022/08/15.
//

import SwiftUI

struct LaboView: View {
    var body: some View {
        List(0..<5) { item in
            Button {
                
            } label: {
                Text(item.description)
            }

        }
        .listStyle(.plain )
    }
}

struct LaboView_Previews: PreviewProvider {
    static var previews: some View {
        LaboView()
    }
}
