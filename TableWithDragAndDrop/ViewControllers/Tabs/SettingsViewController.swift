//
//  SettingsViewController.swift
//  TableWithDragAndDrop
//
//  Created by Beniamin on 12.03.22.
//

import UIKit
import Combine

class SettingsViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
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

        basicUIsetup()
    }
    
    private func basicUIsetup() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let useLineSeparatorsSwitch = makeLabelSwitchInputStackView(labelName: "Use line separators", switchTapTarget: setLineSeparators, switchSetOn: defaults.bool(forKey: UserDefaultsKeys.useLineSeparators))
        let useLocalFileIfDownloadFailed = makeLabelSwitchInputStackView(labelName: "Use local file if offline", switchTapTarget: shouldUseLocalFileIfDownloadFailed, switchSetOn: defaults.bool(forKey: UserDefaultsKeys.useLocalFileIfDownloadFailed))
        
        self.view.addSubview(appearanceSettingsStackView)
        appearanceSettingsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        appearanceSettingsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        appearanceSettingsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        appearanceSettingsStackView.addArrangedSubview(useLineSeparatorsSwitch)
        appearanceSettingsStackView.addArrangedSubview(useLocalFileIfDownloadFailed)
    }
    
    func setLineSeparators(isOn: Bool) {
        defaults.set(isOn, forKey: UserDefaultsKeys.useLineSeparators)
    }
    
    func shouldUseLocalFileIfDownloadFailed(isOn: Bool) {
        defaults.set(isOn, forKey: UserDefaultsKeys.useLocalFileIfDownloadFailed)
    }
    
    private func makeLabelSwitchInputStackView(labelName: String, switchTapTarget: @escaping (Bool) -> Void, switchSetOn: Bool) -> UIStackView {
        let labelTextInputStackView = UIStackView()
        labelTextInputStackView.translatesAutoresizingMaskIntoConstraints = false
        labelTextInputStackView.axis = .horizontal
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelName + ":"
        label.font = UIFont.systemFont(ofSize: 19)
        
        let uiswitch = UISwitch()
        uiswitch.isOnPublisher.sink { isOn in
            switchTapTarget(isOn)
        }.store(in: &cancellables)
        uiswitch.isOn = switchSetOn
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        
        labelTextInputStackView.addArrangedSubview(label)
        labelTextInputStackView.addArrangedSubview(uiswitch)
        
        return labelTextInputStackView
    }

}
