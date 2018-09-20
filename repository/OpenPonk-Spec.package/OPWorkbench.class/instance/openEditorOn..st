opening
openEditorOn: aModel
	self
		openEditorOnView: (project views detect: [ :each | each model = aModel & each isDefault ])