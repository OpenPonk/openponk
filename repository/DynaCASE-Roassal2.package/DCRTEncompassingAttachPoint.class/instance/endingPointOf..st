public - hooks
endingPointOf: anEdge
	| sourceElement targetElement |
	sourceElement := anEdge to.
	targetElement := anEdge from.
	^ (self offsetNormalFor: anEdge) + (self attachPointFrom: sourceElement to: targetElement)