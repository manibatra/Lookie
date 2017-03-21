//
//  WordTableViewController.swift
//  Dictionary
//
//  Created by Mani Batra on 13/3/17.
//  Copyright © 2017 Mani Batra. All rights reserved.
//

import UIKit

class WordTableViewController: UITableViewController {
    
    var blockArray: NSArray!
    var refinedBlockArray: NSArray!
    var activityIndicator: UIActivityIndicatorView! //activity indicator to placate user when your code is lazy
    
    
    /**
     * Method name: addActivityIndicator
     * Description: shows the activity indicator in the view
     * Parameters:
     */
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    
    /**
     * Method name: removeActivityIndicator
     * Description: removes the activity indicator from the view
     * Parameters:
     */
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating a "refined array" of blocks which have confidence level above 80 and preprocessing
        let tempSet: NSMutableSet! = NSMutableSet.init()
        for obj in blockArray {
            
            let block = obj as! G8RecognizedBlock
            if (block.confidence > 80 && block.text.trimmingCharacters(in: CharacterSet.punctuationCharacters).characters.count > 1) {
                tempSet.add(block)
            }
            
        }
        
        refinedBlockArray = tempSet.allObjects as NSArray!
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return refinedBlockArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // setting the text of the cell
        let block = refinedBlockArray.object(at: indexPath.row) as! G8RecognizedBlock
        
        //remove unwanted punctuation marks and set the title text
        cell.textLabel?.text = block.text.trimmingCharacters(in: CharacterSet.punctuationCharacters)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        addActivityIndicator()
        //getting the word from the selected row and showing the meaning if it is valid
        let word = tableView.cellForRow(at: indexPath)?.textLabel?.text
        if ( UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word!)) {
            let dictionary = UIReferenceLibraryViewController.init(term: word!)
            self.present(dictionary, animated: true, completion: {
                
                self.removeActivityIndicator()
                
            })
        } else {
            
            //check if the dictionary is installed, if not present a dialouge to install it
            if(!UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: "the")){
                
                let dictionary = UIReferenceLibraryViewController.init(term: "Install Dictionary")
                self.present(dictionary, animated: true, completion: {
                    
                    let alert = UIAlertController(title: "Dictionary Unavailable", message: "Please install British/American English Dictionary by tapping Manage then select Settings > General > Dictionary > British/United States English", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    dictionary.present(alert, animated: true, completion: nil )
                    self.removeActivityIndicator()
                })
            } else {
                //show alert view if an invalid word is selected
                tableView.cellForRow(at: indexPath)?.isSelected = false
                let alert = UIAlertController(title: "Invalid Word", message: "The word recognised by Dictionary is invalid", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: {
                    self.removeActivityIndicator()
                })
            }
        }
        
        
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}