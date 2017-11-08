deprecated
registerModelEvents: aModel
	self deprecated: 'use model: and internalSubscribeTo: instead'.
	aModel announcer
		when: OPElementRemoved
		do: [ :event | 
			self diagramController removeControllerOf: event element.
			self diagramController updateView ]