//
//  CollegeDetailedView.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
import SwiftUI
import Kingfisher
import SwiftUICharts
import WeatherKit
import MapKit
import CoreLocation
import Charts

struct MonthlyTemp : Identifiable {
    var id = UUID()
    var date: String
    var temp: Double

    init(month: Int, temp: String?) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = DateNumberToMonthName(dn: month)
        self.temp = Double(temp?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0") ?? 50
      
    }
}

struct MonthlyPrecp : Identifiable {
    var id = UUID()
    var date: String
    var precp: Double

    init(month: Int, precp: String?) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = DateNumberToMonthName(dn: month)
        self.precp = Double(precp?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0") ?? 50
      
    }
}

struct MonthlySnow : Identifiable {
    var id = UUID()
    var date: String
    var snowAmt: Double

    init(month: Int, snowAmt: String?) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = DateNumberToMonthName(dn: month)
        self.snowAmt = Double(snowAmt?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0") ?? 50
      
    }
}


struct CollegeDetailedView: View {
    let collegeName : String
    let domainName: String
    @State var imageURL : String = ""
    @State var imageMetadata : String = "unsplash_user()"
    @State var results : CollegeResult?
    @State var datapoints : [SCDataPoint] = []
    @State var weatherNormals : [MonthWeatherNormal] = []
    @State var climateData : [MonthWeatherNormal] = [MonthWeatherNormal]()
    @State var avgTmpData : [MonthlyTemp] = []
    @State var avgPrecpData : [MonthlyPrecp] = []
    @State var avgSnowData : [MonthlySnow] = []
    @State var CollegeFavorited : Bool = false
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
            VStack {
                Text(collegeName).padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:30)).multilineTextAlignment(.center).foregroundColor(Color.white)
        
                    .onAppear() {
                        let defaults = UserDefaults.standard
                        var email = defaults.string(forKey: "email") ?? ""
             
                        apiCall().getCollegeData(query:collegeName, domain_name: domainName) { (data) in
          
                                results = data
                                apiCall().GetFavoritesFromEmail(email: email ?? "") { r in
                                    if (r.ids?.filter{$0 == results?.fed_sch_cd ?? "aiodwhods" }.count != 0) {
                                        //print(r == results?.fed_sch_cd)
                                        CollegeFavorited = true
                                    }
                                }
                                var totalStudents : Double = Double((data.latest?.student?.enrollment?.grad_12_month ?? 0) + (data.latest?.student?.enrollment?.undergrad_12_month ?? 0))
                                var percentWhite : Double = data.latest?.student?.demographics?.race_ethnicity?.white ?? 0
                                var percentBlack : Double = data.latest?.student?.demographics?.race_ethnicity?.black ?? 0
                                var percentAsian : Double = data.latest?.student?.demographics?.race_ethnicity?.asian ?? 0
                                var percentAIAN : Double = data.latest?.student?.demographics?.race_ethnicity?.aian ?? 0
                                var percentUnknown : Double = data.latest?.student?.demographics?.race_ethnicity?.unknown ?? 0
                                datapoints.append(SCDataPoint("White", value: percentWhite*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("Black", value: percentBlack*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("Asian", value: percentAsian*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("AIAN", value: percentAIAN*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("Unknown", value: percentUnknown*totalStudents, color: Color.red))

                                var q = "\(data.school?.name ?? "")"
                                q = q.lowercased()
                                apiCall().getImageFrom(query: q ?? "tree")  { (data) in
                                    imageURL =  data.results?[0].urls?.regular ?? ""
                                    imageMetadata = data.results?[0].user?.username ?? ""
                                }
                                
                            }
                            
                        
                    }
                    HStack {
                        Text("\(results?.school?.city ?? ""), \(results?.school?.state ?? "")").font(Font.custom("SourceSerifPro-Regular",size:20)).padding(0).frame(alignment:.center).foregroundColor(Color.white)
                    }.frame(alignment:.center)
                    if (URL(string: imageURL) != nil) {
                        ZStack {
                            KFImage(URL(string: imageURL )).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: geometry.size.width*0.95,maxHeight: geometry.size.height*0.33,alignment: .center).cornerRadius(25)
                               
                                HStack {
                                    Text("Photo by \(imageMetadata) / Unplash").padding(3).background(Color.black).foregroundColor(Color.white).font(Font.custom("SourceSerifPro-Regular",size:16)).position(x:geometry.size.width/2, y:10)
                                }
                        }
       
                    } else {
                        Text("Loading...").foregroundColor(Color.white)
                    }
                    HStack {
                        ZStack {
                            Image(systemName: CollegeFavorited ? "star.fill" : "star").font(.system(size: 30)).padding(.horizontal,10).foregroundColor(Color.white).onTapGesture {
                                Task {
                                    let defaults = UserDefaults.standard
                                    var token = defaults.string(forKey: "token") ?? ""
                                    if (CollegeFavorited) {
                                        CollegeFavorited = false
                                        apiCall().RemoveCollegeToFavorites(token: token, collegeID: results?.fed_sch_cd ?? "") { r in
                                            
                                        }
                                    } else {
                                        
                                        apiCall().AddCollegeToFavorites(token: token, collegeID: results?.fed_sch_cd ?? "") { r in
                                            if (r.ids?.filter{$0 == results?.fed_sch_cd ?? "" }.count != 0) {
                                                CollegeFavorited = true
                                            }
                                        }
                                    }
                                }
                            }
                        }.onTapGesture {
                            Task {
                                let defaults = UserDefaults.standard
                                var token = defaults.string(forKey: "token") ?? ""
                                if (CollegeFavorited) {
                                    CollegeFavorited = false
                                    apiCall().RemoveCollegeToFavorites(token: token, collegeID: results?.fed_sch_cd ?? "") { r in
                                        
                                    }
                                } else {
                                    
                                    apiCall().AddCollegeToFavorites(token: token, collegeID: results?.fed_sch_cd ?? "") { r in
                                        if (r.ids?.filter{$0 == results?.fed_sch_cd ?? "" }.count != 0) {
                                            CollegeFavorited = true
                                        }
                                    }
                                }
                            }
                        }
                        ZStack {
                          
                            Image(systemName: "link.circle").font(.system(size: 30)).padding(.horizontal,10).foregroundColor(Color.white)
                            Link("      ",
                                 destination: URL(string: "https://\(domainName)")!).font(.system(size: 30))
                        }
                        Image(systemName: "arrowtriangle.up.circle").font(.system(size: 30)).padding(.horizontal,10).foregroundColor(Color.white)
                        Image(systemName: "arrowtriangle.down.circle").font(.system(size: 30)).padding(.horizontal,10).foregroundColor(Color.white)
                        
                    }.frame(maxWidth:.infinity).padding(.vertical,10)
                
                    HStack {
                        VStack {
                            Text(String(floor((results?.latest?.admissions?.admission_rate?.overall ?? 0) * 100)) + "%").font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("Acceptance Rating").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(String(((results?.latest?.completion?.consumer_rate ?? 0) * 100)) + "%").font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("Graduation Rate").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(String(results?.latest?.admissions?.act_scores?.midpoint?.cumulative ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("ACT").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        
                        
                    }.frame(maxWidth: geometry.size.width * 0.90, maxHeight:100, alignment: .center)
                    HStack {
                        VStack {
                            Text(String(results?.latest?.admissions?.sat_scores?.midpoint?.math ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("SAT Math").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(String(results?.latest?.admissions?.sat_scores?.midpoint?.writing ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("SAT Writing").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(AddCommasToNumber(var: results?.latest?.cost?.avg_net_price?.overall ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("Average Cost").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                    }.frame(maxWidth: geometry.size.width * 0.90, maxHeight:100, alignment: .center)
                Text("Demographics").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular",size:28)).bold().padding(.leading,20).foregroundColor(Color.white).padding(.bottom,-10)
                SCDonutChartView("Demographics", data: datapoints).font(Font.custom("SourceSerifPro-Regular",size:25)).padding(0)
                VStack {
                    Text("Climate").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular",size:28)).bold().padding(.leading,20).foregroundColor(Color.white).padding(.top,100).onAppear() {
                        apiCall().getCollegeData(query:collegeName, domain_name: domainName) { (data) in
                            print("step 1")
            
                                var station_name : String = getClosestWeatherStation(location: CLLocation(latitude: data.location?.lat ?? 0, longitude: data.location?.lon ?? 0))
                                print(station_name)
                                print(getClosestWeatherStation(location: CLLocation(latitude: data.location?.lat ?? 0, longitude: data.location?.lon ?? 0)))
                                print("step 2")
                                apiCall().getWeatherNormalsFromStationName(station_Name: station_name) {
                                    (wd) in
                                    print("ksisis")
                                    climateData = wd
                                    if (wd.count == 12) {
                                        avgTmpData = [
                                            MonthlyTemp(month: 1, temp: wd[0].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 2, temp: wd[1].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 3, temp: wd[2].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 4, temp: wd[3].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 5, temp: wd[4].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 6, temp: wd[5].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 7, temp: wd[6].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 8, temp: wd[7].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 9, temp: wd[8].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 10, temp: wd[9].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 11, temp: wd[10].MLY_TAVG_NORMAL),
                                            MonthlyTemp(month: 12, temp: wd[11].MLY_TAVG_NORMAL)
                                        ]
                                        avgPrecpData = [
                                            MonthlyPrecp(month: 1, precp: wd[0].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 2, precp: wd[1].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 3, precp: wd[2].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 4, precp: wd[3].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 5, precp: wd[4].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 6, precp: wd[5].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 7, precp: wd[6].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 8, precp: wd[7].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 9, precp: wd[8].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 10, precp: wd[9].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 11, precp: wd[10].MLY_PRCP_NORMAL),
                                            MonthlyPrecp(month: 12, precp: wd[11].MLY_PRCP_NORMAL)
                                        ]
                                        avgSnowData =  [
                                            MonthlySnow(month: 1, snowAmt: wd[0].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 2, snowAmt: wd[1].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 3, snowAmt: wd[2].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 4, snowAmt: wd[3].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 5, snowAmt: wd[4].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 6, snowAmt: wd[5].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 7, snowAmt: wd[6].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 8, snowAmt: wd[7].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 9, snowAmt: wd[8].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 10, snowAmt: wd[9].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 11, snowAmt: wd[10].MLY_SNOW_NORMAL),
                                            MonthlySnow(month: 12, snowAmt: wd[11].MLY_SNOW_NORMAL)
                                        ]
                                    }
                                    
                                }
                            
                        }
                    }
                   
                    ScrollView(.horizontal) {
                        HStack {
                            VStack {
                                Text("Average Temperature (°F)").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular", size:22)).foregroundColor(Color.orange).padding(.leading,20).padding(.bottom,20)
                            HStack {
                                    Chart {
                                        ForEach (avgTmpData) { (data) in
                                            LineMark(
                                                x: .value("Month", data.date),
                                                y: .value("Average Temperature", data.temp)
                                            )
                                        }
                                    }.frame(width:geometry.size.width * 0.95,height:300).foregroundColor(Color.red).background(Color.black).padding(.vertical,25).padding(.horizontal,5).chartXAxis {
                                        AxisMarks(values: .automatic) { value in

                                          AxisValueLabel() { // construct Text here
                                              
                                              Text(DateNumberToMonthName(dn: value.index) )
                                                .font(.system(size: 15)) // style it
                                                .foregroundColor(.blue)
                                            }
                                          
                                        }
                                      }.chartYAxis {
                                          AxisMarks(values: .automatic) { value in

                                              AxisValueLabel() { // construct Text here
                                                  if let intValue = value.as(Int.self) {
                                                      Text("\(intValue) F")
                                                          .font(.system(size: 15)) // style it
                                                          .foregroundColor(.blue)
                                                  }
                                              }
                                            
                                          }
                                        }
                                }.frame(width:geometry.size.width,height:300,alignment:.center).foregroundColor(Color.orange)
                            }
                            VStack {
                                Text("Average Precipitation (in)").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular", size:22)).foregroundColor(Color.blue).padding(.leading,20).padding(.bottom,20)
                                HStack {
                                    Chart {
                                        ForEach (avgPrecpData) { (data) in
                                            LineMark(
                                                x: .value("Month", data.date),
                                                y: .value("Average Precipitation", data.precp)
                                            )
                                        }
                                    }.frame(width:geometry.size.width * 0.95,height:300).background(Color.black).foregroundColor(Color.blue).padding(.vertical,25).padding(.horizontal,5).chartXAxis {
                                        AxisMarks(values: .automatic) { value in

                                          AxisValueLabel() { // construct Text here
                                              
                                              Text(DateNumberToMonthName(dn: value.index) )
                                                .font(.system(size: 15)) // style it
                                                .foregroundColor(.blue)
                                            }
                                          
                                        }
                                      }.chartYAxis {
                                          AxisMarks(values: .automatic) { value in

                                              AxisValueLabel() { // construct Text here
                                                  if let intValue = value.as(Int.self) {
                                                      Text("\(intValue) in")
                                                          .font(.system(size: 15)) // style it
                                                          .foregroundColor(.blue)
                                                  }
                                              }
                                            
                                          }
                                        }
                                }.frame(width:geometry.size.width,height:300,alignment:.center).foregroundColor(Color.blue)
                            }
                            VStack {
                                Text("Average Snow (in)").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular", size:22)).foregroundColor(Color.teal).padding(.leading,20).padding(.bottom,20)
                                HStack {
                                    Chart {
                                        ForEach (avgSnowData) { (data) in
                                            LineMark(
                                                x: .value("Month", data.date),
                                                y: .value("Average Snowfall", data.snowAmt)
                                            )
                                        }
                                    }.frame(width:geometry.size.width * 0.90,height:300).foregroundColor(Color.blue).background(Color.black).padding(.vertical,25).padding(.horizontal,5).chartXAxis {
                                        AxisMarks(values: .automatic) { value in

                                          AxisValueLabel() { // construct Text here
                                              
                                              Text(DateNumberToMonthName(dn: value.index) )
                                                .font(.system(size: 15)) // style it
                                                .foregroundColor(.blue)
                                            }
                                          
                                        }
                                      }.chartYAxis {
                                          AxisMarks(values: .automatic) { value in

                                              AxisValueLabel() { // construct Text here
                                                  if let intValue = value.as(Int.self) {
                                                      Text("\(intValue) in")
                                                          .font(.system(size: 15)) // style it
                                                          .foregroundColor(.blue)
                                                  }
                                              }
                                            
                                          }
                                        }
                                }.frame(width:geometry.size.width,height:300,alignment:.center).foregroundColor(Color.blue)
                            }
                        }
                    }
                }.frame(width:geometry.size.width,height:300,alignment:.center).padding(.bottom,200)

                
            }
               
            }.background(
                LinearGradient(gradient: Gradient(colors: [CustomColors.BackgroundGradientStart, CustomColors.BackgroundGradientEnd]), startPoint: .leading, endPoint: .trailing))
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


