algorithm
step2: aPrimeIndices
	| path |
	path := OrderedCollection new.
	path add: aPrimeIndices.
	[ self columnAt: path last y has: self star ]
		whileNotNil:
			[ path add: (self columnAt: path last y has: self star) @ path last y.
			path add: path last x @ (self rowAt: path last x has: self prime) ].
	path
		do:
			[ :each | 
			(marks at: each x at: each y) = self star
				ifTrue: [ marks at: each x at: each y put: self empty ].
			(marks at: each x at: each y) = self prime
				ifTrue: [ marks at: each x at: each y put: self star ] ].
	self resetCovers.
	marks
		withIndicesDo:
			[ :each :row :col | 
			each = self prime
				ifTrue: [ marks at: row at: col put: self empty ].
			each = self star
				ifTrue: [ columnCovers at: col put: true ] ].
	self isComplete
		ifTrue: [ ^ self ].
	self step1