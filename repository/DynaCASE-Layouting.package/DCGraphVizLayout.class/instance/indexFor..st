hook
indexFor: aNodeOrEdge
	^ (aNodeOrEdge attributeAt: #id) allButFirst asNumber