
import UIKit

class SongViewController2: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var bouttonMoinsKey: UIButton!
    @IBOutlet weak var bouttonPlusKey: UIButton!
    @IBOutlet weak var bouttonMoinsGuitarPosition: UIButton!
    @IBOutlet weak var bouttonPlusGuitarPosition: UIButton!
    @IBOutlet weak var bouttonNextChord: UIButton!
    @IBOutlet weak var bouttonPreviousChord: UIButton!
    
    var buttonNow=UIButton()
    var buttonNowSeen = false
    var tagNow: Int = 0
    var indexNow: Int = 0
    var lastAccord = Chord(root1: 0, cp1: .maj) // random but not null
    
    var allButtons = Dictionary<Int,UIButton>()
    var tagsToIndex = Dictionary<Int,Int>()
    var indexToTags:[Int] = []

    var song:Song?
    
    @IBAction func rootMoins1(_ sender: Any) {
        for (tag, button) in allButtons{
            let ligne = tag / 100
            let colonne = tag % 100
            let c = song!.lignes[ligne].chords[colonne]
            let aa = (c.root + 11) % 12
            song!.lignes[ligne].chords[colonne] = Chord(root1: aa, cp1: c.cp)
            let q = song!.positionsSpeciales[song!.lignes[ligne].chords[colonne].getName()]
            if q != nil {
                song!.lignes[ligne].chords[colonne].quellePosition = q!
            }
            button.setTitle(song!.lignes[ligne].chords[colonne].getName() + " " + song!.lignes[ligne].chords[colonne].getPositionName(), for: [])
        }
    }
    @IBAction func rootPlus1(_ sender: Any) {
        for (tag, button) in allButtons{
            let ligne = tag / 100
            let colonne = tag % 100
            let c = song!.lignes[ligne].chords[colonne]
            let aa = (c.root + 1) % 12
            song!.lignes[ligne].chords[colonne] = Chord(root1: aa, cp1: c.cp)
            let q = song!.positionsSpeciales[song!.lignes[ligne].chords[colonne].getName()]
            if q != nil {
                song!.lignes[ligne].chords[colonne].quellePosition = q!
            }
            button.setTitle(song!.lignes[ligne].chords[colonne].getName() + " " + song!.lignes[ligne].chords[colonne].getPositionName(), for: [])
        }
    }

    @IBAction func positionMoins1(_ sender: Any) {
        let colonne = tagNow % 100
        let ligne = tagNow / 100
        for i in 0 ..< song!.lignes.count{
            for j in 0 ..< song!.lignes[i].chords.count{
                if(song!.lignes[ligne].chords[colonne].cp == song!.lignes[i].chords[j].cp &&
                    song!.lignes[ligne].chords[colonne].root == song!.lignes[i].chords[j].root){
                    let aaa = song!.lignes[i].chords[j]
                    aaa.previousPosition()
                    allButtons[100*i+j]!.setTitle(aaa.getName() + " " + aaa.getPositionName(), for: [])
                }
            }
        }
        helloButton(sender:allButtons[100*ligne+colonne]!)
        
        let aaa = song!.lignes[ligne].chords[colonne]
        song!.positionsSpeciales[aaa.getName()] = aaa.quellePosition
    }
    
    @IBAction func positionPlus1(_ sender: Any) {
        let colonne = tagNow % 100
        let ligne = tagNow / 100
        for i in 0 ..< song!.lignes.count{
            for j in 0 ..< song!.lignes[i].chords.count{
                if(song!.lignes[ligne].chords[colonne].cp == song!.lignes[i].chords[j].cp &&
                song!.lignes[ligne].chords[colonne].root == song!.lignes[i].chords[j].root){
                    let aaa = song!.lignes[i].chords[j]
                    aaa.nextPosition()
                    allButtons[100*i+j]!.setTitle(aaa.getName() + " " + aaa.getPositionName(), for: [])
                }
            }
        }
        helloButton(sender:allButtons[100*ligne+colonne]!)
        
        let aaa = song!.lignes[ligne].chords[colonne]
        song!.positionsSpeciales[aaa.getName()] = aaa.quellePosition
    }
    @IBAction func positionPlusOut(_ sender: Any) {
        outButton(sender: buttonNow)
    }
    @IBAction func positionMoinsOut(_ sender: Any) {
        outButton(sender: buttonNow)
    }
    
    @IBAction func accordPrecedent(_ sender: Any) {
        if(indexNow > 0){
            indexNow -= 1
            let tag = indexToTags[indexNow]
            let b=allButtons[tag]!
            helloButton(sender: b)
        }
    }
    @IBAction func accordSuivant(_ sender: Any) {
        if(indexNow < allButtons.count - 1){
            indexNow += 1
            let tag = indexToTags[indexNow]
            let b=allButtons[tag]!
            helloButton(sender: b)
        }
    }
    @IBAction func accordPrecedentOut(_ sender: Any) {
        outButton(sender: buttonNow)
    }
    @IBAction func accordSuivantOut(_ sender: Any) {
        outButton(sender: buttonNow)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = true
        //self.view.frame.size.width
        scrollView.contentSize = CGSize(width: self.view.frame.size.width*3, height: 30*CGFloat(song!.lignes.count)+40)
        scrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]

        var i:Double = 0.0
        var aaa:Int = 0
        for l in song!.lignes {
            if l.chords.count == 0{
                //print(l.text)
                let textField = UITextField(frame: CGRect(
                    x: 5.0,
                    y: (30*i+10),
                    width: Double(scrollView.contentSize.width),
                    height: 30))
                textField.text = l.text
                textField.isUserInteractionEnabled = false
                setTextFieldParameters(textField: textField)
                scrollView.addSubview(textField)
                i += 1.0
            }else{
                var x:Double = 0
                for a in l.chords{
                    let myButton = UIButton(type: UIButtonType.system)
                    //Set a frame for the button. Ignored in AutoLayout/ Stack Views
                    var largeur:Double
                    if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                        largeur = Double(self.view.frame.size.width/5)
                    } else {
                        largeur = Double(self.view.frame.size.width/3)
                    }
                    myButton.frame = CGRect(
                        x: 5.0 + x * largeur,
                        y: (30*i+14),
                        width: largeur-4,
                        height: 30-4)
                    myButton.layer.cornerRadius = 5
                    myButton.backgroundColor = UIColor.white
                    //myButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                    // UIFont(name: YourfontName, size: 20)
                    myButton.setTitle(a.getName() + " " + a.getPositionName(), for: [])
                    myButton.setTitleColor(UIColor.black, for: [])
                    myButton.titleLabel?.minimumScaleFactor = 0.5
                    myButton.titleLabel?.numberOfLines = 1 // 0
                    myButton.titleLabel?.adjustsFontSizeToFitWidth = true

                    
                    myButton.backgroundColor = UIColor.green
                    if(!buttonNowSeen){
                        buttonNowSeen=true
                        buttonNow=myButton
                        tagNow = Int(i)*100 + Int(x)
                        indexNow = aaa // 0
                        myButton.backgroundColor = UIColor.yellow
                    }

                    myButton.tag = Int(i)*100 + Int(x)
                    myButton.addTarget(self,action: #selector(outButton),for: .touchUpInside)
                    myButton.addTarget(self,action: #selector(helloButton),for: .touchDown)
                    
                    allButtons[myButton.tag] = myButton
                    tagsToIndex[myButton.tag] = aaa
                    indexToTags += [myButton.tag]
                    scrollView.addSubview(myButton)
                    x+=1
                    aaa+=1
                }
                i += 1.0
            }
        }
    }
    
    @IBAction func helloButton(sender:UIButton){
        let ligne = (Int)(sender.tag) / 100
        let colonne = (Int)(sender.tag) % 100
        //print(song!.lignes[ligne].chords[colonne].getPositionName())

        buttonNow.backgroundColor = UIColor.green
        buttonNow = sender
        buttonNow.backgroundColor = UIColor.yellow

        tagNow = (Int)(sender.tag)
        indexNow = tagsToIndex[tagNow]!
        
        lastAccord.finirAccord()
        song!.lignes[ligne].chords[colonne].jouerAccord()
        lastAccord = song!.lignes[ligne].chords[colonne]
    }
    
    @IBAction func outButton(sender:UIButton){
        //let ligne = (Int)(sender.tag) / 100
        //let colonne = (Int)(sender.tag) % 100
        //song!.lignes[ligne].chords[colonne].finirAccord()
        //print(song!.lignes[ligne].chords[colonne].getPositionName())
    }

    func setTextFieldParameters(textField:UITextField){
        //textField.center = self.view.center
        textField.textAlignment = NSTextAlignment.left
        textField.backgroundColor = UIColor.white
        //textField.backgroundColor = UIColor(red: 39/255, green: 53/255, blue: 182/255, alpha: 1)
        //textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.black
        //textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.font = UIFont(name: "Verdana", size: 17)
        //textField.isSelectable = true
        //textField.isEditable = false
        //textField.autocorrectionType = UITextAutocorrectionType.no
        //textField.spellCheckingType = UITextSpellCheckingType.no
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
