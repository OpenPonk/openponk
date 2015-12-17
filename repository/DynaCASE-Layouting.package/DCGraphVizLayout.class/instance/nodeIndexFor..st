hook
nodeIndexFor: aNode
	^ (aNode attributeAt: #id) allButFirst asNumber