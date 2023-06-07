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
    private static var baseURLString = "https://dog.ceo/api/";
    
    //fetches data from the given url
    public static func fetch(urlString: String, urlParams: String? = nil) async throws -> Data{
        var urlStringWithparams = urlString
        if let urlParams = urlParams{
            urlStringWithparams += urlParams
        }
        guard
            let url = URL(string: urlStringWithparams)
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
            let data = try await fetch(urlString: baseURLString, urlParams: "breeds/list/all")
            
            let decoder = JSONDecoder()
            
            //decodes json data
            let dogBreed = try decoder.decode(DogBreedCodable.self, from: data)
            
            return dogBreed
        }
    
    public static func fetchDogBreedImage(breedName: String, subBreedName: String?=nil) async throws -> DogBreedImageCodable{
         var urlString = "breed/\(breedName)/images/random"
         if let subBreedname = subBreedName{
             urlString = "breed/\(breedName)/\(subBreedname)/images/random"
         }
 //        print(urlString)
         let data = try await fetch(urlString: baseURLString, urlParams: urlString)
         let decoder = JSONDecoder()
         
         //decodes json data
         let dogBreedImage = try decoder.decode(DogBreedImageCodable.self, from: data)
         
         return dogBreedImage
     }
}
