accessing
absoluteBalanceFor: aNumber
	| balance |
	balance := aNumber.
	balance > 1
		ifTrue: [ ^ self length min: balance ].
	balance < 0
		ifTrue: [ ^ 0 max: self length - balance negated ].
	^ self length * balance