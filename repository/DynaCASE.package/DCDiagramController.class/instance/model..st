accessing
model: aModel
	model := aModel.
	self registerModelEvents: model.
"	model
		when: DCElementAdded
		do: [ :event | 
			self addModelElement: event element.
			self updateView ]."
	model
		when: DCElementRemoved
		do: [ :event |
			self removeControllerOf: event element.
			self updateView ]