
import Foundation
import os.log

class GlobalVar {
    // background 255 241 223
    // lettres 255 160 30
    public var rien:Int = 99 // string not used
    var chordPatterns : Dictionary<ChordPatternName,ChordPattern>
    var stringToChord : Dictionary<String,ChordPatternName>

    let origineDesCordes = [4,9,2,7,11,4] // modulo 12
    let origineDesCordes2=[40,45,50,55,59,64] // vrai notes
    let nomsNotes = ["C","C#","D","Eb","E","F","F#","G","Ab","A","Bb","B"]
    
    var instru1_n=24 // Guitar
    var instru2_n=24 // Guitar
    var audioUnit: AudioUnitMIDISynth!
    //var sequence: SynthSequence!  // !!!
    var arpeggio = true
    
    var noteNameToNumber=Dictionary<String,Int>()
    //var maxNumberSongs = 8
    var mymax = [MyMax]()

    func saveMax() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mymax, toFile: MyMax.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Max successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save max...", log: OSLog.default, type: .error)
        }
    }
    
    func loadMax() -> [MyMax]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MyMax.ArchiveURL.path) as? [MyMax]
    }

    
    init(){
        //var chordStringToPattern = Dictionary<String,ChordPattern>()
        //var chordVToPattern = Dictionary<Int,ChordPattern>()
        
        // var chordPatterns = Dictionary<ChordPatternName,ChordPattern>()

        audioUnit = AudioUnitMIDISynth(instru1_n: instru1_n,instru2_n: instru2_n)
        //sequence = SynthSequence()

        /*   dim,aug, sus2,add9,_5,
         ChordPattern(v1: [0,3,6],names1: ["dim","o"]),
         ChordPattern(v1: [0,4,8],names1: ["aug","+"]),
         ChordPattern(v1: [0,7],names1:["5"]),
         ChordPattern(v1: [0,2,7], names1:["sus2"], positions1: [
         ChordPattern(v1: [0,2,4,7], names1:["add9"], positions1: [
         7sus4 ...
         */
        
        chordPatterns =
            [
                .maj: ChordPattern(v1: [0,4,7], names1: ["","maj","M"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,2,1,0,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,-1,-3,-3,-3,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,2,2,2,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,2,2,2,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,-1,-3,-2,-3], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,3,2], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,-2,-2], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,0,0,3], stringOfRoot1 : 3)]),
                
                .min: ChordPattern(v1: [0,3,7], names1: ["m","min","-"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,2,0,0,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,2,2,1,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,2,2,1,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,3,1], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,-3,0,0,0], stringOfRoot1 : 5)]),
                
                ._7: ChordPattern(v1: [0,4,7,10], names1: ["7","dom"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,0,1,0,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,rien,0,1,0,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,2,0,2,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,2,0,2,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,-1,0,-2,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,1,2], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,0,0,1], stringOfRoot1 : 3)]),
                
                .m7: ChordPattern(v1: [0,3,7,10], names1:["m7","min7"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,2,0,3,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,2,0,0,0,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,rien,0,0,0,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,2,0,1,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,2,0,1,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,1,1], stringOfRoot1 : 2)]),
                
                .maj7: ChordPattern(v1: [0,4,7,11], names1: ["maj7","M7","Δ","7M"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,1,1,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,rien,1,1,0,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-1,-3,-3,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,2,1,2,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,2,1,2,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,2,2], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,-2,-3], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,0,0,2], stringOfRoot1 : 3),
                    ]),
                
                .m7b5: ChordPattern(v1: [0,3,6,10], names1:["m7b5","m7(b5)","⌀","(m7b5)"], positions1: [
                    ChordGuitarPosition(v1 : [0,1,0,0,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,rien,0,0,-1,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,1,0,1,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,1,1,1], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,3,3,2,3], stringOfRoot1 : 3)]),
                
                ._9: ChordPattern(v1: [0,2,4,7,10],names1:["9"], positions1: [
                    ChordGuitarPosition(v1 : [0,-1,0,-1,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-1,0,0,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,1,0], stringOfRoot1 : 2)]),
                
                .dim7: ChordPattern(v1: [0,3,6,9], names1:["dim7","dim","o","º","o7","º7"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,-1,0,-1,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,1,-1,0,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,1,-1,1,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,1,0,1], stringOfRoot1 : 2)]),
                
                .m9: ChordPattern(v1: [0,2,3,7,10],names1:["m9","m7(9)"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,0,0,0,2], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,-2,0,-1,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-2,0,0,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,-2,1,0], stringOfRoot1 : 2)]),
                
                ._7b9: ChordPattern(v1: [0,1,4,7,10],names1:["7b9"], positions1: [
                    ChordGuitarPosition(v1 : [0,-1,0,-2,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-1,0,-1,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,1,-1], stringOfRoot1 : 2)]),
                
                ._7d9: ChordPattern(v1: [0,3,4,7,10],names1:["7#9"], positions1: [
                    ChordGuitarPosition(v1 : [0,-1,0,0,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-1,0,1,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,1,1], stringOfRoot1 : 2)]),
                
                ._6_9: ChordPattern(v1: [0,2,4,7,9],names1:["6/9"], positions1: [
                    ChordGuitarPosition(v1 : [0,-1,-1,-1,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,rien,1,1,2,2,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-1,-1,0,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,0,0], stringOfRoot1 : 2)]),
                
                .maj13: ChordPattern(v1: [0,4,7,9,11],names1:["maj13","Δ13"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,1,1,2,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,rien,1,2,2], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,0,-3], stringOfRoot1 : 2)]),
                
                .maj9: ChordPattern(v1: [0,2,4,7,11],names1:["maj9","Δ9"], positions1: [
                    ChordGuitarPosition(v1 : [0,-1,1,-1,0,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-1,1,0,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,2,0], stringOfRoot1 : 2)]),
                
                ._6: ChordPattern(v1: [0,4,7,9], names1:["6"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,-1,1,0,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,0,-1,-1,rien,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,0,-1,0,rien], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,0,2], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,0,0,0], stringOfRoot1 : 3)]),
                
                ._13: ChordPattern(v1: [0,4,7,9,10],names1:["13"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,0,1,2,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,rien,0,2,2], stringOfRoot1 : 1)]),
                
                .m6: ChordPattern(v1: [0,3,7,9],names1:["m6","min6"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,-1,0,0,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,rien,-1,1,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,2,-1,1,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,0,1], stringOfRoot1 : 2)]),
                
                .m11: ChordPattern(v1: [0,3,5,7,10],names1:["m11"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,0,0,-2,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,0,0,0,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,0,0,1,0], stringOfRoot1 : 1)]),
                
                .M_3:ChordPattern(v1: [0,4,7],names1:["/III"], positions1: [
                    ChordGuitarPosition(v1 : [4,2,2,1,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,4,2,2,2,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [-3,0,-1,-3,-2,-3], stringOfRoot1 : 1)]),
                
                .M_5:ChordPattern(v1: [0,4,7],names1:["/V"], positions1: [
                    ChordGuitarPosition(v1 : [7-12,rien,6-12,4-12,5-12,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,7-12,rien,6-12,5-12,5-12], stringOfRoot1 : 0)]),
                
                .add9:ChordPattern(v1: [0,2,4,7],names1:["add9"], positions1: [
                    ChordGuitarPosition(v1 : [0,-3,-3,-3,-3,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,rien,0,-1,-2,0], stringOfRoot1 : 2)]),
                
                ._7_5:ChordPattern(v1: [0,4,7,10],names1:["7/V"], positions1: [
                    ChordGuitarPosition(v1 : [7-12,rien,6-12,7-12,5-12,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,7-12,rien,6-12,8-12,5-12], stringOfRoot1 : 1)]),
                
                ._7_3:ChordPattern(v1: [0,4,7,10],names1:["7/III"], positions1: [
                    ChordGuitarPosition(v1 : [4-12,rien,2-12,4-12,3-12,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,4-12,rien,2-12,5-12,3-12], stringOfRoot1 : 1)]),

                ._13b9:ChordPattern(v1: [0,1,4,7,9,10],names1:["13b9"], positions1: [
                    ChordGuitarPosition(v1 : [1,rien,0,1,2,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,1,rien,0,2,2], stringOfRoot1 : 1)]),

                .aug7:ChordPattern(v1: [0,4,8,10],names1:["aug7","7#5","7b13","7(b13)"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,0,1,1,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,rien,0,2,1], stringOfRoot1 : 1)]),
                
                ._7sus4:ChordPattern(v1: [0,5,7,10],names1:["7sus4"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,0,2,0,0], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,2,0,3,0], stringOfRoot1 : 1)]),

                .minMaj:ChordPattern(v1: [0,3,7,11],names1:["mΔ","mM",
                                                              "maj7b5"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,1,1,-1,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,rien,1,2,-1], stringOfRoot1 : 1)]),

                .m_5:ChordPattern(v1: [0,3,7],names1:["m/V"], positions1: [
                    ChordGuitarPosition(v1 : [rien,2-12,2-12,0-12,0-12,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,rien,2-12,2-12,1-12,0-12], stringOfRoot1 : 1)]),
                
                .mb13:ChordPattern(v1: [0,3,7,8,10],names1:["m(b13)","mb13"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,0,0,1,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,3,0,0,0,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,rien,0,1,1], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,3,0,1,0], stringOfRoot1 : 1)]),
                
                .mb9:ChordPattern(v1: [0,1,3,7,10],names1:["m(b9)","mb9"], positions1: [
                    ChordGuitarPosition(v1 : [0,rien,0,0,0,1], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [0,-2,0,-2,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-2,0,-1,rien], stringOfRoot1 : 1)]),
                
                .aug:ChordPattern(v1: [0,4,8],names1:["aug","+"], positions1: [
                    ChordGuitarPosition(v1 : [0,-1,-2,-3,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,-1,-2,-2,rien], stringOfRoot1 : 1)]),
                
                ._5:ChordPattern(v1: [0,4,8],names1:["5"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,2,rien,rien,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,2,2,rien,rien], stringOfRoot1 : 1)]),
                
                .sus4: ChordPattern(v1: [0,5,7], names1:["sus4","sus"], positions1: [
                    ChordGuitarPosition(v1 : [0,2,2,2,0,rien], stringOfRoot1 : 0),
                    ChordGuitarPosition(v1 : [rien,0,2,2,3,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,0,-3,-2,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,3,3], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,0,-2,-2], stringOfRoot1 : 2)]),

                .sus2:ChordPattern(v1: [0,2,7],names1:["sus2"], positions1: [
                    ChordGuitarPosition(v1 : [rien,0,2,2,0,0], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,0,-3,-3,-2,rien], stringOfRoot1 : 1),
                    ChordGuitarPosition(v1 : [rien,rien,0,2,3,0], stringOfRoot1 : 2),
                    ChordGuitarPosition(v1 : [rien,rien,0,-3,-2,-2], stringOfRoot1 : 2)])

        ]
        
        stringToChord=Dictionary<String,ChordPatternName>()
        for a in chordPatterns {
            let l = a.value.names
            for s in l{
                stringToChord[s] = a.key
            }
        }
        
        noteNameToNumber = [
            "Cbb":10,"Cb":11,"C":0,"C#":1,"C##":2,
            "Dbb":0,"Db":1,"D":2,"D#":3,"D##":4,
            "Ebb":2,"Eb":3,"E":4,"E#":5,"E##":6,
            "Fbb":3,"Fb":4,"F":5,"F#":6,"F##":7,
            "Gbb":5,"Gb":6,"G":7,"G#":8,"G##":9,
            "Abb":7,"Ab":8,"A":9,"A#":10,"A##":11,
            "Bbb":9,"Bb":10,"B":11,"B#":0,"B##":1]
        
        if let mymax2 = loadMax() {
            mymax = mymax2
        }
        else {
            mymax = [MyMax(a:"8")]
        }

    }
    
    func chordPatternOfString(s:String)->ChordPattern{
        let a = stringToChord[s]!
        return chordPatterns[a]!
    }

    
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    
    let hotelCaliforniaString = """
[Verse]
Am                         E7
Fake lyrics (for copyright reasons the true lyrics were not included in the demo songs)
G                      D
Fake lyrics
F                          C
Fake lyrics
Dm
Fake lyrics
E
Fake lyrics


Am                               E7
Fake lyrics ... etc.
G
D
F                          C
Dm
E


[Chorus]

F                          C
E7                                          Am
F                               C
Dm                                       E


[Verse]

Am                            E7
G                                    D
F                                   C
Dm                       E

Am                           E7
G                                     D
F                                         C
Dm
E

[Chorus]

F                         C
E7                                          Am
F                             C
Dm                                               E


[Verse]

Am                        E7
G                                D
F                              C
Dm
E

Am                             E7
G                                       D
F                                   C
Dm
E
"""
    
    let redemptionSongString = """
[Verse]
    G                      Em   Em7
Fake lyrics (for copyright reasons the true lyrics were not included in the demo songs)
     C        G/B      Am
Fake lyrics
G                  Em      C         G/B        Am
Fake lyrics
       G            Em Em7
Fake lyrics
C      G/B           Am
Fake lyrics
   G                   Em    C   Am7    D
Fake lyrics

[Chorus]
                 G    C       D        G
Fake lyrics ... etc.
      C     D        Em   C  D       G      C
  D       G      C D

[Verse]
      G                           Em   Em7
            C          G/B          Am
G                        Em
              C        G/B         D
    G                        Em Em7
         C      G/B         Am
          G              Em
      C         Am7         D

[Chorus]
                  G    C       D        G
      C     D        Em   C  D       G      C
  D       G      C  D       G      C D

[Instrumental]
Em  C  D
Em  C  D
Em  C  D
Em  C  D

[Verse]
     G                           Em   Em7
           C           G/B          Am
             G                Em
              C              G/B            D
    G                        Em Em7
         C      G/B         Am
          G              Em
      C         Am7         D

[Chorus]
                  G    C       D        G
       C     D        Em   C  D       G
 C     D        Em   C  D       Em     C
       D        G      C  D        G

[Outro]
C  C/B  Am  Am6
"""
    
    let aleluyaString =
    """
[Intro]
C Am C Am

[Verse 1]
  C                 Am
Fake lyrics (for copyright reasons the true lyrics were not included in the demo songs)
     C                   Am
Fake lyrics
    F                G               C        G
Fake lyrics
        C                  F           G
Fake lyrics
    Am                 F
Fake lyrics
    G            E7             Am
Fake lyrics

[Chorus]
     F           Am          F           C    G   C      G
Fake lyrics ... etc.

[Verse 2]
          C                        Am
    C               Am
    F              G             C            G
C                   F       G
    Am                        F
    G                  E7            Am

[Chorus]
     F           Am          F           C    G   C      G

[Verse 3]
C              Am
     C                       Am
  F             G             C          G
C                          F      G
    Am                    F
       G               E7          Am

[Chorus]
     F           Am          F           C    G   C      G

[Verse 4]
     C                         Am
       C            Am
    F             G               C        G
      C             F        G
        Am            F
    G               E7            Am

[Chorus]
     F           Am          F           C    G   C      G

[Verse 5]
      C               Am
    C             Am
    F                G           C          G
     C                  F       G
     Am                 F
       G               E7          Am

[Outro]
     F           Am          F           C    G   C      G
"""

    
let listAllChords = """
A AM Amaj AΔ Amaj7 A7M AM7 Amaj13 AΔ13
Amaj9 AΔ9 A6 Aadd9 Asus4 Asus A6/9 A5 Asus2

A7 Adom A9 A13 A13b9 A7sus4 A7b9 A7#9

Am Amin A- Am7 Amin7 Am7(9) Am9 Am6 Amin6
Am11 Amb13 Am(b13) Amb9 Am(b9)

AmM AmΔ Amaj7b5

Adim Adim7 Am7(b5) A(m7b5) Am7b5

Aaug A+ Aaug7 A7#5 A7(b13) A7b13
"""
    
    let insensatez = """
D7/A Db7/G# G6 Bm7

Bm7 A13b9 Am6 E7/G#
G6 Cmaj7 Db(m7b5) F#aug7 Bm7
D7/A G#dim Gmaj7 Em7 Bm7
D7/A Db7/G# GmM F#aug7 Bm7

Bm7 A13b9 Am6 E7/G#
G6 Cmaj7 Db(m7b5) F#aug7 Bm7
D7/A G#dim Gmaj7 Em7 Bm7
D7/A Db7/G# GmM F#aug7 Bm7
"""
    
}

var globalVar = GlobalVar()



