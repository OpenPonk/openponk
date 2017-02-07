save/load
loadCurrent
	| import |
	current ifNil: [ ^ nil ].
	import := OPFsmGraphML new import: current.
	^ DCFsmPersistenceMemento model: (import at: #model) layout: (import at: #layout)