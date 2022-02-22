//
//  FaceViewController.swift
//  Test
//
//  Created by Wanya on 2022/01/22.
//

import UIKit

class FaceViewController: UIViewController {
    // MARK : Model
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smirk) {
        didSet {
            updateUI() // 모델이 변경되었으므로 보기를 업데이트 한다.
        }
    }
    
    // MARK : View
    @IBOutlet weak var faceView: FaceView! { // 옵셔널 FaceView로 선언되어 있다.
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(
                target: self, action: #selector(FaceViewController.changeBrows(recognizer:))
            ))
            
            updateUI()
        }
    }
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0,
                                   .Grin: 0.5,
                                   .Smile: 1.0,
                                   .Smirk: -0.5,
                                   .Neutral:0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5,
                                .Furrowed: -0.5,
                                .Normal: 0.0]
    
    private struct Animation {
        static var ShakeAngle = CGFloat(Double.pi/6)
        static let ShakeDuration = 0.4
    }
    
    @objc func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    @objc func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    @objc func changeBrows(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended :
            if recognizer.rotation > CGFloat(Double.pi/4) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0.0
            } else if recognizer.rotation < -CGFloat(Double.pi/4) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0.0
            }
        default:
            break
        }
    }
    
    
}
