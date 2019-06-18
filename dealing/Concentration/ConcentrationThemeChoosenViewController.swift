//
//  ConcentrationThemeChoosenViewController.swift
//  Proj4_AnimatedSet
//
//  Created by T  on 2019-03-09.
//  Copyright © 2019 En G. All rights reserved.
//

import UIKit

class ConcentrationThemeChoosenViewController: UIViewController {
    
    @IBOutlet weak var ThemeDessertButton: UIButton!
    @IBOutlet weak var ThemeAnimalButton: UIButton!
    @IBOutlet weak var ThemePlantButton: UIButton!
    @IBOutlet weak var ThemeDinnerButton: UIButton!
    
    lazy var buttonThemeDict =
        [ThemeDinnerButton : ["🍣🥗🍳🍤🥘🍜🍱🍙", [#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)]],    // dinner theme : white view black card
         ThemeAnimalButton : ["🐷🐍🐙🦑🦐🦀🐟🐖", [#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]],    // animal theme : green view pink card
         ThemePlantButton : ["🌵🎄🌺🍄🌴🌻🍀🍁", [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]],      // plant theme : brown view green card
         ThemeDessertButton : ["🍦🍩🎂🍮🍫🍪🍰🍿", [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)]]]   // dessert view : yellow view brown card
    
    
    @IBAction func ChangeTheme(_ sender: UIButton) {
        // ipad
        if let cvc = splitViewDetailViewController, let theme = buttonThemeDict[sender] {
            cvc.emojiThemes = theme
        } else if let cvc = lastSeguedToConcentrationViewController  {
            if let theme = buttonThemeDict[sender] {
                cvc.emojiThemes = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var lastSeguedToConcentrationViewController : ConcentrationViewController?
    
    private var splitViewDetailViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as?ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier {
            if id == "Choose Theme" {
                let dest = segue.destination as? ConcentrationViewController
                let button = sender as? UIButton
                if let theme = buttonThemeDict[button] {
                    dest?.emojiThemes = theme
                }
                lastSeguedToConcentrationViewController = dest
            }
        }
    }
    
  
}
