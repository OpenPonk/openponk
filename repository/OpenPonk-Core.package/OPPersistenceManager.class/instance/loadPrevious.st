save/load
loadPrevious
	| import |
	history ifEmpty: [ ^ nil ].
	future addLast: current.
	current := history removeLast.
	import := OPFsmGraphML new import: current.
	^ OPFsmPersistenceMemento
		model: (import at: #model)
		layout: (import at: #layout)