events - registering
registerModelEvents: aModel
	aModel announcer
		when: OPElementRemoved
		do: [ :event | 
			self diagramController removeControllerOf: event element.
			self diagramController updateView ].
	(Smalltalk hasClassNamed: #MooseEntityRemoved)
		ifTrue: [ aModel announcer
				when: #MooseEntityRemoved asClass
				do: [ :event | 
					(self diagramController model includes: event entity)
						ifTrue: [ self diagramController removeControllerOf: event entity.
							self diagramController updateView ] ] ]