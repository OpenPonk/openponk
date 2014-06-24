initialization
initializePresenter
	self session when: DCVisualNodeSelected send: #nodeSelected: to: self.
	self session when: DCVisualNodeDeselected send: #nodeDeselected: to: self.
	nameField
		whenTextChanged: [ 
			node
				ifNotNil: [ 
					Transcript crShow: node.
					node text: nameField text ] ]