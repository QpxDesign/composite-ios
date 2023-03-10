//
//  LikedCollegesView.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/8/23.
//

import Foundation
import SwiftUI

struct LikedCollegesView: View {
    @State var ids : [String] = []
    @State var Colleges : [CollegeResult?]? = []
    @State private var isActive = false
    @State var Loaded : Bool = false
    var body: some View {
        GeometryReader { geometry in
            ScrollView() {
                VStack {
                    Text("Favorites").padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:35)).multilineTextAlignment(.center).foregroundColor(Color.white).padding(.top,10).frame(maxWidth: .infinity,alignment: .leading).padding(.leading,15).onAppear() {
                        let defaults = UserDefaults.standard
                        var email = defaults.string(forKey: "email")
                        apiCall().GetFavoritesFromEmail(email: email ?? "") { r in
                            ids = r.ids ?? []
                            print("id")
                            ids.forEach { s in
                                apiCall().GetCollegeFromID(school_id:s) { res in
                                    print("s")
                                    print(res.results)
                                    if ((Colleges?.count ?? 0) != ids.count)  {
                                        self.Colleges?.append(res.results?[0])
                                    }
                                }
                            }
                            Loaded = true
                        }
                    }
                    if (Colleges?.isEmpty ?? true && !Loaded) {
                        Text("Loading...").font(Font.custom("SourceSerifPro-Regular",size:24)).bold().foregroundColor(Color.white)
                    }
                    
                    ForEach(0..<(Colleges?.count ?? 0), id: \.self) { index in
                        VStack {
                            Text(String(Colleges?[0]?.school?.name ?? "")).font(Font.custom("SourceSerifPro-Regular",size:24)).bold().frame(maxWidth: .infinity, alignment: .leading).padding(.leading,15).foregroundColor(Color.white).padding(.top,15)
                            Text("📍 \(Colleges?[0]?.school?.city ?? ""), \(Colleges?[0]?.school?.state ?? "" )").font(Font.custom("SourceSerifPro-Regular",size:20)).frame(maxWidth: .infinity, alignment: .leading).padding(.leading,15).foregroundColor(Color.white)
                            Spacer()
                            HStack {
                                Text("🗑 Remove").font(Font.custom("SourceSerifPro-Regular",size:20)).frame(maxWidth: .infinity, alignment: .leading).padding(.leading,15).foregroundColor(Color.white).padding(.bottom,10).onTapGesture {
                                    let defaults = UserDefaults.standard
                                    var token = defaults.string(forKey: "token") ?? ""
                                    apiCall().RemoveCollegeToFavorites(token: token, collegeID: Colleges?[0]?.fed_sch_cd ?? "") { r in
                                        ids = r.ids ?? []
                                        var tmp : [CollegeResult?]? = []
                                        print("removing college")
                                        ids.forEach { s in
                                            apiCall().GetCollegeFromID(school_id:s) { res in
                                                print("s")
                                                print(res.results)
                                                if ((Colleges?.count ?? 0) != ids.count)  {
                                                    tmp?.append(res.results?[0] )
                                                }
                                            }
                                        }
                                        Colleges = tmp
                                        print(Colleges)
                                    }
                                }
                                Spacer()
                                HStack(spacing: 0) {
                                   
                                    
                                    NavigationLink(destination: CollegeDetailedView(collegeName:Colleges?[0]?.school?.name ?? "")) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 24, weight: .light))
                                    }
                      
                                }.padding(.trailing,15).foregroundColor(Color.white).padding(.bottom,10)
                            }.frame(maxWidth:.infinity, alignment: .center)
                            
                        }.frame(width:geometry.size.width * 0.80, height:150, alignment: .leading).background(Color.white.opacity(0.4)).cornerRadius(25)
                    }
                    
                    
                    Spacer()
                    
                }
                }.frame(maxWidth: .infinity, alignment: .center ).background(
                    LinearGradient(gradient: Gradient(colors: [CustomColors.BackgroundGradientStart, CustomColors.BackgroundGradientEnd]), startPoint: .leading, endPoint: .trailing))
            
        }
    }
}
