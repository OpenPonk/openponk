building
addAnchor
	anchorElement := self anchorShape element.
	element view add: anchorElement.
	guideEdge := self guideLine edgeFrom: element to: anchorElement.
	element view add: guideEdge