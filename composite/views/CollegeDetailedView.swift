//
//  CollegeDetailedView.swift
//  composite
//
//  Created by Quinn Patwardhan on 3/6/23.
//

import Foundation
import SwiftUI
import Kingfisher

struct CollegeDetailedView: View {
    let collegeName : String
    @State var imageURL : String = ""
    @State var results : [CollegeResult]?
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Text(collegeName).padding(.horizontal, 10).font(Font.custom("SourceSerifPro-Black",size:30)).multilineTextAlignment(.center).onAppear() {
                    apiCall().getCollegeData(query:collegeName) { (data) in
                        if (!(data.results?.isEmpty ?? true)) {
                            var q = (data.results?[0].school?.city ?? "") + " " + (FullStateNameFromAbbreviation(abbrev: data.results?[0].school?.state ?? ""))
                            apiCall().getImageFrom(query: q ?? "tree")  { (data) in
                                imageURL = data.results?[0].urls?.regular ?? ""
                                
                            }
                        }
                        
                    }
                 
                 
                }
                if (URL(string: imageURL) != nil) {
                    KFImage(URL(string: imageURL )).resizable().aspectRatio(contentMode: .fill).frame(maxWidth: geometry.size.width*0.95,maxHeight: geometry.size.height*0.33,alignment: .center).cornerRadius(25)                } else {
                    Text("Loading...")
                }
                
                Spacer()
            }.frame(maxWidth:.infinity,alignment:.center)
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
