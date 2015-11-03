helpers
solution: sourceMatrix
	| solution |
	solution := OrderedCollection new.
	sourceMatrix
		withIndicesDo:
			[ :value :row :col | 
			(marks at: row at: col) = self star
				ifTrue: [ solution add: (Array with: row with: col) -> value ] ].
	^ solution asArray