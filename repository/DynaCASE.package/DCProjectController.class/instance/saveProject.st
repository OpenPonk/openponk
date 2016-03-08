saving
saveProject
	self persistLayouts.
	self saveProjectInImage.
	self project fileName
		ifNil: [ self project
				fileName: (UIManager default fileSave: 'Save project as .json file' extensions: #('json')) ].
	self project fileName ifNil: [ ^ self ].
	self saveProjectTo: self project fileName