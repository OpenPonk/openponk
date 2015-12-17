hook
indexFor: aNodeOrEdge
	^ (aNodeOrEdge xPath: 'attr[@name="id"]') first contentString allButFirst asNumber