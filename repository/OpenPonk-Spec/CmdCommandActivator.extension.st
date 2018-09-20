Extension { #name : #CmdCommandActivator }

{ #category : #'*OpenPonk-Spec' }
CmdCommandActivator >> buildSpecMenuOn: aGroup [
	self canExecuteCommand
		ifFalse: [ ^ self ].
	aGroup
		addItem: [ :item | 
			item
				name: self menuItemName;
				icon: self menuItemIcon;
				action: [ self executeCommand ] ]
]
