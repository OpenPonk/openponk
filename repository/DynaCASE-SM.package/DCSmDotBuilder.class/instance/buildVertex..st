building
buildVertex: aNode
	| shape shapeString label |
	shapeString := ''.
	label := ''.
	shape := self shapeOf: aNode.
	shape isNil
		ifFalse: [ shapeString := ' shape=' , shape ].
	aNode name isNil
		ifFalse: [ label := aNode name ].
	self
		indent;
		string: aNode hash;
		string: ' [';
		string: shapeString;
		string: ' label=' , (self escapeString: label) , ' ';
		string: ']'.
	self endLine