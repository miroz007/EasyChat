//
//  ChatRoomsVC.swift
//  EasyChat
//
//  Created by Amir on 1/16/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomsVC: UIViewController {
    
    @IBOutlet weak var roomTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        observeRooms()
    }
    
    
    func observeRooms() {
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String:Any] {
                if let roomName =  dataArray["roomName"] as? String {
                    let room = Room.init(roomID: snapshot.key, roomName: roomName)
                    self.rooms.append(room)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            try! Auth.auth().signOut()
        }
//        ad.window!.rootViewController = LoginVC()
//        ad.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func createRoomPressed(_ sender: UIButton) {
        guard let roomName = roomTF.text , !roomName.isEmpty else {return}
        
        let databaseRef = Database.database().reference()
        let room = databaseRef.child("rooms").childByAutoId()
        let dataArray: [String : Any] = ["roomName":roomName]
        
        room.setValue(dataArray) { (error, ref) in
            if error != nil {
                print("\(error?.localizedDescription)")
                return
            }
            self.roomTF.text = ""
        }
    }
    
    
}


extension ChatRoomsVC: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.textLabel?.text = room.roomName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = self.rooms[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.room = selectedRoom
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
