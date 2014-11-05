tests
testAdd
	| diagram el added changed |
	diagram := DCDiagram new.
	el := DCNamedElement new.

	added := nil.
	changed := nil.
	diagram when: DCElementAdded do: [ :event | added := event element ].
	diagram when: DCElementChanged do: [ :event | changed := event element ].
	diagram add: el.

	self assert: added = el.
	self assert: changed = diagram.
	self assert: (diagram has: el).