menus
editorMenu
	| builder |
	builder := DCMenuBuilder new.
	builder addItem: 'Close' icon: Smalltalk ui icons openIcon action: [  ].
	activeEditor
		ifNotNil: [ builder menu addAllFromPragma: 'dcEditorToolbarMenu' target: activeEditor ].
	^ builder menu