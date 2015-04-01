events - registering
registerModelEvents: aModel
	aModel
		when: DCElementRemoved
		do: [ :event | 
			self diagramController removeControllerOf: event element.
			self updateView ]