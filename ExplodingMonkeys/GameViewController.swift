//
//  GameViewController.swift
//  ExplodingMonkeys
//
//  Created by Paul Richardson on 19/06/2021.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

	var currentGame: GameScene!

	@IBOutlet var angleSlider: UISlider!
	@IBOutlet var angleLabel: UILabel!
	@IBOutlet var velocitySlider: UISlider!
	@IBOutlet var velocityLabel: UILabel!
	@IBOutlet var launchButton: UIButton!
	@IBOutlet var playerLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			if let scene = SKScene(fileNamed: "GameScene") {
				// Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFill

				// Present the scene
				view.presentScene(scene)
				currentGame = scene as? GameScene
				currentGame.viewController = self
			}

			view.ignoresSiblingOrder = true

			view.showsFPS = true
			view.showsNodeCount = true
		}
	}

	override var shouldAutorotate: Bool {
		return true
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .allButUpsideDown
		} else {
			return .all
		}
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	@IBAction func angleChanged(_ sender: Any) {
	}

	@IBAction func velocityChanged(_ sender: Any) {
	}

	@IBAction func launch(_ sender: Any) {
	}
	
}
