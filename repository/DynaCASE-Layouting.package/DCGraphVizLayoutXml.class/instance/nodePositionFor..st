hook
nodePositionFor: aNode
	^ self positionFrom: (aNode xPath: 'attr[@name="pos"]') first contentString