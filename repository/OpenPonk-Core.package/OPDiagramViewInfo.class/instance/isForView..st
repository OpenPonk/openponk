testing
isForView: aView
	^ aView modelType = self modelType & (aView modelName = self modelName)
		& (aView modelVersion = self modelVersion) & (aView name = self viewName)