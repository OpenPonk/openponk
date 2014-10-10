updating
update
	| y h r |
	attributesGroup do: [ :each | each remove ].
	attributesGroup removeAll.
	group removeAll.
	group addAll: topGroup.
	RTNest new
		layout: (RTVerticalLineLayout new gapSize: 0);
		centerOn: background elements: group.
	h := topGroup height.
	attributesGroup addAll: (RTLabel new height: 10; elementsOn: attributes value).
	group addAll: attributesGroup.
	background view addAll: attributesGroup.
	RTNest new
		layout: (RTVerticalLineLayout new gapSize: 0);
		centerOn: background elements: group.
	topGroup do: [ :each | each translateTo: group center x @ each trachelShape center y ].
	r := group encompassingRectangle.
	y := r top + h.
	separatorGroup first trachelShape translateTo: r left @ y.
	separatorGroup second trachelShape translateTo: r right @ y.
	separatorGroup third update.
	group addAll: separatorGroup.
	background view signalUpdate