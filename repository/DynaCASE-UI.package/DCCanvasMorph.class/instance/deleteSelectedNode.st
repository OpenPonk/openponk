as yet unclassified
deleteSelectedNode
	| announcement |
	selectedNode
		ifNotNil: [ 
			announcement := DCVisualNodeDeleted node: selectedNode.
			content remove: selectedNode.
			selectedNode detached.
			self selectNode: nil.
			self session announce: announcement.
			self changed ]