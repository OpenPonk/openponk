save/load
loadCurrent
	current ifNil: [ ^ nil ].
	^ self serializer materializeMementoFrom: current