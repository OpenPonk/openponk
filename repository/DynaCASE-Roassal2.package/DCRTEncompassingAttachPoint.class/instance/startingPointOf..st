public - hooks
startingPointOf: anEdge
	| sourceElement targetElement |
	sourceElement := anEdge from.
	targetElement := anEdge to.
	^ (self offsetNormalFor: anEdge) + (self attachPointFrom: sourceElement to: targetElement)