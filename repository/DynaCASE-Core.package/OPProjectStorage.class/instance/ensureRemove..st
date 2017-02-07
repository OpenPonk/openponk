removing
ensureRemove: aProject
	projects removeAllSuchThat: [ :each | each uuid = aProject uuid ]