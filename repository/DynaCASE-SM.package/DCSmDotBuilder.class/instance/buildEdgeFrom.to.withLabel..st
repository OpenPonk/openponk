building
buildEdgeFrom: aSource to: aTarget withLabel: aLabel
	self
		indent;
		string: aSource hash;
		arrow;
		string: aTarget hash.
	aLabel isNil
		ifFalse: [ self string: '[label=' , (self escapeString: aLabel) , ']' ].
	self endLine