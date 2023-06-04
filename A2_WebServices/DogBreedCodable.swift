//
//  DogBreedCodable.swift
//  A2_WebServices
//
//  Created by Deepshika Ghale on 2023-06-04.
//

import Foundation

struct DogBreedCodable: Codable{
    var results: [DogBreed]
}

struct DogBreed: Codable{
    var breedName: String
}

