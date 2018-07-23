*OpenPonk-Spec
buildSpecMenuOn: aMenu
	self contents
		do: [ :each | 
			each isCommandItem
				ifTrue: [ aMenu addGroup: [ :group | each buildSpecMenuOn: group ] ]
				ifFalse: [ each buildSpecMenuOn: aMenu ] ]