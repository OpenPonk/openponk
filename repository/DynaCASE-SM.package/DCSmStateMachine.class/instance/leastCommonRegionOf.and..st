as yet unclassified
leastCommonRegionOf: aVertex1 and: aVertex2
	(self is: aVertex1 ancestorOf: aVertex2)
		ifTrue: [ aVertex2 container ]
		ifFalse: [ 
			(self is: aVertex2 ancestorOf: aVertex1)
				ifTrue: [ aVertex1 container ]
				ifFalse: [ self leastCommonRegionOf: aVertex1 container state and: aVertex2 container state ] ]