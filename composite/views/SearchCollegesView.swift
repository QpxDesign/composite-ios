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
    @State private var actMin : Double = 0
    @State var satCompMin : Double = 0
    @State var adminRate : Double = 0
    @State var gradRate : Double = 0
    
    @State var showFiltersScreen : Bool = false
    let defaults = UserDefaults.standard
    @State var westIsOn : Bool = true
    @State var southIsOn : Bool = true
    @State var northeastIsOn : Bool = true
    @State var midwestIsOn : Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                if (!showFiltersScreen) {
                    ZStack {
                        VStack {
                            HStack {
                                TextField(
                                    "Yale University",
                                    text: $searchQueryText
                                ).padding(.horizontal, 7.5).padding(.vertical, 5).padding(.leading,20).font(Font.custom("SourceSerifPro-Regular", size: 24)).background(CustomColors.Slate100).frame(width:geometry.size.width * 0.70,height: 75).foregroundColor(Color.black)
                                Image(systemName: "line.3.horizontal.decrease.circle.fill").font(.system(size: 30)).frame(height:.infinity, alignment: .center).foregroundColor(Color.white).onTapGesture {
                                    showFiltersScreen = true
                                }
                            }.frame(width:.infinity,height: 75,alignment: .center)
                            List(getMatchingSchoolNames(query: searchQueryText, minAct: Int(floor(actMin)), minSAT: Int(floor(satCompMin)),adminRate:adminRate, gradRate: gradRate,westEnabled: westIsOn,southEnabled: southIsOn,midwestEnabled: midwestIsOn, northeastEnabled: northeastIsOn)) { institution in
             
                                                HStack {
                                                    Text(institution.School_Name).font(Font.custom("SourceSerifPro-Regular",size:22))
                                                    Spacer()
                                                    HStack(spacing: 0) {
                                                        Image(systemName: "arrow.right")
                                                            .font(.system(size: 24, weight: .light))
                                                        
                                                        NavigationLink(destination: CollegeDetailedView(collegeName:institution.School_Name, domainName: institution.Domain_Name)) {
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
                    }
                    
                } else {
                    
                        VStack {
                            HStack{
                                Image(systemName: "xmark").font(.system(size: 30)).frame(height:.infinity, alignment: .center).foregroundColor(Color.white).position(x:40,y:20).onTapGesture {
                                    showFiltersScreen = false
                                }
                                Spacer()
                            }.frame(width:.infinity,height: 25,alignment: .center)
                            Text("Filters").padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:35)).multilineTextAlignment(.center).foregroundColor(Color.white)
                            ScrollView() {
                            VStack {
                                
                                Text("Average ACT (\(Int(floor(actMin)))) ").font(Font.custom("SourceSerifPro-Regular",size:26)).foregroundColor(Color.white).padding(.top,20).padding(.bottom,-5)
                                Slider(value: $actMin, in: 0...36)
                                          
                            }.frame(width:geometry.size.width * 0.70, alignment:.center)
                            VStack {
                                
                                Text("Average SAT (\(Int(floor(satCompMin)))) ").font(Font.custom("SourceSerifPro-Regular",size:26)).foregroundColor(Color.white).padding(.top,20).padding(.bottom,-5)
                                Slider(value: $satCompMin, in: 800...1600)
                                
                            }.frame(width:geometry.size.width * 0.70, alignment:.center)
                            VStack {
                                
                                Text("Acceptance Rate (\(Int(floor(adminRate)))%) ").font(Font.custom("SourceSerifPro-Regular",size:26)).foregroundColor(Color.white).padding(.top,20).padding(.bottom,-5)
                                Slider(value: $adminRate, in: 0...100)
                                                        
                            }.frame(width:geometry.size.width * 0.70, alignment:.center)
                            VStack {
                                Text("Graduation Rate (\(Int(floor(gradRate)))%) ").font(Font.custom("SourceSerifPro-Regular",size:26)).foregroundColor(Color.white).padding(.top,20).padding(.bottom,-5)
                                Slider(value: $gradRate, in: 0...100)
                                                        
                            }.frame(width:geometry.size.width * 0.70, alignment:.center)
                            VStack {
                                HStack {
                                    Text("Locations").font(Font.custom("SourceSerifPro-Regular",size:26)).foregroundColor(Color.white).padding(.top,20)
                                }.frame(width:.infinity,height: 25,alignment: .center)
                                Toggle("West", isOn: $westIsOn)
                                    .padding().foregroundColor(Color.white).font(Font.custom("SourceSerifPro-Regular",size:22)).padding(.bottom,0)
                                Toggle("South", isOn: $southIsOn)
                                    .padding().foregroundColor(Color.white).font(Font.custom("SourceSerifPro-Regular",size:22)).padding(.bottom,0)
                                Toggle("Northeast", isOn: $northeastIsOn)
                                    .padding().foregroundColor(Color.white).font(Font.custom("SourceSerifPro-Regular",size:22)).padding(.bottom,0)
                                Toggle("Midwest", isOn: $midwestIsOn)
                                    .padding().foregroundColor(Color.white).font(Font.custom("SourceSerifPro-Regular",size:22)).padding(.bottom,0)
                            }.frame(width:geometry.size.width * 0.70, alignment:.center)
                            
                            Spacer()
                        }
                    }.frame(maxWidth: .infinity, alignment: .center ).background(
                        LinearGradient(gradient: Gradient(colors: [CustomColors.BackgroundGradientStart, CustomColors.BackgroundGradientEnd]), startPoint: .leading, endPoint: .trailing))
                    
                    
                }
            }
        }
        
    }
    
}
