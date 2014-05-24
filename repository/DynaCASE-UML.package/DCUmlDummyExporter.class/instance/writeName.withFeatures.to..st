private 
writeName: aName withFeatures: someFeatures to: aStream
	| fqn |
	fqn := aName.
	someFeatures isAbstract
		ifTrue: [ fqn := '/' , fqn , '/' ].
	someFeatures isClassSide
		ifTrue: [ fqn := '_' , fqn , '_' ].
	fqn := (self formatVisibility: someFeatures visibility) , fqn.
	aStream nextPutAll: fqn