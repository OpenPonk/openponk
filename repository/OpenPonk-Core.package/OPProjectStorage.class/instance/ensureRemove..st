removing
ensureRemove: aProject
	projects removeAllSuchThat: [ :each | each storageFile = aProject storageFile ]