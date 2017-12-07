accessing
pluginVersionFor: aPlugin
	^ {#name -> aPlugin name.
	#className -> aPlugin className.
	#version -> aPlugin version.
	#gitCommit -> aPlugin gitCommit} asDictionary