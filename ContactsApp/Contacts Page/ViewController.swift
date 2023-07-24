//
//  ViewController.swift
//  ContactsApp
//
//  Created by Seher Köse on 23.07.2023.
//
import UIKit

struct ContactModel{
    var titleName: String
    var relationType: RelationType
    var gender: Gender
    
}

enum Gender: CaseIterable{
    case female
    case male
    
    var genderType: String{
        switch self{
        case .female:
            return "female"
        case .male:
            return "male"
            
        }
    }
}

enum RelationType: CaseIterable{
    case allContacts
    case family
    case friends
    case work
    case danceClub
    case bookClub
    
    var relationType: String{
        switch self {
            case .allContacts:
                 return "All Contacts"
             case .family:
                 return "Family"
             case .friends:
                 return "Friends"
             case .work:
                 return "Work"
             case .danceClub:
                 return "Dance Club"
             case .bookClub:
                 return "Book Club"
      
        }
    }
}

class Contacts{
    static let contacts:[ContactModel] = [
        ContactModel(titleName: "Serkan", relationType: .family, gender: .male),
        ContactModel(titleName: "Aslı", relationType: .friends, gender: .female),
        ContactModel(titleName: "Aleyna", relationType: .friends, gender: .female),
        ContactModel(titleName: "Tuğçe", relationType: .work, gender: .female),
        ContactModel(titleName: "Ahmet", relationType: .family, gender: .male),
        ContactModel(titleName: "Ayşe", relationType: .bookClub, gender: .female),
        ContactModel(titleName: "Ceren", relationType: .bookClub, gender: .female),
        ContactModel(titleName: "Mert", relationType: .friends, gender: .male),
        ContactModel(titleName: "Onur", relationType: .work, gender: .male),
        ContactModel(titleName: "İhsan", relationType: .work, gender: .male),
        ContactModel(titleName: "İrem", relationType: .friends, gender: .female),
        ContactModel(titleName: "Ali", relationType: .danceClub, gender: .male),
        ContactModel(titleName: "Melis", relationType: .work, gender: .female),
        ContactModel(titleName: "Tarık", relationType: .danceClub, gender: .male),
        ContactModel(titleName: "Elif", relationType: .family, gender: .female),
        ContactModel(titleName: "Dilara", relationType: .danceClub, gender: .female),
        ContactModel(titleName: "Cansu", relationType: .family, gender: .female),
        ContactModel(titleName: "Tuğba", relationType: .bookClub, gender: .male),
        ContactModel(titleName: "Necla", relationType: .danceClub, gender: .female),
        ContactModel(titleName: "Hasan", relationType: .work, gender: .male),
        ContactModel(titleName: "Sinem", relationType: .work, gender: .female)
        ]
}


class ViewController: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    
    
    private var selectedRelationType: RelationType?{
        //tableView reload every changes in selectedRelationType
        didSet{
            contactTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.dataSource = self
        contactTableView.delegate = self
        
        let filterButton = UIBarButtonItem(image:UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), style: .done, target:self, action:#selector(filterButtonAct))
        
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func filterButtonAct(){
        let storyboard = UIStoryboard(name: "PickerViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as?
            PickerViewController{
            
            //assign self to delegate after implement pickerview extension in view controller
            //to run func didSelectRelationType operations in view controller
            vc.delegate = self
            
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc,animated: true)
            
        }
    }

}

//MARK: PickerViewController Delegate Methods
extension ViewController: PickerViewControllerDelegate {
    func didSelectRelationType(_ type: RelationType) {
        selectedRelationType = type
        print(type)
    }
}

//MARK: TableView Delegate Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        //return setSections().count
        //return RelationType.allCases.count
        
        if selectedRelationType == .allContacts{
            return RelationType.allCases.count
        }else {
            return setSections().count
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return setSections()[section].relationType
        //return RelationType.allCases[section].relationType
        
        if selectedRelationType == .allContacts{
            return RelationType.allCases[section].relationType
        }else {
            return setSections()[section].relationType
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterContacts(section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        cell.cellImageView.image = UIImage(named: filterContacts(indexPath.section)[indexPath.row].gender.genderType)
        cell.cellTitleLabel.text = filterContacts(indexPath.section)[indexPath.row].titleName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as?
            DetailViewController{
            
            // all contacts in the selected section
            let selectedContacts = filterContacts(indexPath.section)
            // selected contact from the section
            let selectedContact = selectedContacts[indexPath.row]

            
            let contactName = filterContacts(indexPath.section)[indexPath.row].titleName
            vc.name = contactName
            
            let contactRelation = filterContacts(indexPath.section)[indexPath.row].relationType.relationType
            vc.relation = contactRelation
            
            let contactImage = UIImage(named: filterContacts(indexPath.section)[indexPath.row].gender.genderType)
            vc.imageSelected = contactImage
            
            
            vc.selectedRelations = selectedContacts.filter {$0.titleName != selectedContact.titleName }

            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    private func setSections() -> [RelationType] {
        if selectedRelationType == nil{
            return RelationType.allCases
        }
        else{
            return[selectedRelationType!]
        }
    }
    
    private func filterContacts(_ sectionIndex: Int) -> [ContactModel] {
        if selectedRelationType == nil || selectedRelationType == .allContacts {
            return Contacts.contacts.filter({$0.relationType==RelationType.allCases[sectionIndex]})
        }
        else{
            return Contacts.contacts.filter({$0.relationType==selectedRelationType})
        }
  
    }
    
}


