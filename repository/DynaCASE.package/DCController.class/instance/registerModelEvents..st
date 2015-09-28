events - registering
registerModelEvents: aModel
	aModel announcer
		when: DCElementRemoved
		do:
			[ :event | 
			self diagramController removeControllerOf: event element.
			self diagramController updateView ].
	aModel announcer
		when: MooseEntityRemoved
		do:
			[ :event | 
			(self diagramController model includes: event entity)
				ifTrue:
					[ 
					self diagramController removeControllerOf: event entity.
					self diagramController updateView ] ]