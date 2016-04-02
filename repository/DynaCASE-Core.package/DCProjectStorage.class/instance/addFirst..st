adding
addFirst: aProject
	projects remove: aProject ifAbsent: [  ].
	projects addFirst: aProject