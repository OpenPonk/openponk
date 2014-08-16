accessing
model: aFsmModel
	model := aFsmModel.
	aFsmModel elements do: [ :each | self addModelElement: each ]