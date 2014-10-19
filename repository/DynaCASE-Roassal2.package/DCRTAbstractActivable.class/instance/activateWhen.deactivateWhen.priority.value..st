hooks
activateWhen: aTREvent deactivateWhen: anotherTREvent priority: aPositiveNumber value: aValue
	originElement when: aTREvent do: [ :event | self activatePriority: aPositiveNumber value: aValue ].
	originElement when: anotherTREvent do: [ :event | self deactivatePriority: aPositiveNumber ]