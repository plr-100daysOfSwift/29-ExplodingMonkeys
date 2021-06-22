//
//  Player.swift
//  ExplodingMonkeys
//
//  Created by Paul Richardson on 21/06/2021.
//

import Foundation

class Player: Equatable {

	static func == (lhs: Player, rhs: Player) -> Bool {
		lhs.id == rhs.id
	}

	init(id: Int) {
		self.id = id
	}

	var id: Int
	var score = 0

	var lastUsedAngle: Float = Constants.defaultAngle
	var lastUsedVelocity: Float = Constants.defaultVelocity

	func increment() {
		score += 1
	}

	var isWinner: Bool {
		score >= 3
	}

}
