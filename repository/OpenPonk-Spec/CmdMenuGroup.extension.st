Extension { #name : #CmdMenuGroup }

{ #category : #'*OpenPonk-Spec' }
CmdMenuGroup >> buildSpecMenuInlineOn: aGroup [
	self contents do: [ :each | each buildSpecMenuOn: aGroup ]
]

{ #category : #'*OpenPonk-Spec' }
CmdMenuGroup >> buildSpecMenuOn: aMenu [
	aMenu
		addGroup: [ :group | 
			self isInlined
				ifTrue: [ self buildSpecMenuInlineOn: group ]
				ifFalse: [ group
						addItem: [ :item | 
							item
								name: self name;
								icon: self icon.
							self buildSpecSubMenuOn: item ] ] ]
]

{ #category : #'*OpenPonk-Spec' }
CmdMenuGroup >> buildSpecSubMenuOn: aMenuItem [
	| menu |
	menu := MenuModel new.
	menu addGroup: [ :group | self buildSpecMenuInlineOn: group ].
	aMenuItem subMenu: menu
]
