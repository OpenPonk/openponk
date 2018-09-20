actions
newCopy
	| newView |
	newView := self class fromJson: self asJson.
	newView name: 'copy of ' , self name.
	newView model: model.
	newView project: project.
	^ newView