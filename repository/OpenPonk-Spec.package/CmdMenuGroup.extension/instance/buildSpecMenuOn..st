*OpenPonk-Spec
buildSpecMenuOn: aMenu
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