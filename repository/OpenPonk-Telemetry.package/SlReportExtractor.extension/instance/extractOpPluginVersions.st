*OpenPonk-Telemetry-ShoreLine
extractOpPluginVersions
	^ OPPluginRegistry default plugins asArray
		collect: [ :each | 
			{#name -> each name.
			#className -> each className.
			#version -> each version.
			#gitCommit -> each gitCommit} asDictionary ]