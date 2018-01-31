specs
defaultSpec
	^ OPWorkbench layoutStyle = #combined
		ifTrue: [ self specCombined ]
		ifFalse: [ self specSeparated ]