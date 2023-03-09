//
//  FilterTabView.swift
//  PostsApp
//
//  Created by MacBook Pro on 09/03/23.
//

import SwiftUI

struct FilterTabView: View {
        
    var categories: [FilterType]
    var action: (FilterType) -> Void
    @State var selection: FilterType = FilterType.allPosts
    
    var body: some View {
        VStack {
            Picker(StringContant.txt.selectOption, selection: $selection) {
                ForEach(categories, id: \.self) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .onChange(of: selection) { tag in
                action(tag)
            }
            .pickerStyle(.segmented)
        }
    }
}


struct FilterTabView_Previews: PreviewProvider {
    static var previews: some View {
        FilterTabView(categories: FilterType.allCases, action: {_ in})
    }
}

