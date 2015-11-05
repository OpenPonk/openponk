as yet unclassified
penaltyForProximity: aPosition of: anEdge
	| p1 p2 |
	p1 := self penaltyForEdgeProximity: aPosition of: anEdge.
	p2 := self penaltyForElementProximity: aPosition of: anEdge.
	^ p1 max: p2