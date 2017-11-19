accessing
workbench: aWorkbench
	workbench := aWorkbench.
	workbench announcer
		when: OPEditorFocused
			do: [ :evt | 
			evt editor = self
				ifTrue: [ self registerShortcutsOn: workbench ] ];
		when: OPEditorUnfocused
			do: [ :evt | 
			evt editor = self
				ifTrue: [ self unregisterShortcutsOn: workbench ] ]