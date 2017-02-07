removing
removeModel: aModel
	models remove: aModel.
	aModel announcer unsubscribe: self.
	(aModel respondsTo: #project:)
		ifTrue: [ aModel project: nil ]