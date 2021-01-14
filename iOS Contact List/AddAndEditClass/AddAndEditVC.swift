//
//  AddAndEditVC.swift
//  iOS Contact List
//
//  Created by Purushottam on 12/01/21.
//  Copyright © 2021 Purushottam. All rights reserved.
//

import UIKit

class AddAndEditVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editButtonOutlet: UIButton!
    
    @IBOutlet weak var cancelButttonoutlet: UIButton!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    let picker = UIImagePickerController()
    
    var contactData : ContactData?
    var isEdit  = Bool()
    var contactId  = Int()
    
    var completionHandler:((ContactData,Bool) -> ())?
    let textViewString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    //MaRK : - common initialization
    private func commonInit(){
        
        picker.delegate = self
        contactImageView.setRadius()
        
        saveBtnOutlet.cornerRadiusOfView()
        contactImageView.borderOfView()
        editButtonOutlet.isHidden = true
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        mobileTextField.delegate = self
        
        if isEdit{
            nameTextField.text = contactData?.name
            emailTextField.text = contactData?.email
            mobileTextField.text = contactData?.contact
            editButtonOutlet.isHidden = false
            contactImageView.image = contactData?.image.uiImage
            addButtonOutlet.setAttributedTitle(textViewString, for: .normal)
            isEditabletextFieldCall(nameTxtField: false, emailTxtField: false, mobileTxtField: false, imagebtn: false)
            
        }
        
        //validate all text field
        validate()
        
    }
    
    
    //MARK : - to check texfield should be editable or not
    
    private func isEditabletextFieldCall(nameTxtField:Bool,emailTxtField:Bool,mobileTxtField:Bool,imagebtn:Bool){
        nameTextField.isUserInteractionEnabled = nameTxtField
        emailTextField.isUserInteractionEnabled = emailTxtField
        mobileTextField.isUserInteractionEnabled = mobileTxtField
        addButtonOutlet.isUserInteractionEnabled = imagebtn
        
    }
    
    
    
    @IBAction func onClickCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickEditBtn(_ sender: Any) {
        
        editButtonOutlet.isSelected = !editButtonOutlet.isSelected
        
        if editButtonOutlet.isSelected{
            isEditabletextFieldCall(nameTxtField: true, emailTxtField: true, mobileTxtField: true, imagebtn: true)
            nameTextField.becomeFirstResponder()
        }
        else{
            isEditabletextFieldCall(nameTxtField: false, emailTxtField: false, mobileTxtField: false, imagebtn: false)
        }
        
        
    }
    
    
    
    @IBAction func onClickSaveBtn(_ sender: Any) {
        
        if isEdit{
            let object = ContactData(image: (contactImageView.image?.pngData())!, name: nameTextField.text!.capitalizingFirstLetter(), contact: mobileTextField.text!, email: emailTextField.text!, contactId: contactData!.contactId)
            self.completionHandler?(object, true)
            self.dismiss(animated: true, completion: nil)
            return
        }
        var imageData = Data()
        if contactImageView.image == nil{
            imageData = (UIImage(named:"avatar")?.pngData())!
        }
        else{
            imageData = (contactImageView.image?.pngData())!
        }
        
        let object = ContactData(image: imageData, name: nameTextField.text!.capitalizingFirstLetter(), contact: mobileTextField.text!, email: emailTextField.text!, contactId: "\(contactId)")
        self.completionHandler?(object, false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickopenCameraBtn(_ sender: Any) {
        
        let alertContrlr = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertContrlr.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {(UIAlertAction) ->Void in
            self.openCamera()
        }))
        alertContrlr.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {(UIAlertAction) ->Void in
            self.openGallery()
        }))
        alertContrlr.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertContrlr, animated: true, completion: nil)
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.validate()
        
    }
    
    
    // keyboard resign
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    // validate  all tetfield function
    func validate() {
        let nameTextFld = self.nameTextField?.text ?? ""
        let emailTextFld = self.emailTextField?.text ?? ""
        let mobiletextFld = self.mobileTextField?.text ?? ""
        
        if nameTextFld.isEmpty && emailTextFld.isEmpty && mobiletextFld.isEmpty {
            saveBtnOutlet.isEnabled = false
            saveBtnOutlet.backgroundColor = .lightGray
        } else {
            saveBtnOutlet.isEnabled = true
            saveBtnOutlet.backgroundColor = .systemBlue
            
        }
    }
    
    
}

//MARK : picker delegate
extension AddAndEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            contactImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //open camera
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
            
        } else {
        }
    }
    //open gallery
    func openGallery(){
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
}








