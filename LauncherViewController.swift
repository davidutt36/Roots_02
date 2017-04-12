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
        
        //erase or keep the rest
        
            //display Icon badge
            content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer Done", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func dismissNotifcations(){
    UIApplication.shared.applicationIconBadgeNumber = 0
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
