//
//  ViewController.swift
//
//  Created by Carmen Probst on 02.02.18.
//  Copyright © 2018 Carmen Probst. All rights reserved.
//

import UIKit
import AI
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var responseTextLabel: UILabel!

    let speechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        responseTextLabel.text = ""
    }

    @IBAction func sendButtonPressed() {
        guard let text = textField.text else { return }
        sendToAgent(text)
    }

    func sendToAgent(_ text: String) {
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            self.greetingLabel.isHidden = true
            self.responseTextLabel.text = ""
            self.textField.text = nil
        }, completion: nil)

        AI.sharedService.textRequest(text).success { [weak self] response in

            guard let responseText = response.result.fulfillment?.speech else { return }
            DispatchQueue.main.async { [weak self] in
                self?.presentResponse(text: responseText)
            }
        }.failure { error in
            DispatchQueue.main.async { [weak self] in
                self?.presentResponse(text: "⚠️ \(error.localizedDescription)")
            }
        }
    }

    func presentResponse(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en")
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseInOut, animations: {
            self.responseTextLabel.text = text
        }, completion: nil)
    }

}

