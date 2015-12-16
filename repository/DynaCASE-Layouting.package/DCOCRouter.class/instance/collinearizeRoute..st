as yet unclassified
collinearizeRoute: aRoute
	| newRoute direction step |
	newRoute := OrderedCollection with: aRoute first with: aRoute second.
	direction := newRoute first x = newRoute second x
		ifTrue: [ #x ]
		ifFalse: [ #y ].
	2 to: aRoute size do:
		[ :i | 
		step := aRoute at: i.
		(direction value: newRoute last) = (direction value: step)
			ifTrue: [ newRoute at: newRoute size put: step ]
			ifFalse: [ newRoute add: step.
				direction := direction = #x
					ifTrue: [ #y ]
					ifFalse: [ #x ] ] ].
	^ newRoute asArray