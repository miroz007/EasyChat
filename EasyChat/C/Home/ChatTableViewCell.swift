//
//  ChatTableViewCell.swift
//  EasyChat
//
//  Created by Amir on 1/16/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    enum bubbleType {
        case incoming
        case outgoing
    }

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var messageBody: UITextView!
    @IBOutlet weak var messageStack: UIStackView!
    @IBOutlet weak var messageContainer: UIView!
    
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setMessageData(message:Message) {
        name.text = message.senderName
        messageBody.text = message.messageText
    }

    
    func setBubbleType(type: bubbleType){
        if type == .incoming {
            messageStack.alignment = .leading
            messageContainer.backgroundColor = #colorLiteral(red: 0.2120903989, green: 0.4938185976, blue: 0.8041178584, alpha: 1)
            messageBody.textColor = .white
        } else {
            messageStack.alignment = .trailing
            messageContainer.backgroundColor = .lightGray
            messageBody.textColor = .black
        }
    }
        
        
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
