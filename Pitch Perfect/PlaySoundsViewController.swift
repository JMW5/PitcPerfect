//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jacquin Wynn Jr on 3/9/15.
//  Copyright (c) 2015 JMW. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    
    var receivedAudio:RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creates instance of Audio Player
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowButtonTapped(sender: UIButton) {
        setSessionPlayAndRecord()
        self.audioPlayer.stop()
        self.audioPlayer.rate = 0.5
        self.audioPlayer!.play()
        
        self.audioEngine.reset()
        self.audioEngine.stop()
        
    }
    
    @IBAction func fastButtonTapped(sender: UIButton) {
        setSessionPlayAndRecord()
        self.audioPlayer.stop()
        self.audioPlayer.rate = 1.5
        self.audioPlayer!.play()
        
        self.audioEngine.reset()
        self.audioEngine.stop()
    }
    

    @IBAction func stopButton(sender: AnyObject) {
        self.audioPlayer.stop()
        
        self.audioEngine.stop()
        self.audioEngine.reset()
    }
    
    
    
    @IBAction func chipButtonTapped(sender: UIButton) {
        setSessionPlayAndRecord()
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darkVardarTapped(sender: UIButton) {
        setSessionPlayAndRecord()
        playAudioWithVariablePitch(-1000)
    }
    
    func setSessionPlayAndRecord() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error:NSError?
        
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error) {
            println("could not set output to speaker")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        
        
        
        
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }

}
