accessing
postLoadPlugins
	Metacello new
		baseline: 'FsmEditor';
		repository: 'github://openponk/fsm-editor/repository';
		onConflict: [ :ex | ex allow ];
		load.
	Metacello new
		baseline: 'BormEditor';
		repository: 'github://openponk/borm-editor/repository';
		onConflict: [ :ex | ex allow ];
		load.
	Metacello new
		baseline: 'ClassEditor';
		repository: 'github://openponk/class-editor/repository';
		onConflict: [ :ex | ex allow ];
		load