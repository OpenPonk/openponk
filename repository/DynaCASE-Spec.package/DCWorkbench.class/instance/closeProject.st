project handling
closeProject
	project dirty
		ifTrue: [ 
			(UIManager default confirm: 'The "' , project projectName , '" has been modified, save changes?' orCancel: [ ^ self ])
				ifTrue: [ self saveProject ] ].
	self closeDiagram.
	project := nil