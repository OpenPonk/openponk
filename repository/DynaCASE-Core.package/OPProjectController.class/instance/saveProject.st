saving
saveProject
	self projectFolder ifNil: [ ^ self inform: 'Saving canceled' ].
	self project saveInImage.
	self saveProjectTo: self projectFolder