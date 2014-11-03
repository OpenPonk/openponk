removing
removeParent: xName
	parents := parents reject: [ :each | each parentClass name = xName ]