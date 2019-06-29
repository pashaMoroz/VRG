//
//  NytimesModels.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/27/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import Foundation

struct Nytimes: Decodable {
  let results: [Article]?

}

struct Article: Decodable {
    let title: String?
    let media: [Media]?
    let url: String?
}

struct Media: Codable {
    let mediaMetadata: [MediaMetadata]?
    
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadata: Codable {
    let url: String?
}
