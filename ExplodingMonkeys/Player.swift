//
//  Player.swift
//  ExplodingMonkeys
//
//  Created by Paul Richardson on 21/06/2021.
//

import Foundation

struct Player: Equatable {
	var id: Int
	var score = 0

	mutating func increment() {
		score += 1
	}

	var isWinner: Bool {
		score >= 3
	}

}
