import UIKit
import os.log


extension UITextView {
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
}



class SongViewController1: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var readSongButton: UIButton!
    
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        textView.delegate = self
        
        textView.addDoneButton()
        textView.autocorrectionType = .no

        // Set up views if editing an existing Song.
        if let song = song {
            navigationItem.title = song.title
            nameTextField.text = song.title
            textView.text = song.text
        }
        
        // Enable the Save button only if the text field has a valid Song name.
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
        readSongButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveButton.isEnabled = false
        readSongButton.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Ensure we're not at the start of the text field and we are inserting text
        if range.location > 0 && text.count > 0
        {
            let whitespace = CharacterSet.whitespaces
            
            let start = text.unicodeScalars.startIndex
            let location = textView.text.unicodeScalars.index(textView.text.unicodeScalars.startIndex, offsetBy: range.location - 1)
            
            //Check if a space follows a space
            if whitespace.contains(text.unicodeScalars[start]) && whitespace.contains(textView.text.unicodeScalars[location])
            {
                //Manually replace the space with your own space, programmatically
                textView.text = (textView.text as NSString).replacingCharacters(in: range, with: " ")

                //Make sure you update the text caret to reflect the programmatic change to the text view
                textView.selectedRange = NSMakeRange(range.location + 1, 0)
                
                //Tell UIKit not to insert its space, because you've just inserted your own
                return false
            }
        }
        
        return true
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddSongMode = presentingViewController is UINavigationController
        
        if isPresentingInAddSongMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The SongViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "segueToLast" {
            if let destVC = segue.destination as? SongViewController2 {
                let name = nameTextField.text ?? ""
                let text = textView.text ?? ""
                
                if(song == nil){
                    destVC.song = Song(text1: text, title: name)
                }else{
                    destVC.song = Song(text1: text, title: name, positionsSpeciales: song!.positionsSpeciales)
                }
            }
        }else {//if segue.identifier == ""
            guard let button = sender as? UIBarButtonItem else{return}
            if button == cancelButton {
                return
            } else if button == saveButton {
                let name = nameTextField.text ?? ""
                let text = textView.text ?? ""
                
                // Set the song to be passed to SongTableViewController after the unwind segue.
                if(song == nil){
                    song = Song(text1: text, title: name)
                }else{
                    song = Song(text1: text, title: name, positionsSpeciales: song!.positionsSpeciales)
                }
            }
        }
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        readSongButton.isEnabled = !text.isEmpty
    }
    
}

