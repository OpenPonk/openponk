accessing
editor
	^ editor ifNil: [ self error: 'Diagram controller is not attached to an editor.' ]