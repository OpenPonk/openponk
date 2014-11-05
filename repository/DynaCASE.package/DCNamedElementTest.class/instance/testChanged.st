tests
testChanged
	| diagram el changed |
	el := DCNamedElement new.
	changed := nil.
	el when: DCElementChanged do: [ :event | changed := event element ].
	self assert: changed isNil.

	changed := nil.
	el name: 'a name'.
	self assert: changed = el.

	changed := nil.
	diagram := DCDiagram new.
	diagram add: el.
	self assert: changed = el.

	changed := nil.
	diagram remove: el.
	self assert: changed = el