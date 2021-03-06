//
//  CourseDetail.swift
//  DMZing
//
//  Created by 김예은 on 16/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation

typealias CourseDetailData = CourseDetail

struct CourseDetail: Codable {
    let backgroundGifUrl: String
    let backgroundImageUrl: String 
    let estimatedTime: Double
    let id: Int
    let imageUrl: String
    let level: String
    let lineImageUrl: String
    let mainDescription: String
    let places: [Place]
    let price: Int
    let reviewCount: Int
    let subDescription: String
    let title: String
    let pickCount: Int
}

typealias PlaceData = [Place]

struct Place: Codable {
    let address: String
    let description: String
    let hint: String?
    let id: Int
    let infoCenter: String?
    let latitude: Double
    let letterImageUrl: String?
    let longitude: Double
    let mainImageUrl: String
    let parking: String?
    let peripheries: [Peripheries]
    let restDate: String?
    let reward: Int
    let sequence: Int
    let title: String
    var timeToNextPlace : Int?
}

struct Peripheries: Codable {
    let contenttypeid: Int
    let firstimage: String?
    let title: String
}

