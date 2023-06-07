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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        Task{
            do{
                dogBreeds = try await DogBreedAPI_Helper.fetchDogBreed()
//                print(dogBreed.message.count)
                dogBreedNames = Array(dogBreeds.message.keys).sorted()
                dogBreedNamesWithoutSubBreed = dogBreedNames.filter{
                    dogBreedName in let subBreeds = dogBreeds.message[dogBreedName] ?? []
                    return subBreeds.isEmpty
                }
                
                
//                print(dogBreedNames)
                print("============================")
//                print(dogBreedNamesWithoutSubBreed)
//                print(dogBreed.message.first!)
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
        print(breedName)
        return subBreeds.isEmpty ? 1 : subBreeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breedName", for: indexPath) as! DogBreedTableView_CustomRowCell
        
        let breedName = dogBreedNames[indexPath.section]
//        print(breedName)
        let subBreeds = dogBreeds.message[breedName] ?? []
        
        if subBreeds.isEmpty{
            cell.breedNameLabel.text = breedName
            cell.subBreedNameLabel.text = ""
        }else{
            let subBreed = subBreeds[indexPath.row]
            cell.breedNameLabel.text = breedName
            cell.subBreedNameLabel.text = subBreed
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
