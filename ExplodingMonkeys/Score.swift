//
//  Score.swift
//  ExplodingMonkeys
//
//  Created by Paul Richardson on 21/06/2021.
//

import Foundation

enum Player: Int {
	case player1 = 1
	case player2 = 2
}

struct Score {
	var score1 = 0
	var score2 = 0

	mutating func increment(player: Player) {
		switch player {
		case .player1:
			score1 += 1
		case.player2:
			score2 += 1
		}
	}

	func description() -> String {
		"Score: \(score1):\(score2)"
	}
	
}
