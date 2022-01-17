Class {
	#name : #DocRichTextComposer,
	#superclass : #MicRichTextComposer,
	#instVars : [
		'executor',
		'resultEntries',
		'currentResultEntry',
		'library'
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

	^ currentResultEntry
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
	[ ^ aLink url path segments first = 'include:']
		on: MessageNotUnderstood do: [ ^ false ] 
]

{ #category : #testing }
DocRichTextComposer >> isRef: aLink [
	[ ^ aLink url path segments first = 'ref:']
		on: MessageNotUnderstood do: [ ^ false ] 
]

{ #category : #testing }
DocRichTextComposer >> isWeb: aLink [
	[ ^ aLink url path scheme = 'http' or: [ aLink url path segments first = 'https' ]]
		on: MessageNotUnderstood do: [ ^ false ] 
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

	| attribute |
	attribute := nil.
	
	(self isWeb: aLink) ifTrue: [ 
		attribute := TextAction new
							 actOnClickBlock: [ WebBrowser openOn: aLink url printString ] ].
						
	(self isRef: aLink) ifTrue: [ ].
	(self isInclude: aLink) ifTrue: [ self include: aLink url path segments second ].
	attribute
		ifNotNil: [ canvas includeAttribute: attribute in: [ super visitLink: aLink ] ]
		ifNil: [ super visitLink: aLink ]
]
