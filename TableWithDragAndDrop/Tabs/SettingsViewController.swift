//
//  SettingsViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {
    
    var appearanceSettingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let useLineSeparatorsSwitch = makeLabelSwitchInputStackView(labelName: "Use line separators", switchTapTarget: #selector(self.setLineSeparators(_:)), switchSetOn: defaults.bool(forKey: UserDefaultsKeys.useLineSeparators))
        let useLocalFileIfDownloadFailed = makeLabelSwitchInputStackView(labelName: "Use local file if offline", switchTapTarget: #selector(self.shouldUseLocalFileIfDownloadFailed(_:)), switchSetOn: defaults.bool(forKey: UserDefaultsKeys.useLocalFileIfDownloadFailed))
        
        self.view.addSubview(appearanceSettingsStackView)
        appearanceSettingsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        appearanceSettingsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        appearanceSettingsStackView.addArrangedSubview(useLineSeparatorsSwitch)
        appearanceSettingsStackView.addArrangedSubview(useLocalFileIfDownloadFailed)
    }
    
    @objc func setLineSeparators(_ sender: UISwitch!){
        defaults.set(sender.isOn, forKey: UserDefaultsKeys.useLineSeparators)
    }
    
    @objc func shouldUseLocalFileIfDownloadFailed(_ sender: UISwitch!){
        defaults.set(sender.isOn, forKey: UserDefaultsKeys.useLocalFileIfDownloadFailed)
    }
    
    private func makeLabelSwitchInputStackView(labelName: String, switchTapTarget: Selector, switchSetOn: Bool) -> UIStackView {
        let labelTextInputStackView = UIStackView()
        labelTextInputStackView.translatesAutoresizingMaskIntoConstraints = false
        labelTextInputStackView.axis = .horizontal
        labelTextInputStackView.spacing = 16
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelName + ":"
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.font = UIFont.systemFont(ofSize: 19)
        
        let uiswitch = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        uiswitch.addTarget(self, action: switchTapTarget, for: .touchUpInside)
        uiswitch.isOn = switchSetOn
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        
        labelTextInputStackView.addArrangedSubview(label)
        labelTextInputStackView.addArrangedSubview(uiswitch)
        
        return labelTextInputStackView
    }

}
