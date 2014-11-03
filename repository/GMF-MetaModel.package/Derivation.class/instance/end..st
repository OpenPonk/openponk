accessing
end: xEnd 
"redefine end method for special type of element deriation because one end of derivation is association"
	(xEnd isKindOf: ElementClass)
		ifTrue: [super end: xEnd];
		
		ifFalse: [end := xEnd. 
			xEnd derivated: self]