private
hierarchyFor: anObject
	^ (anObject allSuperclassesIncluding: DCModelObject)
		addFirst: anObject;
		yourself