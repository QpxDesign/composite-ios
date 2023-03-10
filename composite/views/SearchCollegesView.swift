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
                NavigationView {
                    ZStack {
                        VStack {
                            TextField(
                                "Yale University",
                                text: $searchQueryText
                            ).padding(.horizontal, 7.5).padding(.vertical, 5).padding(.leading,20).font(Font.custom("SourceSerifPro-Regular", size: 24)).background(CustomColors.Slate100).frame(width:geometry.size.width * 0.90,height: 75).foregroundColor(Color.black)
                            
                            List(getMatchingSchoolNames(query: searchQueryText)) { institution in
                                HStack {
                                    Text(institution.School_Name).font(Font.custom("SourceSerifPro-Regular",size:22))
                                    Spacer()
                                    HStack(spacing: 0) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 24, weight: .light))
                                        
                                        NavigationLink(destination: CollegeDetailedView(collegeName:institution.School_Name)) {
                                            EmptyView()
                                        }
                                        .frame(width: 0)
                                        .opacity(0)
                                    }
                                }.listRowBackground(Color.black).foregroundColor(Color.white)
                                
                            }.frame(maxWidth: .infinity, alignment: .center ).background(CustomColors.Gray900)
                            
                                .scrollContentBackground(.hidden)
                        }.frame(maxWidth: .infinity, alignment: .center ).background(
                            LinearGradient(gradient: Gradient(colors: [CustomColors.BackgroundGradientStart, CustomColors.BackgroundGradientEnd]), startPoint: .leading, endPoint: .trailing))
                    }.background(Color.red)
                 
                }

            }

    }
}
