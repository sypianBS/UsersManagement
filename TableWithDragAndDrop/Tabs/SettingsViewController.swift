//
//  SettingsViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let useLineSeparatorsSwitch = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        useLineSeparatorsSwitch.addTarget(self, action: #selector(self.respondToToggle(_:)), for: .valueChanged)
        useLineSeparatorsSwitch.setOn(defaults.bool(forKey: UserDefaultsKeys.useLineSeparators), animated: false)
        self.view.addSubview(useLineSeparatorsSwitch)
    }
    
    @objc func respondToToggle(_ sender: UISwitch!){
        defaults.set(sender.isOn, forKey: UserDefaultsKeys.useLineSeparators)
    }
}
