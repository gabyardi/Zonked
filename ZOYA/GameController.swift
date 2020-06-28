//
//  GameController.swift
//  ZOYA
//
//  Created by Anna Gerchanovsky on 6/26/20.
//  Copyright © 2020 GAAG. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    
    var truthtable = [false]
    var labletable = ["college", "us", "corona"]
    var waspaused = false
    var clean = false
    //var currentcard = ["1", "no"]
    
    var paranoiaMode = false
    
    //college, us, corona
    
    //1 = buz'd (green)
    //2 = WHO (purple)
    //3 = misc (blue)
    //4 = ToD (red)
    
    var deck = [[String]]()
    var paranoiaDeck = [[String]]()
    
    let colors = [[UIColor.init(displayP3Red: 0.15, green: 0.35, blue: 0.15, alpha: 1), UIColor.init(displayP3Red: 0.85, green: 1, blue: 0.85, alpha: 1)], [UIColor.init(displayP3Red: 0.35, green: 0.15, blue: 0.35, alpha: 1), UIColor.init(displayP3Red: 1, green: 0.85, blue: 1, alpha: 1)], [UIColor.init(displayP3Red: 0.15, green: 0.15, blue: 0.35, alpha: 1), UIColor.init(displayP3Red: 0.85, green: 0.85, blue: 1, alpha: 1)], [UIColor.init(displayP3Red: 0.35, green: 0.15, blue: 0.15, alpha: 1), UIColor.init(displayP3Red: 1, green: 0.85, blue: 0.85, alpha: 1)], [UIColor.black, UIColor.white]]
    
    let labels = ["BUZ'D", "WHO", "misc", "ToD", "paranoia"]
    
    var currentcard = ["5", "Welcome!"]

    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var nextcardbutton: UIButton!
    @IBOutlet weak var card: UILabel!
    @IBOutlet weak var exitbutton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    
    func makeDeck(fname: String) -> Array<Array<String>> {
        
        let fileURLProject = Bundle.main.path(forResource: fname, ofType: "txt")
               var readStringProject = ""
               do {
                   readStringProject = try String(contentsOfFile: fileURLProject!, encoding:String.Encoding.utf8)
               } catch let error as NSError {
                   print("Failed to read file")
                   print(error)
               }
               let lines = readStringProject.components(separatedBy: "\n")
               var attribute = [[String]]()
               for item in lines {
                   //print(item.components(separatedBy: ":"))
                   attribute.append(item.components(separatedBy: ":"))
               }
               attribute.remove(at: attribute.count-1)
                //
        return attribute
    }
    
    func generateCard(newcard: [String]){
        card.text = newcard[1]
        let kind = (Int(newcard[0]) ?? 4) - 1
        //print(kind)
        self.view.backgroundColor = colors[kind][0]
        category.textColor = colors[kind][1]
        category.text = labels[kind]
        card.textColor = colors[kind][1]
    }
    
    //PRE LOADED ON SCREEN
    override func viewDidLoad() {
        //print(truthtable)
        backbutton.isHidden = true
        super.viewDidLoad()

        if waspaused == false {
            deck += makeDeck(fname: "deck")
            //deck.remove(at: deck.count-1)
            paranoiaDeck += makeDeck(fname: "paranoia")
            for i in 1...truthtable.count {
                let ex = truthtable[i-1]
                if ex {
                    deck += makeDeck(fname: labletable[i-1])
                }
            }
            if clean {
                var i = 0
                while i < deck.count {
                    if deck[i].count == 3 && deck[i][2] == " x" {
                        deck.remove(at: i)
                    }
                    else {
                        i += 1
                    }
                }
                var j = 0
                while j < paranoiaDeck.count {
                    if paranoiaDeck[j].count == 3 && paranoiaDeck[j][2] == " x" {
                        paranoiaDeck.remove(at: j)
                    }
                    else {
                        j += 1
                    }
                }
            }
            let index = Int.random(in: 0...(deck.count-1))
            currentcard = deck[index]
            deck.remove(at: index)
            generateCard(newcard: currentcard)
            if currentcard.count == 3 {
                if currentcard[2] == " paranoia"{
                    //calibrationButton.setTitle("Calibration", for: .normal)
                    nextcardbutton.setTitle("begin paranoia", for: .normal)
                    //nextcardbutton.Label = "begin paranoia"
                    paranoiaMode = true
                }
            }
        }
        else {
            generateCard(newcard: currentcard)
            if currentcard.count == 3 {
                if currentcard[2] == " paranoia"{
                    //calibrationButton.setTitle("Calibration", for: .normal)
                    nextcardbutton.setTitle("begin paranoia", for: .normal)
                    //nextcardbutton.Label = "begin paranoia"
                    paranoiaMode = true
                }
            }
            else if paranoiaMode {
                backbutton.isEnabled = true
                backbutton.isHidden = false
            }
        }
        
        waspaused = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HelpController {
            let help = segue.destination as! HelpController
            help.previouspage = "game"
            help.truthtable = truthtable
            help.paranoiaMode = paranoiaMode
            help.deck = deck
            help.paranoiaDeck = paranoiaDeck
            help.currentcard = currentcard
            help.exitbutton = exitbutton
            help.backbutton = backbutton
            help.nextcardbutton = nextcardbutton
        }
    }
    
    @IBAction func exitpressed(_ sender: Any) {
        performSegue(withIdentifier: "backward", sender: self)
    }
    @IBAction func backpressed(_ sender: Any) {
        paranoiaMode = false
        if deck.count == 0 {
            performSegue(withIdentifier: "GameOver", sender: self)
        }
        else {
            let index = Int.random(in: 0...(deck.count-1))
            currentcard = deck[index]
            deck.remove(at: index)
        }
        generateCard(newcard: currentcard)
        backbutton.isEnabled = false
        backbutton.isHidden = true
    }
    @IBAction func helppressed(_ sender: Any) {
        performSegue(withIdentifier: "gametohelp", sender: self)
    }
    
    @IBAction func nextcardpressed(_ sender: Any) {
        if paranoiaMode == true {
            let index = Int.random(in: 0...(paranoiaDeck.count-1))
            currentcard = paranoiaDeck[index]
            paranoiaDeck.remove(at: index)
            //exitbutton.setTitle("back to main game", for: .normal)
            backbutton.isEnabled = true
            backbutton.isHidden = false
            nextcardbutton.setTitle("next card", for: .normal)
            if paranoiaDeck.count == 0 {
                paranoiaMode = false
                //backbutton.isEnabled = false
                //backbutton.isHidden = true
            }
        }
        else if deck.count == 0 {
            performSegue(withIdentifier: "GameOver", sender: self)
            //currentcard = ["5", "GAME OVER"]
        }
        else {
            let index = Int.random(in: 0...(deck.count-1))
            currentcard = deck[index]
            deck.remove(at: index)
            if paranoiaDeck.count == 0 {
                backbutton.isEnabled = false
                backbutton.isHidden = true
            }
            //exitbutton.setTitle("EXIT", for: .normal)
        }
        generateCard(newcard: currentcard)
        if currentcard.count == 3 {
            if currentcard[2] == " paranoia"{
                nextcardbutton.setTitle("begin paranoia", for: .normal)
                //backbutton.isEnabled = true
                paranoiaMode = true
            }
            
        }
    }
   
}
