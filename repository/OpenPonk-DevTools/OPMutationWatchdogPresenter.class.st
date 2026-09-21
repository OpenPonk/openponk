Class {
	#name : 'OPMutationWatchdogPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'startButton',
		'stopButton',
		'clearButton',
		'copyButton',
		'statusLabel',
		'table',
		'stackPresenter'
	],
	#classVars : [
		'Default'
	],
	#category : 'OpenPonk-DevTools-Watchdog',
	#package : 'OpenPonk-DevTools',
	#tag : 'Watchdog'
}

{ #category : 'accessing' }
OPMutationWatchdogPresenter class >> default [

	^ Default ifNil: [ Default := self new ]
]

{ #category : 'accessing' }
OPMutationWatchdogPresenter class >> defaultPreferredExtent [
	^ 1000 @ 700
]

{ #category : 'instance creation' }
OPMutationWatchdogPresenter class >> open [
	<script>
	^ self default open
]

{ #category : 'specs' }
OPMutationWatchdogPresenter class >> title [
	^ 'OpenPonk Uncommanded Mutation Watchdog'
]

{ #category : 'actions' }
OPMutationWatchdogPresenter >> clearLog [
	OPMutationWatchdog default reset.
	statusLabel label: 'Status: Inactive (Log cleared)'.
	self updateTable.
	stackPresenter text: ''
]

{ #category : 'actions' }
OPMutationWatchdogPresenter >> copyReportToClipboard [
	"Format report and copy it to system clipboard."
	| reportText |
	reportText := OPMutationWatchdog default exportSuspiciousReport.
	statusLabel label: 'Copied to clipboard (', OPMutationWatchdog default suspiciousRecords size asString , ' suspicious)'.
	^ reportText
]

{ #category : 'layout' }
OPMutationWatchdogPresenter >> defaultLayout [
	^ SpBoxLayout newLeftToRight
		add: (SpBoxLayout newTopToBottom
			spacing: 5;
			add: startButton;
			add: stopButton;
			add: copyButton;
			add: clearButton;
			add: statusLabel;
			yourself)
		expand: false;
		add: (SpPanedLayout newTopToBottom
			positionOfSlider: 0.6;
			add: table;
			add: stackPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
OPMutationWatchdogPresenter >> initializePresenters [
	startButton := self newButton
		label: 'Start Watching';
		iconName: #play;
		action: [ self startWatching ];
		yourself.
	stopButton := self newButton
		label: 'Stop Watching';
		iconName: #stop;
		action: [ self stopWatching ];
		yourself.
	copyButton := self newButton
		label: 'Copy as text';
		iconName: #smallCopy;
		action: [ self copyReportToClipboard ];
		yourself.
	clearButton := self newButton
		label: 'Clear Log';
		iconName: #smallDelete;
		action: [ self clearLog ];
		yourself.
	statusLabel := self newLabel label: 'Status: Inactive'.
	table := self newTable
		addColumn: (SpStringTableColumn title: 'Time' evaluated: [ :rec | rec timestamp asTime print24 ]);
		addColumn: (SpStringTableColumn title: 'Target' evaluated: [ :rec | rec targetClass ]);
		addColumn: (SpStringTableColumn title: 'Slot' evaluated: [ :rec | rec slotName asString ]);
		addColumn: (SpStringTableColumn title: 'Change' evaluated: [ :rec | rec oldValue asString , ' -> ' , rec newValue asString ]);
		addColumn: (SpStringTableColumn title: 'UI Source' evaluated: [ :rec | rec uiPresenterClass ifNil: [ 'none' ] ]);
		whenSelectionChangedDo: [ :selection | self updateStackFor: selection selectedItem ].
	stackPresenter := self newText.
	self updateTable
]

{ #category : 'actions' }
OPMutationWatchdogPresenter >> startWatching [
	OPMutationWatchdog default startWatching.
	statusLabel label: 'Status: WATCHING (', OPMutationWatchdog default instrumentedMethods size asString , ' methods linked)'.
	self updateTable
]

{ #category : 'actions' }
OPMutationWatchdogPresenter >> stopWatching [
	OPMutationWatchdog default stopWatching.
	statusLabel label: 'Status: STOPPED (Total recorded: ', OPMutationWatchdog default records size asString , ', Suspicious: ', OPMutationWatchdog default suspiciousRecords size asString , ')'.
	self updateTable
]

{ #category : 'updating' }
OPMutationWatchdogPresenter >> updateStackFor: aRecord [
	aRecord ifNil: [ stackPresenter text: ''. ^ self ].
	stackPresenter text: (String streamContents: [ :stream |
		stream << 'Target: ' << aRecord targetClass << ' (id: ' << aRecord targetIdentity << ')'; cr.
		stream << 'Slot: #' << aRecord slotName << ' | ' << aRecord oldValue asString << ' -> ' << aRecord newValue asString; cr.
		stream << 'UI Origin: ' << (aRecord uiPresenterClass ifNil: [ 'none' ]); cr; cr.
		stream << '=== Call Stack ==='; cr.
		aRecord stackTrace do: [ :frame |
			stream << '  - ' << frame; cr ] ])
]

{ #category : 'updating' }
OPMutationWatchdogPresenter >> updateTable [
	table items: OPMutationWatchdog default suspiciousRecords
]
