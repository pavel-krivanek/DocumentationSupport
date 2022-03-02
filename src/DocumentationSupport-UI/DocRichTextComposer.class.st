Class {
	#name : #DocRichTextComposer,
	#superclass : #MicRichTextComposer,
	#instVars : [
		'executor',
		'resultEntries',
		'currentResultEntry',
		'libraryPresenter'
	],
	#classInstVars : [
		'searchIndex',
		'searchSize',
		'searchHighLightEnableOn',
		'searchWord'
	],
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #accessing }
DocRichTextComposer class >> searchHighLightEnableOn [
	^ searchHighLightEnableOn ifNil: [ ^ false ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchHighLightEnableOn: aBoolean [
	searchHighLightEnableOn := aBoolean
]

{ #category : #accessing }
DocRichTextComposer class >> searchIndex [
	^ searchIndex ifNil: [ ^ 1 ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchIndex: anInteger [
	searchIndex := anInteger
]

{ #category : #accessing }
DocRichTextComposer class >> searchSize [
	^ searchSize ifNil: [ ^ 1 ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchSize: anInteger [
	searchSize := anInteger.
]

{ #category : #accessing }
DocRichTextComposer class >> searchWord [
	^ searchWord ifNil: [ ^ '' ]
]

{ #category : #accessing }
DocRichTextComposer class >> searchWord: aString [
	searchWord := aString.
]

{ #category : #accessing }
DocRichTextComposer >> currentResultEntry [

	^ currentResultEntry ifNil: [ ^ DocResultEntry new ]
]

{ #category : #accessing }
DocRichTextComposer >> currentResultEntry: anObject [

	currentResultEntry := anObject
]

{ #category : #accessing }
DocRichTextComposer >> executor [

	^ executor
]

{ #category : #accessing }
DocRichTextComposer >> executor: anObject [

	executor := anObject
]

{ #category : #highlighting }
DocRichTextComposer >> highlightText: aText [
	[ 
	resultEntries do: [ :resultEntry |
		resultEntry = currentResultEntry 
			ifTrue: [ aText addAttribute: (TextBackgroundColor new color: Color green ) from: resultEntry startPosition to: resultEntry endPosition ] 
			ifFalse: [ aText addAttribute: (TextBackgroundColor new color: Color lightGray ) from: resultEntry startPosition to: resultEntry endPosition ]
	]] on: SubscriptOutOfBounds,MessageNotUnderstood do: [ "nothing" ]
	
	
]

{ #category : #'API-link' }
DocRichTextComposer >> include: aChapterKey [
	
	| text tree |
	text := (DocChapter dictionnaryOfChaptersAt: aChapterKey) source.
	tree := MicroDownParser parse: text.
	tree accept: self
]

{ #category : #highlighting }
DocRichTextComposer >> indexOfOccurence: aText [
	| index |
	index := 0.
	1 to: self class searchIndex do: [ :occurence |
		 index := aText findString: self class searchWord startingAt: index + 1 ].
	^ index
]

{ #category : #testing }
DocRichTextComposer >> isInclude: aLink [
	[ ^ aLink url beginsWith: 'include://']
		on: MessageNotUnderstood do: [ ^ false ] 
]

{ #category : #testing }
DocRichTextComposer >> isRef: aLink [
	[ ^ aLink url beginsWith: 'ref://']
		on: MessageNotUnderstood do: [ ^ false ] 
]

{ #category : #testing }
DocRichTextComposer >> isWeb: aLink [
	[ ^ aLink url beginsWith: 'http']
		on: MessageNotUnderstood do: [ ^ false ] 
]

{ #category : #accessing }
DocRichTextComposer >> libraryPresenter [

	^ libraryPresenter
]

{ #category : #accessing }
DocRichTextComposer >> libraryPresenter: anObject [

	libraryPresenter := anObject
]

{ #category : #'API-link' }
DocRichTextComposer >> ref: aChapterKey [
	| chapter |
	chapter := (libraryPresenter library chapterOfKey: aChapterKey).
	chapter
		ifNotNil: [ libraryPresenter clickAt: chapter path ]
	 	ifNil:  [ self refInOtherLibrary: (DocChapter dictionnaryOfChaptersAt: aChapterKey) ]
]

{ #category : #'API-link' }
DocRichTextComposer >> refInOtherLibrary: aChapter [
	| libraryPresenter |
	libraryPresenter := aChapter library asPresenter.
	libraryPresenter openWithSpec.
	libraryPresenter clickAt: aChapter path
]

{ #category : #accessing }
DocRichTextComposer >> resultEntries [

	^ resultEntries
]

{ #category : #accessing }
DocRichTextComposer >> resultEntries: anObject [

	resultEntries := anObject
]

{ #category : #visiting }
DocRichTextComposer >> visit: aDocument [
	| text |
	text := super visit: aDocument.
	self highlightText: text.
	^ text.
]

{ #category : #visiting }
DocRichTextComposer >> visitExternalLink: aLink [
	| attribute target url |
	target := aLink reference.
	url := target asUrl.
	attribute := nil.
	(#(http https) includes: url scheme )
		ifTrue: [ attribute := "PRExternalLinkTextAction url: target"
			 	TextAction new actOnClickBlock: [WebBrowser openOn: target]].
	url scheme = #browse
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ self class browse: aLink urlEntry ] ].
	url scheme = #ref
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ executor openReference: aLink urlEntry] ].
	url scheme = #include
		ifTrue:
			[ attribute := TextAction new actOnClickBlock: [ executor openReference: aLink urlEntry ] ].
	attribute
		ifNotNil:
			[ canvas includeAttribute: attribute in: [ super visitLink: aLink ] ]
		ifNil: [ self visitLink: aLink ]

]

{ #category : #visiting }
DocRichTextComposer >> visitLink: aLink [

	| attributes |
	attributes := OrderedCollection new.
	(self isWeb: aLink) ifTrue: [ 
		attributes add: (TextAction new
							 actOnClickBlock: [ WebBrowser openOn: aLink url printString ]).
		(DocLinkResolver isValidAddressForName: aLink url asUrl host timeout: 60) 
			ifFalse: [ attributes add: (TextBackgroundColor new color: (Color orange alpha: 0.5)) ] ].
						
	(self isRef: aLink) ifTrue: [ 
		(DocLinkResolver isValidChapterForName: aLink url asUrl host) 
			ifFalse: [ attributes add: (TextBackgroundColor new color: (Color orange alpha: 0.5))]
			ifTrue: [ attributes add: (TextAction new actOnClickBlock: [ self ref: aLink url asUrl host ]) ] ].
		
	(self isInclude: aLink) ifTrue: [ 
		(DocLinkResolver isValidChapterForName: aLink url asUrl host) 
			ifFalse: [ attributes add: (TextBackgroundColor new color: (Color orange alpha: 0.5))]
			ifTrue: [ self include: aLink url asUrl host ] ].
			
	attributes
		ifNotEmpty: [ canvas includeAttributes: attributes in: [ super visitLink: aLink ] ]
		ifEmpty: [ super visitLink: aLink ]
]
