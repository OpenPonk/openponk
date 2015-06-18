search
search: aChildName
	[^ generalizations detect: [ :each | each child name = aChildName ]]
	on: Error
	do: [ ^ nil ]