as yet unclassified
selectNode: aNode
	selectedNode ~= aNode
		ifTrue: [ 
			selectedNode
				ifNotNil: [ 
					selectedNode selected: false.
					self session announce: (DCVisualNodeDeselected node: selectedNode) ].
			(selectedNode := aNode)
				ifNotNil: [ 
					selectedNode selected: true.
					self session announce: (DCVisualNodeSelected node: selectedNode) ] ]