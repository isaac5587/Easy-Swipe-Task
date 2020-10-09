//
//  AddTodoViewController.swift
//  Fast Task
//
//  Created by Trill Isaac on 7/5/19.
//  Copyright © 2019 Isaac Ansumana. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    // MARK: - Outlets
    
    //storyboard objects
    @IBOutlet weak var textVIew: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        textVIew.becomeFirstResponder()
        
        if let todo = todo {
            textVIew.text = todo.title
            textVIew.text = todo.title
            segmentedControl.selectedSegmentIndex = Int(todo.priority)
        }
    }
    
    // MARK: - Actions
    
    // sets keyboard contraints
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key]as? NSValue else {return}
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottomConstraint.constant = keyboardHeight 
        
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
        
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textVIew.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismissAndResign()
    }
    
    
    // done button function
    @IBAction func done(_ sender: UIButton) {
        guard let title = textVIew.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo {
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
        }else{
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        do {
            try managedContext.save()
            dismissAndResign()
            textVIew.resignFirstResponder()
        }catch {
            print("Error saving todo: \(error)")
        }
    }
    
}

// whenever the text view is used
extension AddTodoViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden{
            //textView.text.removeAll()
            textView.textColor = .white
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
