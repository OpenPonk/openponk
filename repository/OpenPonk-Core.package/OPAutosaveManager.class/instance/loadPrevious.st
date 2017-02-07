save/load
loadPrevious
	history ifEmpty: [ ^ nil ].
	future addLast: current.
	current := history removeLast.
	^ self serializer materializeMementoFrom: current