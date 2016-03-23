accessing
postLoadPlugins
	Metacello new
		baseline: 'FsmEditor';
		repository: 'github://dynacase/fsm-editor/repository';
		onConflict: [ :ex | ex allow ];
		load.
	Metacello new
		baseline: 'BormEditor';
		repository: 'github://dynacase/borm-editor/repository';
		onConflict: [ :ex | ex allow ];
		load.
	Metacello new
		baseline: 'ClassEditor';
		repository: 'github://dynacase/class-editor/repository';
		onConflict: [ :ex | ex allow ];
		load
	"disabled DEMO because it is using older DC version"
	"Metacello new
		baseline: 'DemoEditor';
		repository: 'github://dynacase/demo-editor/repository';
		load"