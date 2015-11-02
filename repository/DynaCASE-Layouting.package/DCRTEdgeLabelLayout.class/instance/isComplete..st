as yet unclassified
isComplete: aGraph
	"|E| = |N|*(|N|-1)/2"

	^ aGraph edges size = (aGraph nodes size * (aGraph nodes size - 1) / 2)