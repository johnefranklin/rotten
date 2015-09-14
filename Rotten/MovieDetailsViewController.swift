//
//  MovieDetailsViewController.swift
//  Rotten
//
//  Created by John Franklin on 9/12/15.
//  Copyright © 2015 JF. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var synopsisView: UILabel!
    
    var movie : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.text = movie["title"] as? String
        synopsisView.text = movie["synopsis"] as? String
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        imageView.setImageWithURL(url)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
