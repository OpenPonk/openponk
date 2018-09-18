accessing
project: aProject
	project := aProject.
	project whenChanged: [ self updateContent ].
	self updateContent.
	self workbench announcer when: OPEditorUnfocused do: [ :event | list resetSelection ].
	self workbench announcer when: OPEditorFocused do: [ :event | self updateContent ]