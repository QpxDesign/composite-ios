//
//  ProfileView.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/9/23.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State var showingEmailAlert : Bool = false
    @State var showingPasswordAlert : Bool = false
    @State var showingNameAlert : Bool = false
    @State var couldNotLogUserIn : Bool = false
    @Binding var userLoggedIn : Bool
    @State var userFullName : String = ""
    @State var pageTitle : String = "Login"
    var body: some View {
        GeometryReader { geometry in
            if (userLoggedIn) {
                VStack {
                    Text("Sign Out").font(Font.custom("SourceSerifPro-Black",size:20)).frame(maxWidth: .infinity,alignment:.leading).padding(.leading,20).foregroundColor(Color.white).onTapGesture {
                        let defaults = UserDefaults.standard
                        defaults.set("", forKey: "token")
                        defaults.set("", forKey: "email")
                        defaults.set("", forKey: "full_name")
                        defaults.set("", forKey: "last_login_timestap")
                        userLoggedIn = false
                    }
                    Text("Profile").padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:35)).multilineTextAlignment(.center).foregroundColor(Color.white).padding(.top,10)
                    Image(systemName: "person.circle.fill").font(.system(size: 200)).padding(.horizontal,10).foregroundColor(Color.white)
                    Text(userFullName).padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:28)).multilineTextAlignment(.center).foregroundColor(Color.white)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .center ).background(
                    LinearGradient(gradient: Gradient(colors: [CustomColors.BackgroundGradientStart, CustomColors.BackgroundGradientEnd]), startPoint: .leading, endPoint: .trailing)).onAppear() {

                    }
            } else {
                VStack {
                    Text(pageTitle).padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:35)).multilineTextAlignment(.center).foregroundColor(Color.white).padding(.top,50)
                    Text(pageTitle == "Sign Up" ? "Already have an account? Login": "Need an account? Sign Up" ).padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Regular",size:16)).multilineTextAlignment(.center).foregroundColor(Color.white).onTapGesture {
                        if (pageTitle == "Sign Up") {pageTitle = "Login";print("blah")}
                        else if (pageTitle == "Login") {pageTitle = "Sign Up"}
                        else {
                            pageTitle = "oop"
                        }
   
                        print(pageTitle)
                        
                    }
                    if (pageTitle == "Sign Up") {
                        VStack {
                            Text("full name").font(Font.custom("SourceSerifPro-Regular",size:16)).frame(maxWidth:.infinity, maxHeight: .infinity,alignment: .leading).foregroundColor(Color.white)
                            TextField(
                                "name",
                                text: $name
                            ).frame(maxWidth:.infinity, maxHeight: .infinity).padding(.leading,10).foregroundColor(Color.white).border(Color.white)
                        }.frame(width:geometry.size.width * 0.8,height:80)
                    }
                    VStack {
                        Text("email").font(Font.custom("SourceSerifPro-Regular",size:16)).frame(maxWidth:.infinity, maxHeight: .infinity,alignment: .leading).foregroundColor(Color.white)
                        TextField(
                            "email",
                            text: $email
                        ).textCase(.lowercase).frame(maxWidth:.infinity, maxHeight: .infinity).padding(.leading,10).foregroundColor(Color.white).border(Color.white)
                    }.frame(width:geometry.size.width * 0.8,height:80).autocapitalization(.none)
                    VStack {
                        Text("password").font(Font.custom("SourceSerifPro-Regular",size:16)).frame(maxWidth:.infinity, maxHeight: .infinity,alignment: .leading).foregroundColor(Color.white)
                        SecureField(
                            "password",
                            text: $password
                        ).frame(maxWidth:.infinity, maxHeight: .infinity).padding(.leading,10).foregroundColor(Color.white).border(Color.white)
                    }.frame(width:geometry.size.width * 0.8, height:80)
                    ZStack {
                        Text("Sign In").padding(10).frame(alignment: .trailing).font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white).padding(.horizontal, 20).padding(.vertical, 0).background(Color.black).cornerRadius(25).onTapGesture {
                            if (!checkIfValidEmail(email: email)) {
                                showingEmailAlert = true
                                
                            } else if (password.count < 8) {
                                showingPasswordAlert = true
                            } else if (name.count < 5 && pageTitle == "Sign Up") {
                                showingNameAlert = true
                            }else {
                                if (pageTitle == "Sign Up") {
                                    apiCall().handleSignup(email: email, password: password, name: name) { a in
                                        if (a.status == "okay") {
                                            userLoggedIn = true
                                        } else {
                                            couldNotLogUserIn = true
                                        }
                                        print(a)
                                    }
                                } else {
                                    apiCall().handleLogin(email: email, password: password) { a in
                                        if (a.allowLogin == true) {
                                            userLoggedIn = true
                                        } else {
                                            couldNotLogUserIn = true
                                        }
                                        print(a)
                                    }
                                }
                            }
                        }.frame(width:geometry.size.width * 0.8, height:80, alignment: .trailing)
                    }.alert("Invalid Email", isPresented: $showingEmailAlert, actions: {}).alert("Invalid Password", isPresented: $showingPasswordAlert, actions: {}).alert("Invalid Name", isPresented: $showingNameAlert, actions: {}).alert("Couldn't Log Ya In.", isPresented: $couldNotLogUserIn, actions: {})
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .center ).background(
                    LinearGradient(gradient: Gradient(colors: [CustomColors.BackgroundGradientStart, CustomColors.BackgroundGradientEnd]), startPoint: .leading, endPoint: .trailing)).onAppear(){
                        Task {
                            let defaults = UserDefaults.standard
                            var last_login_timestamp = defaults.string(forKey: "last_login_timestap") ?? "0"
                            if (NSDate().timeIntervalSince1970-(Double(last_login_timestamp) ?? 0) < 43200) {//43200 = 1 Month (30 days) {
                                var token = defaults.string(forKey: "token") ?? ""
                                var email = defaults.string(forKey: "email") ?? ""
                                userFullName = defaults.string(forKey: "full_name") ?? ""
                                var a = "waiting"
                                apiCall().validateToken(email: email, token: token) { res in
                                if (res.auth ?? false) {
                                    userLoggedIn = true
                    
                                }
                            }
                        }
                        }
                    }
            }
        }
    }
}
