//
//  ChatVC.swift
//  EasyChat
//
//  Created by Amir on 1/16/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {
    
    @IBOutlet weak var chatTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var room:Room?
    var chatMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        title = room?.roomName
        observMessages()
    }
    
    func observMessages() {
        guard let roomID = self.room?.roomID else {return}
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").child(roomID).child("messages").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String:Any] {
                guard let senderName = dataArray["senderName"] as? String , let messageText = dataArray["text"] as? String , let senderID = dataArray["senderID"] as? String
                    else {return}
                let message = Message.init(messageKey: snapshot.key, senderName: senderName, messageText: messageText,senderID: senderID)
                self.chatMessages.append(message)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func getUserNameWithID(id:String , completion: @escaping (_ userName: String?) -> ()){
        let databaseRef = Database.database().reference()
        let user = databaseRef.child("users").child(id)
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let userName = snapshot.value as? String {
                completion(userName)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func sendMessage(text: String , completion: @escaping (_ isSuccess: Bool) -> ()){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let databaseRef = Database.database().reference()
        
        getUserNameWithID(id: userID) { (userName) in
            if let userName = userName {
                if let roomId = self.room?.roomID , let senderID = Auth.auth().currentUser?.uid {
                    let dataArray : [String:Any] = ["senderName": userName , "text": text , "senderID": senderID]
                    let room = databaseRef.child("rooms").child(roomId)
                    
                    room.child("messages").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, referance) in
                        if error != nil {
                            print("\(error?.localizedDescription)")
                            completion(false)
                            return
                        }
                        completion(true)
                        self.chatTF.text = ""
                    })
                }
            }
        }
        
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard  let chat = chatTF.text , !chat.isEmpty else {return}
        sendMessage(text: chat, completion: { (isSuccess) in
            if isSuccess {
                self.chatTF.text = ""
            }
        })
    }
    
    
}


extension ChatVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.chatMessages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatTableViewCell
        cell.setMessageData(message: message)
        if(message.senderID == Auth.auth().currentUser!.uid) {
            cell.setBubbleType(type: .outgoing)
        }else {
            cell.setBubbleType(type: .incoming)
        }
        return cell
    }
    
    
}
