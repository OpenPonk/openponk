rendering
fullRebuild
	view ifNil: [ ^ nil ].
	removedFigures do: #remove.
	removedFigures := OrderedCollection new.
	self figures
		do: [ :each | 
			(each isKindOf: DCFigure)
				ifTrue: [ each fullRebuild ]
				ifFalse: [ 
					each view ifNil: [ view add: each ].
					each update ] ].
	self update