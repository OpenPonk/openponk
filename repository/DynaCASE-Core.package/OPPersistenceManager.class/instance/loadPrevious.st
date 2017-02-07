save/load
loadPrevious
	| import |
	history ifEmpty: [ ^ nil ].
	future addLast: current.
	current := history removeLast.
	import := DCFsmGraphML new import: current.
	^ DCFsmPersistenceMemento model: (import at: #model) layout: (import at: #layout)