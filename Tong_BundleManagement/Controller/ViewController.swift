//
//  ViewController.swift
//  Tong_BundleManagement
//
//  Created by Tong Yi on 5/17/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var fileNameTF: UITextField!
    @IBOutlet var fileTypeTF: UITextField!
    @IBOutlet var typeTableView: UITableView!
    @IBOutlet var nameTableView: UITableView!
    @IBOutlet var contentTV: UITextView!
    
    let bundle = Bundle.main
    let name = ["Note", "sample_explain"]
    let type = ["txt", "pdf"]

    //MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dropDownSetup()
    }
    
    //MARK: - UI setup
    func setupUI()
    {
        fileTypeTF.delegate = self
        fileNameTF.delegate = self
        contentTV.delegate = self
    }
    
    // MARK: - Button Method
    
    @IBAction func openLocalFileButtonTapped(_ sender: Any)
    {
        if let fileName = fileNameTF.text, let fileType = fileTypeTF.text, !fileName.isEmpty, !fileType.isEmpty
        {
            if fileType == "txt"
            {
                if let bundleFileURL = self.bundle.url(forResource: fileName, withExtension: fileType)
                {
                    self.readFile(bundleFileURL)
                }
                else
                {
                    self.alert("Warning!", "There is no file called \"Note.txt\" through the type property Bundle.main!")
                }
            }
            else
            {
                readPdf()
            }
        }
        else
        {
            alert("WARNING!", "Please enter the file name and type!")
        }
    }
    
    //MARK: - Read File
    func readFile(_ fileURL: URL)
    {
        var readData = ""
        do
        {
            readData = try String(contentsOf: fileURL)
        }
        catch
        {
            alert("WARNING!", "Failed to read!")
        }
        
        if !readData.isEmpty
        {
            contentTV.text = readData
        }
        else
        {
            alert("WARNING!", "This is an empty file!")
        }
    }
    
    func readPdf()
    {
        if let path =  Bundle.main.path(forResource: "sample_explain", ofType: ".pdf")
        {
            let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            dc.delegate = self
            dc.presentPreview(animated: true)
        }
    }
    
    // MARK: - Alert Method
    
    func alert(_ titleToShow: String, _ messageToShow: String)
    {
        let alertController = UIAlertController(title: titleToShow, message: messageToShow, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        {
            (action) -> Void in
            NSLog ("OK Pressed.")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - text view and text field delegation => return hide the keyboard
extension ViewController: UITextFieldDelegate, UITextViewDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == fileNameTF
        {
            nameTableView.isHidden = false
        }
        else
        {
            typeTableView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == fileNameTF
        {
            nameTableView.isHidden = true
        }
        else
        {
            typeTableView.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - Document Interaction Controller Delegate

extension ViewController: UIDocumentInteractionControllerDelegate
{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

// MARK: - Drop Down Menu

extension ViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate
{
    func dropDownSetup()
    {
        nameTableView.isHidden = true
        typeTableView.isHidden = true
        nameTableView.delegate = self
        typeTableView.delegate = self
        nameTableView.dataSource = self
        typeTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == nameTableView
        {
            return name.count
        }
        else
        {
            return type.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == nameTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
            cell.textLabel?.text = name[indexPath.row]
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath)
            cell.textLabel?.text = type[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == nameTableView
        {
            fileNameTF.text = name[indexPath.row]
        }
        else
        {
            fileTypeTF.text = type[indexPath.row]
        }
        
        tableView.isHidden = true
    }
}

