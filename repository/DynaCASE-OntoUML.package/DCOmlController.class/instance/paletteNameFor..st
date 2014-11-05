as yet unclassified
paletteNameFor: aController
	| matcher |
	aController name = #DCOmlBasicAssociationController
		ifTrue: [ ^ 'Association' ].
	self logCr: aController.
	matcher := 'DCOml(.*)Controller' asRegex.
	matcher matches: aController class asString.
	^ matcher subexpression: 2