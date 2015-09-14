//
//  MoviesViewController.swift
//  Rotten
//
//  Created by John Franklin on 9/11/15.
//  Copyright © 2015 JF. All rights reserved.
//

import UIKit
import AFNetworking
import JGProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var progressHUD : JGProgressHUD = JGProgressHUD()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressHUD.textLabel.text = "Loading..."
        progressHUD.showInView(self.view)
        
        
        let urlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error != nil) {
                self.progressHUD.dismiss()
                var refreshAlert = UIAlertView()
                refreshAlert.title = "Rotten Dead?"
                refreshAlert.message = "Network error, cannot connect to rotten server."
                refreshAlert.addButtonWithTitle("OK")
                refreshAlert.show()
            } else {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                self.movies = json["movies"] as? [NSDictionary]
                self.tableView.reloadData()
                self.progressHUD.dismiss()
            }

            //NSLog("response: \(self.photos)")
        }
        
        // config swiftLoader
        
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    func refresh(sender:AnyObject)
    {
        progressHUD.textLabel.text = "Loading..."
        progressHUD.showInView(self.view)
        
        
        let urlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error != nil) {
                self.progressHUD.dismiss()
                self.movies?.removeAll()
                self.tableView.reloadData()
                let refreshAlert = UIAlertView()
                refreshAlert.title = "Rotten Dead?"
                refreshAlert.message = "Network error, cannot connect to rotten server."
                refreshAlert.addButtonWithTitle("OK")
                refreshAlert.show()
            } else {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                self.movies = json["movies"] as? [NSDictionary]
                self.tableView.reloadData()
                self.progressHUD.dismiss()
            }
            self.refreshControl?.endRefreshing()
            
            //NSLog("response: \(self.photos)")
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        movieDetailsViewController.navigationItem.title = movie["title"] as! String
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        progressHUD.showInView(self.view)
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieTableViewCell
        let movie = movies![indexPath.row] as NSDictionary
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        let movieUrl = movie.valueForKeyPath("posters.thumbnail") as! String
        let hiResMovieUrl = movieUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        let url = NSURL(string: hiResMovieUrl)!

        //cell.posterView.setImageWithURL(url)
        print (hiResMovieUrl)
        let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if error == nil {
                let image = UIImage (data: data!)
                cell.posterView.image = image
            }
            self.progressHUD.dismiss()
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("Hello World!")
    }


}
