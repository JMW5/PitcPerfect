//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jacquin Wynn Jr on 3/8/15.
//  Copyright (c) 2015 JMW. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var stopButtonLabel: UIButton!
    @IBOutlet weak var recordButtonLabel: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Anything is possible....
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.stopButtonLabel.hidden = true
        
        //Hides the label
        self.recordingLabel.text = "Tap to Record"
        self.recordingLabel.hidden = false
    }


    @IBAction func recordAudioTapped(sender: UIButton) {
        //Todo: Show text "Audio is recording"
        self.recordingLabel.text = "Recording.."
        self.recordButtonLabel.enabled = false
        self.recordingLabel.hidden = false
        self.stopButtonLabel.hidden = false
        //Todo: Record user's voice & getting to the docments to save too
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        println("recording audio")
        }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            //Save recorded audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
           
            //Perform a segue to next screen
            self.performSegueWithIdentifier("performSeg", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButtonLabel.enabled = true
            stopButtonLabel.hidden = true
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "performSeg" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        println("stopping audio")
        self.recordingLabel.hidden = true
        
        self.recordButtonLabel.enabled = true
        self.stopButtonLabel.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    }


