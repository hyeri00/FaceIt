//
//  EmotionsViewController.swift
//  Test
//
//  Created by 혜리 on 2022/02/08.
//

import UIKit

class EmotionsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievous" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationvc = segue.destination
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    facevc.expression = expression
                }
            }
        }
    }
}
