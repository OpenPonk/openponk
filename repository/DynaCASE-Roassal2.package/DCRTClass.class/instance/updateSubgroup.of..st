private
updateSubgroup: aSubgroup of: content
	| height labelShape |
	labelShape := RTLabel new height: 10.
	height := group height.
	aSubgroup addAll: (labelShape elementsOn: content value).
	group addAll: aSubgroup.
	background view addAll: aSubgroup.
	RTVerticalLineLayout new
		gapSize: 0;
		on: group.
	RTNest new centerOn: background elements: group.
	^ height