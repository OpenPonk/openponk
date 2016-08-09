adding
addFirst: aProject
	self ensureRemove: aProject.
	projects addFirst: aProject