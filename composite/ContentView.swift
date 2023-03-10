//
//  ContentView.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import SwiftUI

struct ContentView: View {
    @State var results : APICALLResult? = nil
    init() {
        UITabBar.appearance().backgroundColor = UIColor(CustomColors.Gray900)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    @State var userLoggedIn : Bool = false
    var body: some View {
        NavigationView {
            TabView {
                SearchCollegesView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                LikedCollegesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
                ProfileView(userLoggedIn: $userLoggedIn)
                    .tabItem {
                        Label("Favorites", systemImage: "person.circle.fill")
                    }
                
            }
        
        
        }.navigationBarTitleDisplayMode(.inline).padding(.top, -20).navigationViewStyle(StackNavigationViewStyle())

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
