//
//  YoutubeResults.swift
//  DEV2(Netflix clone)
//
//  Created by usear on 6/10/24.
//

import Foundation
struct YoutubeResponse: Codable{
    let items:[VideoElement]
}
struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
   
    let kind: String
    let videoId: String?
    let channelId: String?
   
}

