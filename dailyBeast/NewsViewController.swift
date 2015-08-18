//
//  NewsViewController.swift
//  dailyBeast
//
//  Created by Jae Hoon Lee on 8/18/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//


import UIKit
import AVFoundation

class NewsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    var url = ""
    var headline = ""
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBAction func readButtonPressed(sender: UIButton) {
        let utterance = AVSpeechUtterance(string: contentLabel.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        synthesizer.speakUtterance(utterance)

    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        print("hello")
        print(url)
        headlineLabel.text = headline
        if let urlToReq = NSURL(string: "http://localhost:4567\(url)") {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfStory = parseJSON(data)
                contentLabel.text = arrOfStory![0] as? String
            }
        }
    }
    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
            return arrOfObjects as? NSArray
        } catch {
            return nil
        }
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: characterRange)
        contentLabel.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        contentLabel.attributedText = NSAttributedString(string: utterance.speechString)
    }
}