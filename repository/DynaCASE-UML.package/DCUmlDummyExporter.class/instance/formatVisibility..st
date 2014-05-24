private 
formatVisibility: aVisibility
	| visibilities |
	visibilities := Dictionary new.
	visibilities
		at: 'private' put: '-';
		at: 'public' put: '+';
		at: 'protected' put: '#'.
	aVisibility isNil
		ifTrue: [ ^ '' ]
		ifFalse: [ ^ visibilities at: aVisibility ]