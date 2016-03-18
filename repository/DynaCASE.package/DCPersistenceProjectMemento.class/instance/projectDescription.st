accessing
projectDescription
	^ Dictionary
		with: #project -> (Dictionary with: #name -> project name)
		with: #timestamp -> DateAndTime now truncated asString
		with: #exporterVersion -> '0.1+prealpha'
		with: #models -> self modelsWithPlugins