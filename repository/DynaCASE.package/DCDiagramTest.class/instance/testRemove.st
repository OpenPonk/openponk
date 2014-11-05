tests
testRemove
	| diagram el removed changed |
	diagram := DCDiagram new.
	el := DCNamedElement new.
	diagram add: el.

	removed := nil.
	changed := nil.
	diagram when: DCElementRemoved do: [ :event | removed := event element ].
	diagram when: DCElementChanged do: [ :event | changed := event element ].
	diagram remove: el.

	self assert: removed = el.
	self assert: changed = diagram.
	self deny: (diagram has: el).