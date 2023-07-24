//
//  PickerViewController.swift
//  ContactsApp
//
//  Created by Seher Köse on 23.07.2023.
//

import Foundation
import UIKit

protocol PickerViewControllerDelegate {
    func didSelectRelationType(_ type: RelationType)
}

class PickerViewController: UIViewController{
    
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var filterLabel: UILabel!
    
    public var selectedRelationType: RelationType?
    
    var delegate: PickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterPicker.delegate = self
        filterPicker.dataSource = self
        
    }
 
    @IBAction func doneButtonAct(_ sender: Any) {
        //tetikleme
        delegate?.didSelectRelationType(selectedRelationType ?? .allContacts)
        dismiss(animated: true)
        
    }
    @IBAction func cancelButtonAct(_ sender: Any) {
        dismiss(animated: true)
    }

}

extension PickerViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RelationType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RelationType.allCases[row].relationType
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRelationType = RelationType.allCases[row]
        filterLabel.text = RelationType.allCases[row].relationType
        
    }
    
    
}
