initialization
stateMachineDiagramTab
	| tab |
	tab := self newTab.
	tab
		label: 'StateMachine';
		icon: Smalltalk ui icons nautilusIcon;
		model: DCStateMachineTab new.
	^ tab