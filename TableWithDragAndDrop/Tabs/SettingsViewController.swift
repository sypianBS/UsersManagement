//
//  SettingsViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {
    
    static var useLineSeparators = CurrentValueSubject<Bool, Never>(false)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let useLineSeparatorsSwitch = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        useLineSeparatorsSwitch.addTarget(self, action: #selector(self.respondToToggle(_:)), for: .valueChanged)
        useLineSeparatorsSwitch.setOn(false, animated: false)
        self.view.addSubview(useLineSeparatorsSwitch)
    }
    
    @objc func respondToToggle(_ sender: UISwitch!)
     {
         if (sender.isOn == true){
             SettingsViewController.useLineSeparators.send(true)
         }
         else{
             SettingsViewController.useLineSeparators.send(false)
         }
     }
}
