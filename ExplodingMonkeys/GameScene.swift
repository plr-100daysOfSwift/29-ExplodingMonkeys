//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by Paul Richardson on 19/06/2021.
//

import SpriteKit

enum CollisionTypes: UInt32 {
	case banana = 1
	case building = 2
	case player1 = 4
	case player2 = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {

	weak var viewController: GameViewController!
	var buildings = [BuildingNode]()

	var player1: SKSpriteNode!
	var player2: SKSpriteNode!
	var banana: SKSpriteNode!

	var currentPlayer: Player!
	var windFactor: Int!

	override func didMove(to view: SKView) {
		physicsWorld.contactDelegate = self
		windFactor = Int.random(in: -4 ... 4)
		physicsWorld.gravity.dx = CGFloat(windFactor)
		backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
		createBuildings()
		createPlayers()
	}

	func createBuildings() {
		var currentX: CGFloat = -15

		while currentX < 1024 {
			let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
			currentX += size.width + 2
			let building = BuildingNode(color: UIColor.red, size: size)
			building.position = CGPoint(x: currentX - size.width / 2, y: size.height / 2)
			building.setup()
			addChild(building)
			buildings.append(building)
		}

	}

	func launch(angle: Int, velocity: Int) {
		let speed = Double(velocity) / 10.0
		let radians = deg2rad(degrees: angle)
		if banana != nil {
			banana.removeFromParent()
			banana = nil
		}
		banana = SKSpriteNode(imageNamed: "banana")
		banana.name = "banana"
		banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
		banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
		banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player1.rawValue | CollisionTypes.player2.rawValue
		banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player1.rawValue | CollisionTypes.player2.rawValue
		banana.physicsBody?.usesPreciseCollisionDetection = true
		addChild(banana)

		if currentPlayer.id == 1 {
			setPlayerBitMasks(player: player1, target: player2)
			banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
			banana.physicsBody?.angularVelocity = -20
			let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
			let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
			let pause = SKAction.wait(forDuration: 0.15)
			let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
			player1.run(sequence)

			let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
			banana.physicsBody?.applyImpulse(impulse)
		} else {
			setPlayerBitMasks(player: player2, target: player1)
			banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
			banana.physicsBody?.angularVelocity = 20
			let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
			let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
			let pause = SKAction.wait(forDuration: 0.15)
			let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
			player2.run(sequence)

			let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
			banana.physicsBody?.applyImpulse(impulse)
		}
		viewController.saveSettings(player: currentPlayer)
	}

	func createPlayers() {
		player1 = SKSpriteNode(imageNamed: "player")
		player1.name = "player1"
		setPlayerPhysicsBody(player: player1)

		let player1building = buildings[1]
		player1.position = CGPoint(x: player1building.position.x, y: player1building.position.y + (player1building.size.height + player1.size.height) / 2)

		addChild(player1)

		player2 = SKSpriteNode(imageNamed: "player")
		player2.name = "player2"
		player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
		setPlayerPhysicsBody(player: player2)
		player2.physicsBody?.isDynamic = false

		let player2building = buildings[buildings.count - 2]
		player2.position = CGPoint(x: player2building.position.x, y: player2building.position.y + (player2building.size.height + player2.size.height) / 2)

		addChild(player2)

	}

	func setPlayerPhysicsBody(player: SKSpriteNode) {
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
		player.physicsBody?.categoryBitMask = player.name == "player1" ? CollisionTypes.player1.rawValue : CollisionTypes.player2.rawValue

		player.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
		player.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
		player.physicsBody?.isDynamic = false
	}

	func setPlayerBitMasks(player: SKSpriteNode,  target: SKSpriteNode) {
		player.physicsBody?.collisionBitMask = 0
		player.physicsBody?.contactTestBitMask = 0
		target.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
		target.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue

		banana.physicsBody?.collisionBitMask = player.name == "player1" ? CollisionTypes.building.rawValue | CollisionTypes.player2.rawValue : CollisionTypes.building.rawValue | CollisionTypes.player1.rawValue
		banana.physicsBody?.contactTestBitMask = player.name == "player1" ? CollisionTypes.building.rawValue | CollisionTypes.player2.rawValue : CollisionTypes.building.rawValue | CollisionTypes.player1.rawValue
	}

	func deg2rad(degrees: Int) -> Double {
		return Double(degrees) * Double.pi / 180
	}

	func didBegin(_ contact: SKPhysicsContact) {
		let firstBody: SKPhysicsBody
		let secondBody: SKPhysicsBody

		if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
			firstBody = contact.bodyA
			secondBody = contact.bodyB
		} else {
			firstBody = contact.bodyB
			secondBody = contact.bodyA
		}

		guard let firstNode = firstBody.node else { return }
		guard let secondNode = secondBody.node else { return }

		if firstNode.name == "banana" && secondNode.name == "building" {
			bananaHit(building: secondNode, atPoint: contact.contactPoint)
		}

		if firstNode.name == "banana" && secondNode.name == "player1" {
			destroy(player: player1)
		}

		if firstNode.name == "banana" && secondNode.name == "player2" {
			destroy(player: player2)
		}
	}

	func destroy(player: SKNode) {
		if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
			explosion.position = player.position
			addChild(explosion)
		}

		player.removeFromParent()
		banana.removeFromParent()

		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
			if let _ = self.currentPlayer {
				let isGameOver = self.viewController.isWinner(currentPlayer.id)
				if !isGameOver {
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						let newGame = GameScene(size: self.size)
						newGame.viewController = self.viewController
						self.viewController.currentGame = newGame

						self.changePlayer()
						newGame.currentPlayer = self.currentPlayer

						let transition = SKTransition.doorway(withDuration: 2.5)
						self.view?.presentScene(newGame, transition: transition)
						// TODO: It doesn't feel right to call setWindLabel here like this
						self.viewController.reset()
					}
				}
			}
		}

	}

	func changePlayer() {
		if currentPlayer.id == 1 {
			currentPlayer = viewController.player2
		} else {
			currentPlayer = viewController.player1
		}

		viewController.activatePlayer(player: currentPlayer)

	}

	func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
		guard let building = building as? BuildingNode else { return }
		let buildingLocation = convert(contactPoint, to: building)
		building.hit(at: buildingLocation)

		if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
			explosion.position = contactPoint
			addChild(explosion)
		}

		banana.name = ""
		banana.removeFromParent()
		banana = nil

		changePlayer()

	}

	override func update(_ currentTime: TimeInterval) {
		guard banana != nil else { return	}

		if banana.position.x < 0 || banana.position.x > size.width  {
			banana.removeFromParent()
			banana = nil
			changePlayer()
		}
	}
	
}
