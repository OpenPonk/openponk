private
addCornerHandles
	| pointsList |
	pointsList := self router pointsList.
	handles := DoubleLinkedList new.
	handles add: (DCRTOrthoEndHandle endElement: edge from positionLink: pointsList head edge: edge).
	self router pointsList
		linksDo:
			[ :each | 
			each hasPredecessor & each hasSuccessor
				ifTrue: [ handles add: (DCRTOrthoCornerHandle positionLink: each edge: edge) ] ].
	handles add: (DCRTOrthoEndHandle endElement: edge to positionLink: pointsList tail edge: edge)