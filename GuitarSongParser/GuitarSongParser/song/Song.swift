
import Foundation
import UIKit
import os.log

//import GlobalVar

enum ChordPatternName{
    case maj, min, dim, aug, _7, maj7, m7, dim7, m7b5, sus4
    case sus2, _5, _6, m6, _9, maj9, m9, _13, maj13, _6_9
    case _7b9, _7d9, m11, M_3, M_5, add9, _7_5, _7_3
    case _13b9, aug7, _7sus4, minMaj, m_5, mb13, mb9
}

struct ChordGuitarPosition{
    var v : [Int]   // 6 numbers 0 to 19, or rien = cte (string not used)
    var stringOfRoot : Int  // 0 to 5
    
    init(v1 : [Int], stringOfRoot1 : Int){
        v = v1
        stringOfRoot = stringOfRoot1
    }
    
    mutating func add(n:Int){
        for i in 0...5{
            if v[i] != globalVar.rien{
                v[i] += n
            }
        }
    }
    
    func getName()->String{
        var s=""
        for i in 0...5{
            //let index = s.index(s.startIndex, offsetBy: i)
            if(v[i] != globalVar.rien){
                s+=String(v[i])
                if(v[i] >= 10 && i<5){
                    s+=["."]
                }
            }else{
                s+=["X"]
            }
        }
        return s
    }
    
    func getNotes()->[Int]{
        var l:[Int]=globalVar.origineDesCordes2
        for i in 0...5{
            if(v[i] != globalVar.rien){
                l[i] += v[i]
            } else {
                l[i] = 0
            }
        }
        return l
    }
}

class ChordPattern{
    var v : [Int]
    var names : [String]
    var positions : [ChordGuitarPosition]
    init(v1 : [Int], names1 : [String],  positions1 : [ChordGuitarPosition]){
        v = v1
        names = names1
        positions =  positions1
    }
}

class Chord{
    var root : Int
    var root2 : Int // pour slash chords
    var cp : ChordPatternName
    var guitarPositions : [ChordGuitarPosition]
    var quellePosition: Int
    
    func getName()->String{
        return globalVar.nomsNotes[(root+1200)%12] + globalVar.chordPatterns[cp]!.names[0]
    }
    
    func getPositionName()->String{
        return guitarPositions[quellePosition].getName()
    }
    
    func getPosition()->ChordGuitarPosition{
        return guitarPositions[quellePosition]
    }
    
    init(root1 : Int, cp1 : ChordPatternName ){
        root2 = root1 // never used in this case
        root = root1
        cp = cp1
        guitarPositions = globalVar.chordPatterns[cp]!.positions
        
        for i in 0..<guitarPositions.count{
            //var a =
            let b = guitarPositions[i].stringOfRoot
            let debut = (root - globalVar.origineDesCordes[b] + 1200) % 12
            let m = guitarPositions[i].v.min()!
            if (m + debut) >= 0 {
                guitarPositions[i].add(n: debut)
            }else{
                guitarPositions[i].add(n: debut + 12)
            }
        }
        
        guitarPositions.sort{$0.v.min()! < $1.v.min()!}
        
        quellePosition = 0
    }
    
    init(root1 : Int, cp1 : ChordPatternName, root2 : Int ){
        self.root2 = root2
        root = root1
        var difference:Int = root2 - root1
        if difference < 0{
            difference+=12
        }
        var vraiCP:ChordPatternName = .M_5 // just to be initialized
        if difference == 7{
            if(cp1 == ._7){
                vraiCP = ._7_5
            }else if cp1 == .maj {
                vraiCP = .M_5
            }else if cp1 == .min{
                vraiCP = .m_5
            }
        }else if difference == 4{
            if(cp1 == ._7){
                vraiCP = ._7_3
            }else if cp1 == .maj {
                vraiCP = .M_3
            }
        }
        cp = vraiCP
        
        guitarPositions = globalVar.chordPatterns[vraiCP]!.positions

        for i in 0..<guitarPositions.count{
            //var a =
            let b = guitarPositions[i].stringOfRoot
            let debut = (root - globalVar.origineDesCordes[b] + 1200) % 12
            let m = guitarPositions[i].v.min()!
            if (m + debut) >= 0 {
                guitarPositions[i].add(n: debut)
            }else{
                guitarPositions[i].add(n: debut + 12)
            }
        }
        
        guitarPositions.sort{$0.v.min()! < $1.v.min()!}
        
        quellePosition = 0
    }

    
    func nextPosition(){
        if(quellePosition<guitarPositions.count-1){
            quellePosition+=1
        }else{
            quellePosition=0
        }
    }
    
    func previousPosition(){
        if(quellePosition>0){
            quellePosition-=1
        }else{
            quellePosition=guitarPositions.count-1
        }
    }
    
    
    func jouerAccord(){
        globalVar.audioUnit.playChord(n:UInt32(0), v:guitarPositions[quellePosition].getNotes(), vol:100)
    }
    
    func finirAccord(){
        globalVar.audioUnit.stopChord(n:UInt32(0), v:guitarPositions[quellePosition].getNotes())
    }
}

class Ligne{
    var text:String="" // text de la ligne
    var chords:[Chord]=[]  // avec les positions, la racine, etc.
    var chordStrings:[String]=[]  // " Am"
    var chordPositions:[Int] // position dans la ligne (par ex 17)
    
    func stringToChord(a:String)->Chord{ // TODO
        let s1 = globalVar.matches(for: "[A-G](##?|bb?)?", in: a)
        let s2 = globalVar.matches(for: "(maj13|Δ13|7b9|7#9|7#5|7[(]b13[)]|7b13|mb13|m[(]b13[)]|mb9|m[(]b9[)]|mM|maj7b5|add9|13b9|aug7|7sus4|mΔ|sus4|sus2|sus|maj7|min7|dim7|7M|m7[(]b5[)]|[(]m7b5[)]|m7b5|-|9|dim7|m7(9)|m9|6/9|maj9|Δ9|6|13|m6|min6|m11|sus|maj|dom|m7|M7|M|m|dim|min|aug|Δ|7|[+]|5)", in: a)
        let s11 = s1[0]
        var s33: String = "C"
        if(s1.count > 1){
            s33 = s1[1]
        }
        
        var s22: String
        if(s2.count > 0){
            s22 = s2[0]
        } else {
            s22 = ""
        }
        
        let root = globalVar.noteNameToNumber[s11]
        let chordPatternName = globalVar.stringToChord[s22]
        if(s1.count > 1){
            let root2 = globalVar.noteNameToNumber[s33]
            return Chord(root1: root!,cp1: chordPatternName!, root2: root2!)
        }else{
            return Chord(root1: root!,cp1: chordPatternName!)
        }
    }
    
    init(text1:String, chordStrings1:[String], chordPositions1:[Int]){
        text=text1
        chordPositions=chordPositions1
        chordStrings=chordStrings1
        for a in chordStrings{
            chords += [stringToChord(a:a)]
        }
    }
}

/*
struct ChordID: Hashable{
    let root : Int
    let cp : ChordPatternName

    init(root: Int, cp: ChordPatternName){
        self.root = root
        self.cp = cp
    }
    static func == (lhs: ChordID, rhs: ChordID) -> Bool {
        return lhs.cp == rhs.cp && lhs.root == rhs.root
    }
}*/


class Song: NSObject, NSCoding {
    var positionsSpeciales : [String:Int]
    var lignes:[Ligne] = []
    var text:String
    var title:String

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("songs")
    struct PropertyKey {
        static let title = "title"
        static let text = "text"
        static let positionsSpeciales = "positionsSpeciales"
    }

    init?(text1:String, title:String, positionsSpeciales:[String:Int] = [String:Int]()){
        self.positionsSpeciales = positionsSpeciales
        
        guard !title.isEmpty else {
            return nil
        }
        
        if title.isEmpty { //|| rating < 0
            return nil
        }

        self.title = title
        
        // (1):
        // (?m)(^| )
        let pat = "([A-G](##?|bb?)?((maj13|Δ13|7b9|7#9|7#5|7[(]b13[)]|7b13|mb13|m[(]b13[)]|mb9|m[(]b9[)]|mM|maj7b5|add9|13b9|aug7|7sus4|mΔ|sus4|sus2|sus|maj7|min7|dim7|7M|m7[(]b5[)]|[(]m7b5[)]|m7b5|-|9|dim7|m7(9)|m9|6/9|maj9|Δ9|6|13|m6|min6|m11|sus|maj|dom|m7|M7|M|m|dim|min|aug|Δ|7|[+]|5)\\d?)?(/[A-G](##?|bb?)?)?)((?!\\w)|$)"
        
        // (2):
        text = text1+"\n"
        
        // (3):
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let regex2 = try! NSRegularExpression(pattern: "(.)*(\n)", options: [])
        
        // (4):
        let matches2 = regex2.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        
        var s:String=""
        var s2:String=""
        var l:[String]=[]
        var l2:[Int]=[]
        for match in matches2 {
            l=[]
            l2=[]
            let range = match.range(at: 0)
            let r = text.index(text.startIndex,offsetBy:range.location) ..<
                text.index(text.startIndex,offsetBy:range.location+range.length-1)
            s = String(text[r])
            
            let matches = regex.matches(in: s, options: [], range: NSRange(location: 0, length: s.count))
            for mamatch in matches{
                let marange = mamatch.range(at: 0)
                let r2 = text.index(s.startIndex,offsetBy:marange.location) ..<
                    text.index(s.startIndex,offsetBy:marange.location+marange.length)
                s2 = String(s[r2])
                l+=[s2]
                l2+=[marange.location]
            }
            lignes += [Ligne(text1: s, chordStrings1: l, chordPositions1: l2)]
        }
        
        // gere les positions speciales
        for ligne in lignes{
            for accord in ligne.chords{
                let q = positionsSpeciales[accord.getName()]
                if q != nil {
                    accord.quellePosition = q!
                }/* else{
                    accord.quellePosition = 0
                }*/
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(text, forKey: PropertyKey.text)
        //if let positionsSpeciales = positionsSpeciales {
        //let a = positionsSpeciales
        aCoder.encode(positionsSpeciales, forKey: PropertyKey.positionsSpeciales)
        //}
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let text = aDecoder.decodeObject(forKey: PropertyKey.text) as? String else {
            os_log("Unable to decode the text.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let positionsSpeciales = aDecoder.decodeObject(forKey: PropertyKey.positionsSpeciales) as? [String:Int] else {
            os_log("Unable to decode the positions speciales.", log: OSLog.default, type: .debug)
            return nil
        }

        // Because photo is an optional property of Meal, just use conditional cast.
        //let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        //let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(text1:text, title: title, positionsSpeciales: positionsSpeciales) //, photo: photo, rating: rating
        
    }

}









