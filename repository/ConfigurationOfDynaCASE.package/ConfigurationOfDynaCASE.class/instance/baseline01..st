baselines
baseline01: spec
	<version: '0.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/DynaCASE/DynaCASE/main/'.
		spec project: 'Roassal2' with: [
				spec
					className: #ConfigurationOfRoassal2;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ].
		spec 
			package: 'DynaCASE';
			package: 'DynaCASE-FSM';
			package: 'DynaCASE-Roassal2';
			package: 'DynaCASE-SM';
			package: 'DynaCASE-Spec';
			package: 'DynaCASE-Trachel';
			package: 'DynaCASE-UI'. ].
