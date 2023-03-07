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
    var body: some View {
        NavigationView {
            TabView {
                SearchCollegesView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
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
