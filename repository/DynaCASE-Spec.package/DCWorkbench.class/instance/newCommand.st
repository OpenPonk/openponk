menu actions
newCommand
	|choice|
	(UIManager default confirm: 'Do you wish to save current project?' orCancel: [ ^ self ])
				ifTrue: [ 	project fileName
							ifNil: [ project fileName: ((self askForFileNameToSave: project projectName , '.ston') ifNil: [ ^self ]) ].
								self saveFile: project fileName ] .
	choice := (UIManager default chooseFrom: #( 'UML' 'FSM' 'OntoUML' ) title: 'Choices'  ).
	self delete.
	choice = 1 ifTrue: [DCWorkbench exampleUmlite .].
	choice = 2 ifTrue: [DCWorkbench exampleFsm  .].
	choice = 3 ifTrue: [DCWorkbench exampleOntoUml  .].