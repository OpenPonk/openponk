accessing
postLoadPlugins
	Metacello new
		baseline: 'FsmEditor';
		repository: 'github://dynacase/fsm-editor/repository';
		load.
	Metacello new
		baseline: 'BormEditor';
		repository: 'github://dynacase/borm-editor/repository';
		load.
	Metacello new
		baseline: 'DCUmlClassEditor';
		repository: 'github://dynacase/class-editor/repository';
		load.
	"disabled DEMO because it is using older DC version"
	"Metacello new
		baseline: 'DemoEditor';
		repository: 'github://dynacase/demo-editor/repository';
		load"