as yet unclassified
testDefaultChildren
	self childrenFor: element equals: #().
	self childrenFor: edge equals: #().
	self childrenFor: diagram equals: (Array with: element with: edge)