accessing
openOn: aProject
	project := aProject.
	self workbench announcer
		when: OPEditorFocused
		do: [ :event | 
			tree
				roots: {event diagramController model};
				expandRoots ].
	self whenBuiltDo: [ tree expandRoots ]