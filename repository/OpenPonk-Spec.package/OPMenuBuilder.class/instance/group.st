accessing
group
	^ menu menuGroups
		ifEmpty: [ menu addGroup: [ :group |  ] ];
		first