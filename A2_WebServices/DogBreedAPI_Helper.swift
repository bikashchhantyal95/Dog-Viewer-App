//
//  DogBreedAPI_Helper.swift
//  A2_WebServices
//
//  Created by Deepshika Ghale on 2023-06-04.
//

import Foundation

//to customize the error message
enum DogBreed_Errors: Error{
    case CannotConvertURL
}

class DogBreedAPI_Helper{
    //stores url
    private static var baseURLString = "https://dog.ceo/api/breeds/list/all";
    
    //fetches data from the given url
    public static func fetch(urlString: String) async throws -> Data{
        guard
            let url = URL(string: urlString)
        else{
            throw DogBreed_Errors.CannotConvertURL
        }
        
        //fetches data and response from the url
        let (data, _) = try await URLSession.shared.data(from: url)
        
        //return data from the above fetched variable
        return data
    }
    
    //decode the api data
    public static func fetchDogBreed() async throws -> DogBreedCodable{
        let data = try await fetch(urlString: baseURLString)
        
        let decoder = JSONDecoder()
        
        //decodes json data
        let dogBreed = try decoder.decode(DogBreedCodable.self, from: data)
        
        return dogBreed
    }
}
