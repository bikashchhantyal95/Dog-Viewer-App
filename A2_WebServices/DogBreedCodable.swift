//
//  DogBreedCodable.swift
//  A2_WebServices
//
//  Created by Deepshika Ghale on 2023-06-04.
//

import Foundation

//codable class for decoding the api data
struct DogBreedCodable: Codable{
    var message: [String: [String]]
}

