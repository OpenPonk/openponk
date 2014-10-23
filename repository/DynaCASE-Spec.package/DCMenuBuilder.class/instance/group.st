accessing
group
	menu menuGroups size = 0
		ifTrue: [ menu addGroup: [ :group |  ] ].
	^ menu menuGroups first