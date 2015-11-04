as yet unclassified
penaltyForRanking: aPosition
	^ ((aPosition maxRanking / 4) - aPosition ranking) abs
"	^ aPosition ranking"