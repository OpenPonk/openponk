*OpenPonk-Telemetry-ShoreLine
extractMetadata
	^ {#pharo -> self extractVersion.
	#openponk -> self extractOpVersion.
	#plugins -> self extractOpPluginVersions.
	#auto -> SlReporter autoSubmit.
	#user -> self extractUser} asDictionary