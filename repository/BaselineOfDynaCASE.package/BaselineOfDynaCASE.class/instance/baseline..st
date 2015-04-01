accessing
baseline: spec
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'DynaCASEModel' with: [
				spec
					repository: 'github://dynacase/dynacase-model/repository' ];
			project: 'Roassal2' with: [
				spec
					className: #ConfigurationOfRoassal2;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ];
			project: 'Ston' with: [
				spec
					className: #ConfigurationOfSton;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/STON/main/' ].
		spec 
			package: 'DynaCASE' with: [
				spec requires: #('DynaCASEModel' 'Roassal2' 'Ston' ). ];
			package: 'DynaCASE-Trachel';
			package: 'DynaCASE-Roassal2';
			package: 'DynaCASE-Spec';
			package: 'DynaCASE-FSM';
			package: 'GMF-MetaModel';
			package: 'DynaCASE-OntoUML'.
		spec group: 'default' with: #('DynaCASE' 'DynaCASE-Trachel' 'DynaCASE-Roassal2' 'DynaCASE-Spec' 'DynaCASE-FSM' 'GMF-MetaModel' 'DynaCASE-OntoUML' ). ].
