saving
saveProject: aProject withMementos: aCollection to: aFolder
	self saveProject: aProject to: aFolder asFileReference.
	self removeModelsNotIn: aCollection from: aFolder / 'models'.
	self saveMementos: aCollection to: aFolder asFileReference