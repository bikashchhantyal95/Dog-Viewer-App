//
//  DogBreedAPI_Helper.swift
//  A2_WebServices
//
//  Created by Deepshika Ghale on 2023-06-04.
//

import Foundation

enum DogBreed_Errors: Error{
    case CannotConvertURL
}

class DogBreedAPI_Helper{
    private static var baseURLString = "https://dog.ceo/api/breeds/list/all";
    
    //fetch the dog breed from the given url
    public static func fetch(urlString: String) async throws -> Data{
        guard
            let url = URL(string: urlString)
        else{
            throw DogBreed_Errors.CannotConvertURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        
        return data
    }
    
    //decode the api data
    public static func fetchDogBreed() async throws -> DogBreedCodable{
        let data = try await fetch(urlString: baseURLString)
        
        let decoder = JSONDecoder()
        
        let dogBreed = try decoder.decode(DogBreedCodable.self, from: data)
        
        return dogBreed
        
    }
}
