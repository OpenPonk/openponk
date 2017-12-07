as yet unclassified
metadataFor: aPlugin
	^ {#pharo -> self pharoVersion.
	#openponk -> self opVersion.
	#plugin -> (self pluginVersionFor: aPlugin).
	#user -> self user} asDictionary