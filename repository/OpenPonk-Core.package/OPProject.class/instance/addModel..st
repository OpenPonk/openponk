adding
addModel: aModel
	models add: aModel.
	(aModel respondsTo: #project:)
		ifTrue: [ aModel project: self ]