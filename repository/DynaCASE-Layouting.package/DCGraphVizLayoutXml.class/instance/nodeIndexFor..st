hook
nodeIndexFor: aNode
	^ (aNode xPath: 'attr[@name="id"]') first contentString allButFirst asNumber