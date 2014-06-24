accessing
defaultWriter
	^ XMLWriter new
		enablePrettyPrinting;
		xml;
		yourself