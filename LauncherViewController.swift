//
//  LauncherViewController.swift
//  Roots_02
//
//  Created by David Utt on 3/24/17.
//  Copyright © 2017 David Utt. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class LauncherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func launchCamera(_ sender: UIButton) {
        let NavVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.present(NavVC, animated: true, completion: {
        })
    }
    
    @IBAction func launchGallery(_ sender: UIButton) {
        let GalVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "GalleryVC") as! UINavigationController
        self.present(GalVC, animated: true, completion: {
        })
    }
    
    @IBAction func Notify(_ sender: UIButton) {
        //allow notification access message and confirmation
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler:{
            didAllow, error in
        })
        createNotifications()
    }
    
    
    func createNotifications() {
       //TEST
        let content = UNMutableNotificationContent()
            //display text
            content.title = "Refining your Roots"
            content.subtitle = "\(timerArray.count) Taken today"
            content.body = "What Photos Made Your Day?"
        
        
            //attachemtns
//            let attachment = try UNNotificationAttachment(identifier: "RootsArrary.last", url: RootsArrary, options: nil)
//            content.attachments = [attachment]
        
            //display Icon badge
            content.badge = 0
        
        //erase or keep the rest
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer Done", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
//        Broken - attempt to conncect to Gallery image path
//        if let path = Bundle.main.path(forResource: "note", ofType: "JPG"){
//            let url = URL(fileURLWithPath: path)
//            
//            do {
//                let attachment = try UNNotificationAttachment(identifier: "note", url: url, options: nil)
//                content.attachments = [attachment]
//            } catch {
//                print("The attachment was not loaded.")
//            }
//        }
    }
    
    func dismissNotifcations(){
    UIApplication.shared.applicationIconBadgeNumber = 0
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//References
    //Notifications
        //http://www.appcoda.com/ios10-user-notifications-guide/
    //Notification interactions
        //https://www.youtube.com/watch?v=6RzQ2bptqGM
        //http://www.appcoda.com/ios10-user-notifications-guide/
