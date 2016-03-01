menus
editorMenu
	| builder |
	builder := DCMenuBuilder new.
	activeEditor
		ifNotNil: [ builder menu addAllFromPragma: 'dcEditorToolbarMenu' target: activeEditor ].
	^ builder menu