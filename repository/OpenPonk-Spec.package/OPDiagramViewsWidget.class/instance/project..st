accessing
project: aProject
	project := aProject.
	project whenChanged: [ self updateContent ].
	self updateContent