*OpenPonk-Spec
buildSpecSubMenuOn: aMenuItem
	| menu |
	menu := MenuModel new.
	menu addGroup: [ :group | self buildSpecMenuInlineOn: group ].
	aMenuItem subMenu: menu