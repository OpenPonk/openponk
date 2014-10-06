accessing
model: aModel
	model := aModel.
"	model
		when: DCElementAdded
		do: [ :event | 
			self addModelElement: event element.
			self updateView ]."
	model
		when: DCElementRemoved
		do: [ :event |
			self removeModelElement: event element.
			self updateView ]