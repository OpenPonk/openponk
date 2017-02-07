private
hierarchyFor: anObject
	^ (anObject allSuperclassesIncluding: OPModelObject)
		addFirst: anObject;
		yourself