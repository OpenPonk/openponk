*DynaCASE-Spec-DynamicForm
specLayout
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #entityText;
				add: #selectEntity width: 25 ];
		yourself