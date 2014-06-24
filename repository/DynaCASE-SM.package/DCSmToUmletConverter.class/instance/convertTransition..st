as yet unclassified
convertTransition: aTransition
	| name |
	name := '<-' , Character lf.
	aTransition name ifNil
		ifFalse: [ name := name , aTransition name ].
	^ name