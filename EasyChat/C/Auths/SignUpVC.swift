//
//  SignUpVC.swift
//  EasyChat
//
//  Created by Amir on 1/14/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet var videoView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var goToLogin: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
    }
    
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "Intro", ofType: "mp4") else {return}
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoView.layer.addSublayer(playerLayer)
        
        player.play()
        
        videoView.bringSubviewToFront(emailTF)
        videoView.bringSubviewToFront(passTF)
        videoView.bringSubviewToFront(img)
        videoView.bringSubviewToFront(signUp)
        videoView.bringSubviewToFront(goToLogin)
        videoView.bringSubviewToFront(nameTF)
        videoView.bringSubviewToFront(stack)
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        guard let email = emailTF.text else {return}
        guard let pass = passTF.text else {return}
        guard let name = nameTF.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                return
            }
            guard let userID = result?.user.uid else {return}
            let reference = Database.database().reference()
            let user = reference.child("users").child(userID)
            let dataArray:[String : Any] = ["username" : name]
            
            user.setValue(dataArray)
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NavBar")
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
