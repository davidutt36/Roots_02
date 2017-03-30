//
//  LauncherViewController.swift
//  Roots_02
//
//  Created by David Utt on 3/24/17.
//  Copyright © 2017 David Utt. All rights reserved.
//

import UIKit

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
