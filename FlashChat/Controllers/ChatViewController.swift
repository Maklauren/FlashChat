//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Павел Черноок on 4.07.22.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Key.appName
        
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Key.cellNibName, bundle: nil), forCellReuseIdentifier: Key.cellIdentifier)
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Key.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        return cell
    }
}
