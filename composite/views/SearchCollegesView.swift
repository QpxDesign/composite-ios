//
//  SearchCollegesView.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
import SwiftUI

struct SearchCollegesView: View {
    @State private var searchQueryText: String = ""
        var body: some View {
            GeometryReader { geometry in

            VStack {
                TextField(
                    "Yale University",
                    text: $searchQueryText
                ).padding(.horizontal, 15).padding(.vertical, 5).padding(.leading,20).font(Font.custom("SourceSerifPro-Regular", size: 28)).background(CustomColors.Slate100).frame(width:geometry.size.width * 0.95,height: 75).clipShape(Capsule())

                List(getMatchingSchoolNames(query: searchQueryText)) { institution in
                    HStack {
                        Text(institution.institution).font(Font.custom("SourceSerifPro-Regular",size:22))
                        Spacer()
                           HStack(spacing: 0) {
                               Image(systemName: "arrow.right")
                               .font(.system(size: 24, weight: .light))

                               NavigationLink(destination: CollegeDetailedView(collegeName:institution.institution)) {
                                 EmptyView()
                               }
                               .frame(width: 0)
                               .opacity(0)
                             }
                    }
                 
                }
            }.frame(maxWidth: .infinity, alignment: .center )
        }
    }
}
