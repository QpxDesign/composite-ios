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

struct CollegeDetailedView: View {
    let collegeName : String
    @State var imageURL : String = ""
    @State var results : [CollegeResult]?
    @State var datapoints : [SCDataPoint] = []
    @State var weatherNormals : [MonthWeatherNormal] = []
    @State var climateData : [MonthWeatherNormal] = [MonthWeatherNormal]()
    @State var avgTmpData : [MonthlyTemp] = []
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
            VStack {
                Text(collegeName).padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:30)).multilineTextAlignment(.center).foregroundColor(Color.white)
                 
                    .onAppear() {
                       
                        apiCall().getCollegeData(query:collegeName) { (data) in
                            if (!(data.results?.isEmpty ?? true)) {
                                results = data.results

                                var totalStudents : Double = Double((data.results?[0].latest?.student?.enrollment?.grad_12_month ?? 0) + (data.results?[0].latest?.student?.enrollment?.undergrad_12_month ?? 0))
                                var percentWhite : Double = data.results?[0].latest?.student?.demographics?.race_ethnicity?.white ?? 0
                                var percentBlack : Double = data.results?[0].latest?.student?.demographics?.race_ethnicity?.black ?? 0
                                var percentAsian : Double = data.results?[0].latest?.student?.demographics?.race_ethnicity?.asian ?? 0
                                var percentAIAN : Double = data.results?[0].latest?.student?.demographics?.race_ethnicity?.aian ?? 0
                                var percentUnknown : Double = data.results?[0].latest?.student?.demographics?.race_ethnicity?.unknown ?? 0
                                print(percentWhite)
                                datapoints.append(SCDataPoint("White", value: percentWhite*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("Black", value: percentBlack*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("Asian", value: percentAsian*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("AIAN", value: percentAIAN*totalStudents, color: Color.red))
                                datapoints.append(SCDataPoint("Unknown", value: percentUnknown*totalStudents, color: Color.red))

                                var q = "\(data.results?[0].school?.name ?? "")"
                                q = q.lowercased()
                                apiCall().getImageFrom(query: q ?? "tree")  { (data) in
                                    imageURL = data.results?[0].urls?.regular ?? ""
                                }
                                
                            }
                            
                        }
                    }
                    HStack {
                        Text("\(results?[0].school?.city ?? ""), \(results?[0].school?.state ?? "")").font(Font.custom("SourceSerifPro-Regular",size:20)).padding(0).frame(alignment:.center).foregroundColor(Color.white)
                    }.frame(alignment:.center)
                    if (URL(string: imageURL) != nil) {
                        KFImage(URL(string: imageURL )).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: geometry.size.width*0.95,maxHeight: geometry.size.height*0.33,alignment: .center).cornerRadius(25)                } else {
                            Text("Loading...").foregroundColor(Color.white)
                        }
                    HStack {
                        VStack {
                            Text(String(floor((results?[0].latest?.admissions?.admission_rate?.overall ?? 0) * 100)) + "%").font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("Acceptance Rating").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(String((round(results?[0].latest?.completion?.consumer_rate ?? 0) * 100)) + "%").font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("Graduation Rate").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(String(results?[0].latest?.admissions?.act_scores?.midpoint?.cumulative ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("ACT").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        
                        
                    }.frame(maxWidth: geometry.size.width * 0.90, maxHeight:100, alignment: .center)
                    HStack {
                        VStack {
                            Text(String(results?[0].latest?.admissions?.sat_scores?.midpoint?.math ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("SAT Math").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(String(results?[0].latest?.admissions?.sat_scores?.midpoint?.writing ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("SAT Writing").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                        VStack {
                            Text(AddCommasToNumber(var: results?[0].latest?.cost?.avg_net_price?.overall ?? 0)).font(Font.custom("SourceSerifPro-Black",size:30).bold()).foregroundColor(Color.white)
                            Text("Average Cost").font(Font.custom("SourceSerifPro-Regular",size:20)).foregroundColor(Color.white)
                        }.padding(12).background(Color.white.opacity(0.3)).border(Color.white)
                    }.frame(maxWidth: geometry.size.width * 0.90, maxHeight:100, alignment: .center)
                Text("Demographics").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular",size:28)).bold().padding(.leading,20).foregroundColor(Color.white).padding(.bottom,-10)
                SCDonutChartView("Demographics", data: datapoints).font(Font.custom("SourceSerifPro-Regular",size:25)).padding(0)
                VStack {
                    Text("Climate").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular",size:28)).bold().padding(.leading,20).foregroundColor(Color.white).padding(.top,100).onAppear() {
                        apiCall().getCollegeData(query:collegeName) { (data) in
                            if (!(data.results?.isEmpty ?? true)) {
                                var station_name : String = getClosestWeatherStation(location: CLLocation(latitude: data.results?[0].location?.lat ?? 0, longitude: data.results?[0].location?.lon ?? 0))
                                apiCall().getWeatherNormalsFromStationName(station_Name: station_name) {
                                    (wd) in
                                    climateData = wd
                                    print(wd)
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
                                    print(avgTmpData)
                                }
                            }
                        }
                    }
                    Text("Average Daily Temperature").frame(maxWidth:.infinity, alignment: .leading).font(Font.custom("SourceSerifPro-Regular", size:22)).foregroundColor(Color.orange).padding(.leading,20)
                                                                                                                    
                    HStack {
                        Chart {
                            ForEach (avgTmpData) { (data) in
                                LineMark(
                                    x: .value("Month", data.date),
                                    y: .value("Average Temperature", data.temp)
                                )
                            }
                        }.frame(width:geometry.size.width * 0.95,height:300).foregroundColor(Color.red)
                    }.frame(width:geometry.size.width,height:300,alignment:.center).foregroundColor(Color.red).background(Color.white)
                }.frame(width:geometry.size.width,height:300,alignment:.center).padding(.bottom,100)

                
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


