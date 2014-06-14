as yet unclassified
mouseUp: anEvent

	|ret|
	(anEvent redButtonChanged & lastPoint isNotNil) ifTrue: 
	[
		ret:=(content detect: [ :item | item isOn: (lastPoint - self positionInWorld)] ifNone: [nil]).
		ret ifNotNil: 
		[
			ret moveBy: (anEvent cursorPoint - lastPoint).
			content remove: ret.
			content addFirst: ret.
		].
	].
	anEvent yellowButtonChanged ifTrue: [ lastPoint := nil ].
	self changed.