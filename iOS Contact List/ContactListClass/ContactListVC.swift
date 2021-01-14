//
//  ContactListVC.swift
//  iOS Contact List
//
//  Created by Purushottam on 11/01/21.
//  Copyright © 2021 Purushottam. All rights reserved.
//

import UIKit



class ContactListVC: UIViewController,UISearchControllerDelegate,UIScrollViewDelegate {
    
    //outlet
    @IBOutlet weak var noResultlable: UILabel!
    @IBOutlet weak var contactListTableView:UITableView!
    
    //variable
    fileprivate  var contacts = [ContactStructmodel]()
    fileprivate  var contactLisSavedtArray = [ContactData]()
    fileprivate  var contactLisSearchedtArray = [ContactData]()
    
    fileprivate  var contactId = 0
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let decimalCharacters = CharacterSet.decimalDigits

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // common initialization
        commonInit()
    }
    
    
    //MARK - : common initialization
    private func commonInit(){
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.delegate = self
        //CoreDBhelper.shared.deleteAllData(entity: "ContactList")

        refreshContactListCall()
        searchController.searchBar.setTextField(color: .white)
        
        contactListTableView.register(UINib(nibName: "ContactListTableCell", bundle: nil), forCellReuseIdentifier: "ContactListTableCell")
    }
    
    
  
    
    //MARK :- Get sorted contacts data
    private func getSortedContact(contactArray:[ContactData]){

        noResultlable.isHidden = !contactArray.isEmpty
        
        var sectionedData: [String: [ContactData]] = [:]
        
        let sortedContactListArray =  contactArray.sorted { $0.name.lowercased() < $1.name.lowercased() }
        sortedContactListArray.forEach {
            
            guard let firstLetter = $0.name.first else {
                sectionedData["#"] = (sectionedData["#"] ?? []) + [$0]
                return
            }
            
            let firstLetterStr = String(firstLetter)
            let decimalRange = $0.name.rangeOfCharacter(from: decimalCharacters)

            if decimalRange != nil {
            print("Numbers found")
            sectionedData["#"] = (sectionedData["#"] ?? []) + [$0]
            }
            else{
            sectionedData[firstLetterStr] = (sectionedData[firstLetterStr] ?? []) + [$0]
            }
            
            
        }
        
        let allContactSortedData =  sectionedData.sorted { $0.key < $1.key }
        self.contacts.removeAll()
        
        for i in allContactSortedData{
            let singleObj = ContactStructmodel(alphaBateType: i.key, contactList: i.value)
            self.contacts.append(singleObj)
        }
        
        self.contactListTableView.reloadData()
        
    }
    
    //MARK:- refresh contact data list
    private func refreshContactListCall(){
        let nsmanagedObjectData  = CoreDBhelper.shared.getDataFromDb(listName: "ContactList")
        noResultlable.isHidden = !nsmanagedObjectData.isEmpty

        
        print("saved array====\(contactLisSavedtArray)")
        if !nsmanagedObjectData.isEmpty{

            contactLisSavedtArray = (CoreDBhelper.shared.convertDBDataToDBUser(object: nsmanagedObjectData))
            contactId = contactLisSavedtArray.count
            getSortedContact(contactArray: contactLisSavedtArray)
        }
        
        print("contact list data==\(contactLisSavedtArray.count)")
    }
    
    
    @IBAction func onClickAddContactBarBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "AddAndEditVC") as! AddAndEditVC
        vc.contactId = contactId
        
        //add closure call

        vc.completionHandler = { object, isEdit in
            
            CoreDBhelper.shared.saveCategoryDataToCoreDB(contactListArray: [object])
            self.refreshContactListCall()
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}


//MARK : - Table View Delegate and Data source
extension ContactListVC :UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts[section].contactList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListTableCell") as! ContactListTableCell
                
        
        if  contacts[indexPath.section].contactList[indexPath.row].name.isEmpty{
            cell.contactNameLabel.text = contacts[indexPath.section].contactList[indexPath.row].contact
        }
        else{
            cell.contactNameLabel.text = contacts[indexPath.section].contactList[indexPath.row].name
        }
        
        cell.contactImageView.image = contacts[indexPath.section].contactList[indexPath.row].image.uiImage
        cell.contactImageView.setRadius()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AddAndEditVC") as! AddAndEditVC
        vc.isEdit = true
        
        //update closure call
        vc.completionHandler = { object, isEdit in
            
            CoreDBhelper.shared.updateDataFromDb(listName: "ContactList", conntactData: object)
            self.searchController.isActive = false
            self.refreshContactListCall()
        }
        
        vc.contactData = contacts[indexPath.section].contactList[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel()
        label.frame = CGRect.init(x: 25, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.font =  .boldSystemFont(ofSize: 18)
        label.text = contacts[section].alphaBateType
        headerView.addSubview(label)
        headerView.backgroundColor = .lightGray
        return headerView
    }
    
}



//MARK : - search controller delegate
extension ContactListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
                
        if searchController.isActive {
            
            if !(searchController.searchBar.text?.isEmpty ?? true) {
                let resultArray =   contactLisSavedtArray.filter({ $0.name.range(of: searchController.searchBar.text!, options: .caseInsensitive) != nil})
                contactLisSearchedtArray = resultArray
                self.getSortedContact(contactArray: resultArray)
            }
            else{
                refreshContactListCall()
            }
        }
        
    }
    
}


