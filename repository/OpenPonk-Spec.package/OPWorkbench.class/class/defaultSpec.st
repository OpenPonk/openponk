specs
defaultSpec
	^ self layoutStyle = #combined
		ifTrue: [ self specCombined ]
		ifFalse: [ self specSeparated ]