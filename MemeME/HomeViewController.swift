//
//  HomeViewController.swift
//  MemeME
//
//  Created by Leonardo Bilia on 1/14/19.
//  Copyright © 2019 Leonardo Bilia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var topCaptionTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "Top Caption",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = UIColor.white
        textfield.delegate = self
        textfield.tag = 0
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var bottomCaptionTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "Bottom Caption",attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textfield.font = UIFont.systemFont(ofSize: 16)
        textfield.textColor = UIColor.white
        textfield.delegate = self
        textfield.tag = 1
        textfield.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var memeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.appBaseLight
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var topCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.black)
        label.dropShadow()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.black)
        label.dropShadow()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: views
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtonItens()
        layoutHandler()
        keyboardHandler()
    }
    
    override func viewDidLayoutSubviews() {
        topCaptionTextField.setBottomBorder()
        bottomCaptionTextField.setBottomBorder()
    }
    
    //MARK: actions
    @objc fileprivate func cameraHandler() {
        let alertController = UIAlertController()
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.pickerHandler(.photoLibrary)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pickerHandler(.camera)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            alertController.modalPresentationStyle = .popover
            self.present(alertController, animated: true, completion: nil)
            alertController.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        }
    }
    
    @objc fileprivate func shareHandler() {
        let image = takeScreenshot(view: memeImageView)
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activity.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.resetHandler()
            }
        }
        DispatchQueue.main.async {
            activity.modalPresentationStyle = .popover
            self.present(activity, animated: true, completion: nil)
            activity.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        if textField.tag == 0 {
            topCaptionLabel.text = textField.text
        } else {
            bottomCaptionLabel.text = textField.text
        }
    }
    
    @objc func returnKeyboard() {
        topCaptionTextField.resignFirstResponder()
        bottomCaptionTextField.resignFirstResponder()
    }
    
    //MARK: functions
    fileprivate func takeScreenshot(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(memeImageView.bounds.size, true, 0)
        memeImageView.drawHierarchy(in: memeImageView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    fileprivate func pickerHandler(_ sourceType: UIImagePickerController.SourceType) {
        self.returnKeyboard()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        
        DispatchQueue.main.async {
            picker.modalPresentationStyle = .popover
            self.present(picker, animated: true, completion: nil)
            picker.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
        }
    }
    
    fileprivate func resetHandler() {
        topCaptionTextField.text = nil
        bottomCaptionTextField.text = nil
        memeImageView.image = nil
        topCaptionLabel.text = nil
        bottomCaptionLabel.text = nil
    }
    
    fileprivate func keyboardHandler() {
        let tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(returnKeyboard))
        self.view.addGestureRecognizer(tapViewGesture)
    }
    
    fileprivate func setupNavBarButtonItens() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_camera"), style: .plain, target: self, action: #selector(cameraHandler))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_share"), style: .plain, target: self, action: #selector(shareHandler))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    fileprivate func layoutHandler() {
        navigationItem.title = "MemeME"
        view.backgroundColor = UIColor.appBaseDark
        
        view.addSubview(topCaptionTextField)
        topCaptionTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        topCaptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topCaptionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        view.addSubview(bottomCaptionTextField)
        bottomCaptionTextField.topAnchor.constraint(equalTo: topCaptionTextField.bottomAnchor, constant: 48).isActive = true
        bottomCaptionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomCaptionTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        view.addSubview(memeImageView)
        memeImageView.topAnchor.constraint(equalTo: bottomCaptionTextField.bottomAnchor, constant: 48).isActive = true
        memeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memeImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        memeImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        memeImageView.addSubview(topCaptionLabel)
        topCaptionLabel.topAnchor.constraint(equalTo: memeImageView.topAnchor, constant: 16).isActive = true
        topCaptionLabel.leadingAnchor.constraint(equalTo: memeImageView.leadingAnchor, constant: 16).isActive = true
        topCaptionLabel.trailingAnchor.constraint(equalTo: memeImageView.trailingAnchor, constant: -16).isActive = true
        
        memeImageView.addSubview(bottomCaptionLabel)
        bottomCaptionLabel.leadingAnchor.constraint(equalTo: memeImageView.leadingAnchor, constant: 16).isActive = true
        bottomCaptionLabel.trailingAnchor.constraint(equalTo: memeImageView.trailingAnchor, constant: -16).isActive = true
        bottomCaptionLabel.bottomAnchor.constraint(equalTo: memeImageView.bottomAnchor, constant: -16).isActive = true
    }
}


//MARK: text field delegate
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



//MARK: image picker
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        memeImageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
