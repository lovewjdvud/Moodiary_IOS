//
//  PDFReportModel.swift
//  Moodiary
//
//  Created by Songjeongpyeong on 3/30/25.
//

import Foundation

struct PDFReportModel:Codable,Equatable {
    let month: String               // yyyy-MM
    let summary: String
    let mostFrequentEmotion: String
    let averageProductivity: Double
    let chartImageURL: String       // or Data\
    let url: URL
    let title: String
  
}

