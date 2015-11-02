helpers
solution: sourceMatrix
	| solution |
	solution := OrderedCollection new.
	marks
		withIndicesDo:
			[ :each :row :col | 
			each = self star
				ifTrue:
					[ solution add: (Array with: row with: col) -> (sourceMatrix at: row at: col) ] ].
	^ solution asArray