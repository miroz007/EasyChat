//
//  LoginVC.swift
//  EasyChat
//
//  Created by Amir on 1/14/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet var videoView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var goToSignup: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        ad.goToHomeVC()
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
        videoView.bringSubviewToFront(login)
        videoView.bringSubviewToFront(goToSignup)
        videoView.bringSubviewToFront(stack)
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailTF.text else {return}
        guard let pass = passTF.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                return
            }
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NavBar")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func goToSignUp(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC")
        self.present(vc, animated: true, completion: nil)
    }
    
}
