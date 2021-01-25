//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Hanna Putiprawan on 1/24/21.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
        Message(sender: "abc@email.com", body: "Hey!"),
        Message(sender: "def@email.com", body: "Hello!"),
        Message(sender: "ghi@email.com", body: "What's up!")
    ]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil),
                           forCellReuseIdentifier: K.cellIdentifier) // Register the custom view
        loadMessages()
    }
    
    func loadMessages() {
        messages = []
        db.collection(K.FStore.collectionName).getDocuments { [self] (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore \(e).")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            // Trying to update tableView inside the closure, working in the background
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        // if we have current user, we get the email
        if let messageSender = Auth.auth().currentUser?.email,
           let messageBody = messageTextfield.text {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody]) { (error) in
                if let e = error {
                    print("There is an issue with saving data to firestore, \(e).")
                } else {
                    print("Successfully saved the data.")
                }
                
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

// MARK: - UITableViewDataSource
// DataSource is the protocol that's responsible for populating the tableView; how many cell does it needs, and what's in the cell
extension ChatViewController: UITableViewDataSource {
    
    // How many rows do we want to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // What inside each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
}

// We DON'T need the Delegate for the messaging app, since we don't want user to interact with each cell
//// MARK: - UITableViewDelegate
//// When tableView is interacted with the user
//extension ChatViewController: UITableViewDelegate {
//
//    // When a particular row in the tableView is selected
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}
