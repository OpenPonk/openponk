accessing
start: xStart
"redefine start method for special type of element deriation because one end of derivation is association"
	(xStart isKindOf: ElementClass)
		ifTrue: [super start: xStart];
		
		ifFalse: [start := xStart. 
			xStart derivated: self]