save/load
loadNext
	| import |
	future ifEmpty: [ ^ nil ].
	history addLast: current.
	current := future removeLast.
	import := OPFsmGraphML new import: current.
	^ OPFsmPersistenceMemento
		model: (import at: #model)
		layout: (import at: #layout)