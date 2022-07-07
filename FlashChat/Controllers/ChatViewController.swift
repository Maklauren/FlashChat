//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Павел Черноок on 4.07.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import IQKeyboardManager

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    private var messages: [Message] = []
    
    private var database = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Key.appName
        
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: Key.cellNibName, bundle: nil), forCellReuseIdentifier: Key.cellIdentifier)
        
        loadMessages()
    }
    
    private func loadMessages() {
        database.collection(Key.FStore.collectionName).order(by: Key.FStore.dateField).addSnapshotListener { querySnapshot, error in
            self.messages = []
            
            if let error = error {
                print("There was an issue retrieving data from Firebase. \(error)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        
                        if let messageSender = data[Key.FStore.senderField] as? String, let messageBody = data[Key.FStore.bodyField] as? String {
                            let message = Message(sender: messageSender, body: messageBody)
                            
                            self.messages.append(message)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageSender = Auth.auth().currentUser?.email, let messageBody = messageTextField.text {
            database.collection(Key.FStore.collectionName).addDocument(data: [
                Key.FStore.senderField : messageSender,
                Key.FStore.bodyField : messageBody,
                Key.FStore.dateField : Date().timeIntervalSince1970
            ]) { error in
                if let error = error {
                    print("There was an issue saving data to firestore, \(error)")
                } else {
                    self.messageTextField.text = ""
                }
            }
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
