actions
copyView: aView
	| name newView |
	true
		ifTrue: [ ^ self ].
	[ name := UIManager default request: 'View name' initialAnswer: aView name ]
		doWhileTrue: [ name isNotNil and: [ name = aView name ] ].
	name ifNil: [ ^ self ].
	newView := aView newCopy.
	newView name: name