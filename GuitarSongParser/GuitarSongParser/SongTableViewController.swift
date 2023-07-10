
import UIKit
import os.log
import PopupDialog

class SongTableViewController: UITableViewController { //UISearchResultsUpdating
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var buttonSettings: UIBarButtonItem!
    
    var songs = [Song]()
    //var array = ["one","two"]
    //var filteredArray = [String]()
    //var songsDico = Dictionary<String, Song>()

    //var searchController = UISearchController()
    //var resultsController = UITableViewController()
    
    /*func updateSearchResults(for searchController: UISearchController) {
        filteredArray = array.filter({ (array:String) -> Bool in
            if array.contains(searchController.searchBar.text!){
                return true
            } else{
                return false
            }
        })
        resultsController.tableView.reloadData()
    }*/
    
    @IBAction func clickOnAddItemButton(_ sender: Any) {
        if(songs.count < Int( globalVar.mymax[0].a )! ){
            performSegue(withIdentifier: "AddItem", sender: sender)
        }else{
            // ========================
            
            
            // Prepare the popup assets
            let title = "Upgrade"
            let message = "The free app Guitar Song Parser allows you to store a maximum of 8 songs. Would you like to upgrade to the complete version and enjoy an unlimited number of songs ?"
            //let image = UIImage(named: "pexels-photo-103290")
            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message) //image: image
            
            // Create buttons
            let buttonOne = CancelButton(title: "Not now") {
                print("You canceled the dialog.")
            }
            
            // This button will not the dismiss the dialog
            let buttonTwo = DefaultButton(title: "Learn more") { //dismissOnTap: false
                //print("Go to purchase view")
                self.performSegue(withIdentifier: "JumpToPurchaseView", sender: self)
            }
            
            //let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
              //  print("Ah, maybe next time :)")
            //}
            
            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)

            
            // =========================
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchController = UISearchController(searchResultsController: resultsController)
        //tableView.tableHeaderView = searchController.searchBar
        //searchController.searchResultsUpdater = self
        
        //resultsController.tableView.delegate = self
        //resultsController.tableView.dataSource = self
        
        //let editImage    = UIImage(named: "icons8-settings-50")! //Webp.net-resizeimage
        //let editButton = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(didTapEditButton(sender: )))
        
        //let searchImage  = UIImage(named: "icons8-settings-50")!
        //let searchButton = UIBarButtonItem(image: searchImage,  style: .done, target: self, action: #selector(didTapSearchButton(sender: )))
        
        // Use the edit button item provided by the table view controller.
        // navigationItem.leftBarButtonItems = [buttonSettings]
        navigationItem.rightBarButtonItems = [addButton, editButtonItem] //addButton
        
        // Load any saved songs, otherwise load sample data.
        if let savedSongs = loadSongs() {
            songs += savedSongs
        }
        else {
            // Load the sample data.
            loadSampleSongs()
        }
        
    }

    @objc func didTapSearchButton(sender: AnyObject){
        print("search")
    }

    @objc func didTapEditButton(sender: AnyObject){
        print("edit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if tableView == resultsController.tableView{
        //    return filteredArray.count
        //}else{
            return songs.count
        //}
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SongTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SongTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }

        //if tableView != resultsController.tableView{
            cell.nameLabel.text = songs[indexPath.row].title
        //}else{
           // cell.nameLabel.text = filteredArray[indexPath.row]
        //}
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            songs.remove(at: indexPath.row)
            saveSongs()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = self.songs[fromIndexPath.row]
        songs.remove(at: fromIndexPath.row)
        songs.insert(movedObject, at: to.row)
        NSLog("%@", "\(fromIndexPath.row) => \(to.row) \(songs)")
        // To check for correctness enable: self.tableView.reloadData()
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            /// !!! popup if num >= max
            os_log("Adding a new song.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let songDetailViewController = segue.destination as? SongViewController1 else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedSongCell = sender as? SongTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedSongCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSong = songs[indexPath.row]
            songDetailViewController.song = selectedSong
            
        case "ShowSettings":
            os_log("Show settings.", log: OSLog.default, type: .debug)
            
        default:
            //fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            os_log("Unnamed segue.", log: OSLog.default, type: .debug)
        }
    }

    
    //MARK: Actions
    
    @IBAction func unwindToSongList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SongViewController1, let song = sourceViewController.song {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing song.
                songs[selectedIndexPath.row] = song
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new song.
                let newIndexPath = IndexPath(row: songs.count, section: 0)
                
                songs.append(song)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the songs.
            saveSongs()
        }
        
        if let sourceViewController = sender.source as? SongViewController2, let song = sourceViewController.song {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing song.
                songs[selectedIndexPath.row] = song
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new song.
                let newIndexPath = IndexPath(row: songs.count, section: 0)
                
                songs.append(song)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the songs.
            saveSongs()
        }

    }
    
    //MARK: Private Methods
    
    private func loadSampleSongs() {
        
        guard let song1 = Song(text1: globalVar.redemptionSongString, title: "Redemption Song")else { //, photo: photo1, rating: 4
            fatalError("Unable to instantiate song1")
        }

        guard let song2 = Song(text1: globalVar.hotelCaliforniaString, title: "Hotel California")else { //, photo: photo1, rating: 4
            fatalError("Unable to instantiate song2")
        }

        guard let song3 = Song(text1: globalVar.aleluyaString, title: "Aleluya")else {
            fatalError("Unable to instantiate song3")
        }
        
        let dico:[String:Int]=["Bm7": 0, "G6": 1, "Cmaj7": 2, "Gmaj7": 3, "A13b9": 1]
        guard let song4 = Song(text1: globalVar.insensatez, title: "Insensatez", positionsSpeciales: dico)else {
            fatalError("Unable to instantiate song4")
        }
        guard let song5 = Song(text1: globalVar.listAllChords, title: "All chords")else {
            fatalError("Unable to instantiate song5")
        }

        songs += [song1, song2, song3, song4, song5]
    }
    
    private func saveSongs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(songs, toFile: Song.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Songs successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save songs...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSongs() -> [Song]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Song.ArchiveURL.path) as? [Song]
    }
    
    

}




