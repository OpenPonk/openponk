accessing
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ self projectsBaseline: spec.
			spec
				package: 'OpenPonk-Core'
					with: [ spec
						requires: #('OpenPonkModel' 'Magritte' 'Mocketry' 'Roassal2' 'PetitParser' 'XMLParser' 'XPath') ];
				package: 'OpenPonk-Perf';
				package: 'OpenPonk-Trachel';
				package: 'OpenPonk-Roassal2';
				package: 'OpenPonk-Telemetry'
					with: [ spec requires: #('Sentry') ];
				package: 'OpenPonk-Help';
				package: 'OpenPonk-Spec'
					with: [ spec requires: #('Merlin' 'FileDialog' 'Magritte' 'Commander') ];
				package: 'OpenPonk-UI';
				package: 'OpenPonk-Plugins'
					with: [ spec postLoadDoIt: #postLoadPlugins ].
			spec
				group: 'default'
				with: #('OpenPonk-Core' 'OpenPonk-Perf' 'OpenPonk-Trachel' 'OpenPonk-Roassal2' 'OpenPonk-Spec' 'OpenPonk-UI' 'OpenPonk-Telemetry' 'OpenPonk-Help').
			spec group: 'complete' with: #('default' 'OpenPonk-Plugins') ]