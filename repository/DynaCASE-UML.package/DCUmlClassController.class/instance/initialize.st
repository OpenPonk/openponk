as yet unclassified
initialize
	viewBlock := [ 
	| group background lines |
	lines := OrderedCollection new.	"	lines add: self model name."
	self model attributes do: [ :attr | lines add: attr name , ': ' , attr type ].
	group := RTGroup new.
	group
		add:
			(RTGroup new
				add: (RTLabel new elementOn: self model name);
				yourself).
	lines
		do: [ :line | 
			group
				add:
					(RTGroup new
						add: (RTLabel new elementOn: line);
						yourself) ].
	RTVerticalLineLayout on: group.
	background := (RTBox new
		borderColor: Color lightGray;
		fillColor: Color transparent) element.
	RTNest new on: background nest: group.
	group do: [ :g | self parent view addAll: g ].
	background @ RTDraggable.
	background ]