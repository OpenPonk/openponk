adornments
createAdornmentFrom: anAssociation position: aPosition on: anElement
	| box icon size |
	size := 20.
	box := RTBox new
		size: size;
		color: Color transparent;
		borderColor: Color black;
		element.
	(RTConstraint on: box background: anElement)
		top;
		right;
		outer;
		verticalPadding: (size * aPosition) negated;
		stick.
	icon := RTBitmap new
		form: anAssociation key;
		element.
	(RTConstraint on: icon background: box) stick.
	box addCallback: (TRAddedCallback block: [ box view add: icon ]).
	box addCallback: (TRRemoveCallback block: [ icon remove ]).
	box when: TRMouseLeftClick do: [ :evt | anAssociation value value ].
	^ box