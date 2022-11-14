//
//  AddCommentsViewController.swift
//  Project33
//
//  Created by Grant Watson on 11/9/22.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate {
    var genre: String!
    
    var comments: UITextView!
    let placeholder = "Enter any additional comments here that might help identify the tune."

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))
        comments.text = placeholder
    }
    
    @objc func submitTapped() {
        let vc = SubmitViewController()
        vc.genre = genre
        
        if comments.text == placeholder {
            vc.comments = "No comments"
        } else {
            vc.comments = comments.text
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        comments = UITextView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFont(forTextStyle: .body)
        view.addSubview(comments)
        
        NSLayoutConstraint.activate([
            comments.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comments.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comments.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            comments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


}
