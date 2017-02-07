save/load
loadNext
	| import |
	future ifEmpty: [ ^ nil ].
	history addLast: current.
	current := future removeLast.
	import := DCFsmGraphML new import: current.
	^ DCFsmPersistenceMemento model: (import at: #model) layout: (import at: #layout)