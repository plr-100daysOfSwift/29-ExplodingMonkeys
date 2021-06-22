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
	var player1 = Player(id: 1)
	var player2 = Player(id: 2)

	@IBOutlet var angleSlider: UISlider!
	@IBOutlet var angleLabel: UILabel!
	@IBOutlet var velocitySlider: UISlider!
	@IBOutlet var velocityLabel: UILabel!
	@IBOutlet var launchButton: UIButton!
	@IBOutlet var playerLabel: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	@IBOutlet var windLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		scoreLabel.text = "Score: \(player1.score):\(player2.score)"

		setSliders()

		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			if let scene = SKScene(fileNamed: "GameScene") {
				currentGame = scene as? GameScene
				currentGame.viewController = self
				currentGame.currentPlayer = player1

				// Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFill

				// Present the scene
				view.presentScene(scene)
				setWindLabel()
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
		angleLabel.text = "Angle: \(Int(angleSlider.value))°"
	}

	@IBAction func velocityChanged(_ sender: Any) {
		velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
	}

	@IBAction func launch(_ sender: Any) {
		angleSlider.isHidden = true
		angleLabel.isHidden = true
		velocitySlider.isHidden = true
		velocityLabel.isHidden = true
		launchButton.isHidden = true
		windLabel.isHidden = true

		currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
	}

	func activatePlayer(player: Player) {
		switch player.id {
		case 1:
			playerLabel.text = "<<< PLAYER ONE"
		case 2:
				playerLabel.text = "PLAYER TWO >>>"
		default: break
		}
		angleSlider.isHidden = false
		angleLabel.isHidden = false
		velocitySlider.isHidden = false
		velocityLabel.isHidden = false
		launchButton.isHidden = false
		windLabel.isHidden = false
		scoreLabel.text = "Score: \(player1.score):\(player2.score)"
	}

	func isWinner(_ playerId: Int) -> Bool {
		if playerId == player1.id {
			player1.increment()
			scoreLabel.text = "Score: \(player1.score):\(player2.score)"
			if player1.isWinner {
				playerLabel.text = "PLAYER ONE WINS!"
				return true
			}
		} else {
			player2.increment()
			scoreLabel.text = "Score: \(player1.score):\(player2.score)"
			if player2.isWinner {
				playerLabel.text = "PLAYER TWO WINS!"
				return true
			}
		}

		return false
	}

	func setWindLabel() {
		if let windFactor = currentGame.windFactor {

			switch windFactor {
			case _ where windFactor < 0:
				windLabel.text = "Wind: \(abs(windFactor) * 10) knots easterly"
			case _ where windFactor > 0:
				windLabel.text = "Wind: \(abs(windFactor) * 10) knots westerly"
			default:
				windLabel.text = "No wind"
			}
		}
	}

	func setSliders() {
		angleSlider.value = 45
		velocitySlider.value = 125
		angleChanged(self)
		velocityChanged(self)
	}

	func saveSettings(player: Player) {
		player.lastUsedAngle = angleSlider.value
		player.lastUsedVelocity = velocitySlider.value
	}

}
