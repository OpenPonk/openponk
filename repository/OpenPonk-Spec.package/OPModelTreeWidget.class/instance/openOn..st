accessing
openOn: aProject
	self workbench announcer
		when: OPEditorFocused
		do: [ :event | 
			project ifNotNil: [ project announcer unsubscribe: self ].
			project := event diagramController model.
			project ifNotNil: [ project when: OPModelChanged do: [ tree updateTree ] ].
			tree
				roots: {project};
				expandRoots ].
	self whenBuiltDo: [ tree expandRoots ]