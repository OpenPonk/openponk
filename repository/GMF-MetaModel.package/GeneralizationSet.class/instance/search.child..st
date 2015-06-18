search
search: aParentName child: aChildName
	[^ generalizations detect: [ :each | 
			each parent name = aParentName & each child name = aChildName ]]
	on: Error
	do: [ ^ nil ]