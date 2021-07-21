Extension { #name : #CmdRootMenuGroup }

{ #category : #'*OpenPonk-Spec' }
CmdRootMenuGroup >> buildSpecMenuOn: aMenu [
	self contents
		do: [ :each | 
			each isCommandItem
				ifTrue: [ each activator canExecuteCommand
						ifTrue: [ aMenu addGroup: [ :group | each buildSpecMenuOn: group ] ] ]
				ifFalse: [ each buildSpecMenuOn: aMenu ] ]
]
