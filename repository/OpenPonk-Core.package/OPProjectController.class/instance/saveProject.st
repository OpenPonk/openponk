saving
saveProject
	self projectFile ifNil: [ ^ self inform: 'Saving canceled' ].
	self project saveInImage.
	self saveProjectTo: self project storageFile.
	self inform: 'Project saved to ' , self project storageFile fullName