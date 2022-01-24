"
A documentation chapter presenter with editor and preview
"
Class {
	#name : #DocChapterPresenter,
	#superclass : #DocModelPresenter,
	#instVars : [
		'chapter',
		'srcInput',
		'preview',
		'previewUpdateMutex',
		'updateProcess',
		'titleInput',
		'keyInput',
		'copyRefButton',
		'copyIncludeButton',
		'parent',
		'nextInput',
		'clearNext',
		'goToNext',
		'splitButton',
		'showEditor'
	],
	#category : #'DocumentationSupport-UI-Presenters'
}

{ #category : #'instance creation' }
DocChapterPresenter class >> on: aChapter [ 

	^ self basicNew 
		chapter: aChapter;
		initialize
]

{ #category : #'instance creation' }
DocChapterPresenter class >> on: aChapter application: anApplication [

	^ self basicNew 
		application: anApplication;
		chapter: aChapter;
		initialize
]

{ #category : #events }
DocChapterPresenter >> aspect: anAspect changedFrom: anOrigin [

	anOrigin = self ifTrue: [ ^ self ].
	
	anAspect = #source ifTrue: [ srcInput text: chapter source. ].
	anAspect = #title ifTrue: [ titleInput text: chapter title. ].
	anAspect = #key ifTrue: [ keyInput text: chapter key. ].
	anAspect = #nextChapter ifTrue: [ nextInput text: chapter nextChapterText. ].

]

{ #category : #accessing }
DocChapterPresenter >> chapter [

	^ chapter
]

{ #category : #accessing }
DocChapterPresenter >> chapter: aChapter [

	chapter := aChapter.

]

{ #category : #preview }
DocChapterPresenter >> getPreviewPresenter [ 

	| textMorph presenter src |
	
	src := chapter ifNil: [ '' ] ifNotNil: [ chapter source ].
	textMorph := self previewMorphFor: src.

	presenter := SpMorphPresenter new.
	presenter morph: textMorph.

	^ presenter.
]

{ #category : #initialization }
DocChapterPresenter >> initializePresenters [ 

	super initializePresenters.
	
	previewUpdateMutex := Mutex new.
	
	titleInput := self newTextInput.
	titleInput text: self chapter title.
	titleInput whenTextChangedDo: [ :aText | self chapter title: aText ].

	keyInput := self newTextInput.
	keyInput enabled: false.
	keyInput text: self chapter key.
	
	copyRefButton := self newButton 
		label: 'ref://';
		action: [ 
			Clipboard clipboardText: '[', chapter title, '](ref://', self chapter key, ')' ].

	copyIncludeButton := self newButton
		label: 'include://';
		action: [ 
			Clipboard clipboardText: '[', chapter title, '](include://', self chapter key, ')' ].

	srcInput := self newText.
	preview := self getPreviewPresenter.
	
	preview morph setText: '' asText.
	
	srcInput text: self chapter source.	

	srcInput whenTextChangedDo: [ :newText | 
		self chapter source: newText.
		self updatePreview: newText ].
	
	chapter whenAspectChangedNotify: self.
	
	nextInput := self newTextInput.
	nextInput text: (self chapter nextChapterText).
	nextInput
		enabled: false; 
		dropEnabled: true;
		wantsDrop: [ :transfer | transfer passenger allSatisfy: [ :each | each isKindOf: DocChapter ] ];
		acceptDrop: [ :transfer | 		
			| aChapter |
			aChapter := transfer passenger anyOne.
			self chapter nextChapter: aChapter.
			nextInput text: aChapter title ].

	clearNext := self newButton
		icon: (self iconNamed: #changeRemove);
		action: [ 
			self chapter nextChapter: nil ].
		
	goToNext := self newButton
		icon: (self iconNamed: #glamorousGo);
		action: [ 
			self chapter nextChapter ifNotNil: [ 
				self openReference: (ZnUrl fromString: ('ref://', self chapter nextChapter key))] ].
		
	showEditor := false.
	splitButton := self newButton 
		icon: (self iconNamed: #edit);
		action: [ 
			showEditor := showEditor not.
			layout := self layoutShowingEditor: showEditor ].
		
	layout := self layoutShowingEditor: showEditor.
	self updatePreview: self chapter source


]

{ #category : #initialization }
DocChapterPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Documentation';
		initialExtent: 1100@850;
		windowIcon: (self iconNamed: #book)
]

{ #category : #layout }
DocChapterPresenter >> layoutShowingEditor: aBoolean [

	| previewLayout |
	
	aBoolean traceCr.
	previewLayout := SpBoxLayout newHorizontal spacing: 5.
	aBoolean ifTrue: [ previewLayout add: #srcInput expand: true ].
	previewLayout 
		add: #splitButton withConstraints: [ :con | con expand: false; width: 24];
		add: #preview expand: true.

	^ SpBoxLayout newVertical
		beNotHomogeneous;
		add: (SpGridLayout new
			add: 'Title:' at: 1@1;
			add: #titleInput at: 2@1 span: 4@1;
			add: 'Key:' at: 1@2;
			add: (
				SpBoxLayout newHorizontal
					spacing: 5;
					add: #keyInput expand: true fill: true;
					add: #copyRefButton expand: false;
					add: #copyIncludeButton expand: false;
					yourself
			) at: 2@2 span: 4@1;
			add: 'Next:' at: 1@3;
			add: (
				SpBoxLayout newHorizontal
					spacing: 5;
					add: #nextInput expand: true fill: true;
					add: #clearNext expand: false;
					add: #goToNext expand: false;
					yourself
			) at: 2@3 span: 4@1;
			
			yourself) height: 120;
		add: previewLayout expand: true
]

{ #category : #actions }
DocChapterPresenter >> openReference: aRef [ 

	| aKey | 
	
	aKey := aRef host.
	
	parent 
		ifNotNil: [ 
			parent openChapter: aKey. ]
		ifNil: [ 
			(self class on: (self chapter library chapterOfKey: aKey) application: self application) openWithSpec
			 ]
	

	
]

{ #category : #accessing }
DocChapterPresenter >> parent [

	^ parent
]

{ #category : #accessing }
DocChapterPresenter >> parent: anObject [
	parent := anObject.
	self updatePreview: self chapter source
]

{ #category : #preview }
DocChapterPresenter >> previewMorphFor: aSource [

	|  text textModel textMorph |

	text := self textFor: aSource.

	textModel := RubScrolledTextModel new.
	textMorph := textModel newScrolledText.
	textMorph
		beReadOnly;
		beWrapped.
	textModel setInitialText: text.
	
	 ^ textMorph
]

{ #category : #accessing }
DocChapterPresenter >> scrollValue [ 
	^ preview morph scrollPane vScrollbarValue
]

{ #category : #accessing }
DocChapterPresenter >> scrollValue: aScrollValue [
	| scrollpane |
	scrollpane := preview morph scrollPane vScrollbarValue: aScrollValue.
]

{ #category : #preview }
DocChapterPresenter >> textFor: aSource [

	|  builder text richTextComposer |

	builder := MicroDownParser builder.
	builder text: aSource.
	text := [ 
		| parser tree |
		parser := MicroDownParser new.
		tree := parser parse: builder contents.
		richTextComposer := DocRichTextComposer new
			executor: self.
		self parent 
			ifNotNil: [ 
				richTextComposer libraryPresenter: self parent.
				self parent actualChapterPresenter: self.
				self parent searchEnv 
					ifNotNil: [ 
						richTextComposer resultEntries: (self parent searchEnv resultEntriesOf: self chapter key).
						richTextComposer currentResultEntry: self parent searchEnv currentResultEntry ] ].
		richTextComposer visit: tree
		]
		on: STONReaderError, MicParsingError, MessageNotUnderstood, SubclassResponsibility 
			do: [ :e | builder contents ].
	^ text
]

{ #category : #preview }
DocChapterPresenter >> updatePreview: newSource [ 

		| newText |

	previewUpdateMutex critical: [ 
		updateProcess ifNotNil: [ 
			updateProcess terminate.
			updateProcess := nil ] ].

	"updateProcess := [ 
		newText := self textFor: newSource.
	
		previewUpdateMutex critical: [ 
			self defer: [ 
				preview morph setText: newText ] ]
	] fork."

		previewUpdateMutex critical: [ 
			self defer: [preview morph setText: (self textFor: newSource) ] ].
		
	
]
