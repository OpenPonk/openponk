removing
removeModel: aModel
	models remove: aModel.
	aModel announcer unsubscribe: self