as yet unclassified
dirnsFrom: previousNode
	| res |
	res := Set new.
	self model y < previousNode model y
		ifTrue: [ res add: #top ].
	self model y > previousNode model y
		ifTrue: [ res add: #bottom ].
	self model x > previousNode model x
		ifTrue: [ res add: #left ].
	self model x < previousNode model x
		ifTrue: [ res add: #right ].
	^ res