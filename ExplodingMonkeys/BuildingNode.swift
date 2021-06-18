//
//  BuildingNode.swift
//  ExplodingMonkeys
//
//  Created by Paul Richardson on 19/06/2021.
//

import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode {

	var currentImage: UIImage!

	func setup() {
		name = "building"
		currentImage = drawBuilding(size: size)
		texture = SKTexture(image: currentImage)

		configurePhysics()
	}

	func configurePhysics() {
		physicsBody = SKPhysicsBody(texture: texture!, size: size)
		physicsBody?.isDynamic = false
		physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
		physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
	}

	drwaBuilding(size: CGSize) -> UIImage {

	}

}
