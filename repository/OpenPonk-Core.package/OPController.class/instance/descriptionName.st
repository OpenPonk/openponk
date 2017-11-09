forms
descriptionName
	<magritteDescription>
	| accessor |
	accessor := MAPluggableAccessor
		read: [ :me | me model name ]
		write: [ :me :newValue | 
			me model name: newValue.
			self refreshFigure ].
	^ MAStringDescription new
		accessor: accessor;
		label: 'Name';
		priority: 1;
		yourself