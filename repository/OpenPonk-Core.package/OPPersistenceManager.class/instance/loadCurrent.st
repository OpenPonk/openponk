save/load
loadCurrent
	| import |
	current ifNil: [ ^ nil ].
	import := OPFsmGraphML new import: current.
	^ OPFsmPersistenceMemento
		model: (import at: #model)
		layout: (import at: #layout)