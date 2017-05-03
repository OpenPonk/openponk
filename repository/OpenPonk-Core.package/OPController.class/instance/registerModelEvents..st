events - registering
registerModelEvents: aModel
	aModel announcer
		when: OPElementRemoved
		do: [ :event | 
			self diagramController removeControllerOf: event element.
			self diagramController updateView ]