save/load
loadNext
	future ifEmpty: [ ^ nil ].
	history addLast: current.
	current := future removeLast.
	^ self serializer materializeMementoFrom: current