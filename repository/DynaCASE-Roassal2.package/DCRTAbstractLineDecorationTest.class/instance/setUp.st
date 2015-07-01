running
setUp
	true ifTrue: [ ^ self skip ].
	(from := RTBox element) translateTo: 0 @ 0.
	(to := RTBox element) translateTo: 100 @ 0