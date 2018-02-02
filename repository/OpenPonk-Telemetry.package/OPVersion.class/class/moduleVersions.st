accessing
moduleVersions
	| modules plugins |
	modules := {'pharo' -> SystemVersion current highestUpdate.
	'OpenPonk' -> OPVersion fullVersion}.
	plugins := OPPluginRegistry default plugins asArray
		collect: [ :each | each className -> (each version ifNil: [ each gitCommit ]) ].
	^ (modules , plugins) asDictionary