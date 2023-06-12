//
//  DogBreed_ViewController.swift
//  A2_WebServices
//
//  Created by Bikash Chhantyal on 2023-06-07.
//

import UIKit

class DogBreed_ViewController: UIViewController {
    var dogBreedImage: DogBreedImageCodable!
    var breedName: String?
    
    @IBOutlet weak var dogImage: UIImageView!
    
    
    @IBOutlet weak var btnLabel: UIButton!
    

    @IBAction func getRandomImage(_ sender: Any) {
        if let breedName = breedName{
            //split breedname
            let breedElements = breedName.components(separatedBy: "-")
            
            //if count is 1
            if breedElements.count == 1{
                // it has only breed and no subbreeds
                // fetch data and display image
                fetchDogBreedImage(breedName: breedElements[0])
            }else if breedElements.count == 2{
                // has subbreeds
                //fetch data and display image
                fetchDogBreedImage(breedName: breedElements[0], subBreedName: breedElements[1])
            }
        }
    }
    
    // function to change label of button
    func changeBtnLabel(){
        if let breedName = breedName{
            btnLabel.setTitle("Get Image of \(breedName)", for: .normal)
        }
    }
    
    func fetchDogBreedImage(breedName: String, subBreedName: String? = nil){
        Task{
            do{
                var imageURL: URL?
                if let subBreedName = subBreedName{
                    //fetch the image for dog with sub breed
                    dogBreedImage = try await DogBreedAPI_Helper.fetchDogBreedImage(breedName: breedName, subBreedName: subBreedName)
                    
                    //convert string into url
                     imageURL = URL(string: dogBreedImage.message)
                    if let imageURL = imageURL{
                        //get image data from the url
                        let (data, _) = try await URLSession.shared.data(from: imageURL)
                        if let image = UIImage(data: data){
                            //update the dogImage view
                            dogImage.image = image
                        }
                }
                }else{
                    // fetch the dog image for main breed dog
                    dogBreedImage = try await DogBreedAPI_Helper.fetchDogBreedImage(breedName: breedName)
                    
                    //convert the string into URL
                    imageURL = URL(string: dogBreedImage.message)
                    
                    if let imageURL = imageURL{
                        // get the image data from the url
                        let (data, _) = try await URLSession.shared.data(from: imageURL)
                        if let image = UIImage(data: data){
                            // update the image view with main dog breed image
                            dogImage.image = image
                        }
                }
                }
            } catch {
                preconditionFailure("Failed to get image of dog breed: \(error)")
            }
    }
    }
    
    override func viewDidLoad() {
        if let breedName = breedName{
            self.title = breedName
        }
        
        if let breedName = breedName{
            let breedElements = breedName.components(separatedBy: "-")
            if breedElements.count == 1{
                fetchDogBreedImage(breedName: breedElements[0])
            }else if breedElements.count == 2{
                fetchDogBreedImage(breedName: breedElements[0], subBreedName: breedElements[1])
            }
        }
        super.viewDidLoad()
       
        changeBtnLabel()
        // Do any additional setup after loading the view.
        
  
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
