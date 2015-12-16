computing
estimateTo: aDestination
	| isSame isOpposite isOrthogonal isExpected isExact isDestExpected |
	isSame := self direction = aDestination direction.
	isOpposite := self direction = (aDestination reverseOf: aDestination direction).
	isOrthogonal := isSame not & isOpposite not.
	isExpected := (aDestination dirnsFrom: self node) includes: self direction.
	isExact := (aDestination dirnsFrom: self node) = (Set with: self direction).
	isDestExpected := (aDestination dirnsFrom: self node)
		= (Set with: aDestination direction).
	isSame & isExact
		ifTrue: [ ^ 0 ].
	isOrthogonal & isExpected
		ifTrue: [ ^ 1 ].
	isSame & isExact not & isExpected | (isOpposite & isDestExpected not)
		ifTrue: [ ^ 2 ].
	isOrthogonal & isExpected not
		ifTrue: [ ^ 3 ].
	isOpposite & isDestExpected | (isSame & isExpected not)
		ifTrue: [ ^ 4 ]