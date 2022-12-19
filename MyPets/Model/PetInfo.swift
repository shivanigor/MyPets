//
//  PetInfo.swift
//  MyPets
//
//  Created by Mac on 19/12/22.
//

import Foundation

class PetInfo: Codable {
    let image_url: String
    let title: String
    let content_url: String
    let date_added: String
}

class PetsData: Codable {
    let pets: [PetInfo]
}
