as yet unclassified
convertVertex: aVertex
	| name |
	name := ''.
	aVertex name ifNil
		ifFalse: [ name := aVertex name ].
	^ name