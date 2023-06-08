//
//  DogBreedTableViewController.swift
//  A2_WebServices
//
//  Created by Deepshika Ghale on 2023-06-04.
//

import UIKit

class DogBreedTableViewController: UITableViewController {
    
    var dogBreeds: DogBreedCodable!
    var dogBreedNames: [String] = []
    var dogBreedNamesWithoutSubBreed :[String] = []
    var dogBreedImages: DogBreedImageCodable!
    var dogBreedImg :[String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        Task{
            do{
                dogBreeds = try await DogBreedAPI_Helper.fetchDogBreed()
                dogBreedNames = Array(dogBreeds.message.keys).sorted()
                dogBreedNamesWithoutSubBreed = dogBreedNames.filter{
                    dogBreedName in let subBreeds = dogBreeds.message[dogBreedName] ?? []
                    return subBreeds.isEmpty
                }
                
                for breedName in dogBreedNames{
                    let subBreeds = dogBreeds.message[breedName] ?? []
                    if subBreeds.isEmpty{
                        dogBreedImages = try await DogBreedAPI_Helper.fetchDogBreedImage(breedName: breedName)
                        let imgURLString = dogBreedImages.message
                        dogBreedImg[breedName] = imgURLString
                    }else{
                        for subBreed in subBreeds{
                            dogBreedImages = try await DogBreedAPI_Helper.fetchDogBreedImage(breedName: breedName, subBreedName: subBreed)
                            let imgURLString = dogBreedImages.message
                            dogBreedImg["\(breedName)-\(subBreed)"] = imgURLString
                        }
                    }
                   
                }
                tableView.reloadData()
            }catch{
                preconditionFailure("Program fail with error message \(error)")
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dogBreedNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let breedName = dogBreedNames[section]
        let subBreeds = dogBreeds.message[breedName] ?? []
//        print(breedName)
        return subBreeds.isEmpty ? 1 : subBreeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breedName", for: indexPath) as! DogBreedTableView_CustomRowCell
        
        let breedName = dogBreedNames[indexPath.section]

        let subBreeds = dogBreeds.message[breedName] ?? []
        
        cell.dogBreedImageView.layer.cornerRadius = 20
        
        if subBreeds.isEmpty{
            cell.breedNameLabel.text = breedName
            cell.subBreedNameLabel.text = ""
            if let imgURLString = dogBreedImg[breedName], let imgURL = URL(string: imgURLString){
                Task{
                    do{
                        let (data, _) = try await URLSession.shared.data(from: imgURL)
                        if let image = UIImage(data: data){
                            cell.dogBreedImageView.image = image
//                            cell.dogBreedImageView.layer.cornerRadius = 20
                        }
                    }catch{
                            preconditionFailure("Failed to get image of \(breedName): \(error)")
                    }
                }
            }
        }else{
            let subBreed = subBreeds[indexPath.row]
            cell.breedNameLabel.text = breedName
            cell.subBreedNameLabel.text = subBreed
            if let imgURLString = dogBreedImg["\(breedName)-\(subBreed)"], let imgURL = URL(string: imgURLString){
                Task{
                    do{
                        let (data, _) = try await URLSession.shared.data(from: imgURL)
                        if let image = UIImage(data: data){
                            cell.dogBreedImageView.image = image
                            
                            
                        }
                    }catch{
                        preconditionFailure("Failed to get image of \(breedName)-\(subBreed): \(error)")
                    }
                }
            }
        }

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let index = tableView.indexPathForSelectedRow!.section
                let breedName = dogBreedNames[index]
                let subBreeds = dogBreeds.message[breedName] ?? []
                var selectedBreed: String
                if  subBreeds.isEmpty{
                    selectedBreed = breedName
                }else{
                    let index = tableView.indexPathForSelectedRow!.row
                    let subBreed = subBreeds[index]
                    selectedBreed = "\(breedName)-\(subBreed)"
                }
        let dst = segue.destination as! DogBreed_ViewController
        dst.breedName = selectedBreed
    }
    

}
