"
I search the index of all substring's occurence in a `DocLibrary` that I register in my searchCache
"
Class {
	#name : #DocSearchEnvironment,
	#superclass : #Object,
	#instVars : [
		'searchRange',
		'resultEntries',
		'currentEntryIndex',
		'searchPattern'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #'instance creation' }
DocSearchEnvironment class >> on: aDocSearchRange [
	^ self new initOn: aDocSearchRange
]

{ #category : #accessing }
DocSearchEnvironment >> currentEntryIndex [

	^ currentEntryIndex
]

{ #category : #accessing }
DocSearchEnvironment >> currentEntryIndex: anObject [

	currentEntryIndex := anObject
]

{ #category : #initialization }
DocSearchEnvironment >> initOn: aDocSearchRange [
	searchRange := aDocSearchRange
]

{ #category : #initialization }
DocSearchEnvironment >> initialize [
	super initialize.
	self resetResultEntries
]

{ #category : #iteration }
DocSearchEnvironment >> nextChapterInResultEntries [
	| key index currentIndex |
	currentIndex := currentEntryIndex.
	index := currentEntryIndex + 1.
	index <= resultEntries size 
		ifTrue: [ 
			[ 	
				currentIndex = currentEntryIndex
			] whileTrue: [ 
				key := (resultEntries at: currentEntryIndex) chapter key.
				currentEntryIndex := index = resultEntries size ifTrue: [ 1 ] ifFalse: [ currentEntryIndex ].
	 			currentEntryIndex := (resultEntries at: index) chapter key ~= key ifTrue: [ index ] ifFalse: [ currentEntryIndex ].
				index := index + 1
			] 
		] 
		ifFalse: [ 
			currentEntryIndex := resultEntries ifEmpty: [ 0 ] ifNotEmpty: [ 1 ]
		]
	
]

{ #category : #iteration }
DocSearchEnvironment >> nextResultEntry [

	currentEntryIndex := currentEntryIndex = resultEntries size
		                     ifTrue: [ 1 ]
		                     ifFalse: [ currentEntryIndex + 1 ]
]

{ #category : #iteration }
DocSearchEnvironment >> prevChapterInResultEntries [
	| key index currentIndex |
	currentIndex := currentEntryIndex.
	index := currentEntryIndex - 1.
	index >= 1 
		ifTrue: [ 
			[ 	
			currentIndex = currentEntryIndex
			] whileTrue: [ 
				key := (resultEntries at: currentEntryIndex) chapter key.
				currentEntryIndex := index = 1 ifTrue: [ resultEntries size ] ifFalse: [ currentEntryIndex ].
	 			currentEntryIndex := (resultEntries at: index) chapter key ~= key ifTrue: [ index ] ifFalse: [ currentEntryIndex ].
				index := index - 1
			] 
		] 
		ifFalse: [ 
			currentEntryIndex := resultEntries size
	   ]
	
]

{ #category : #iteration }
DocSearchEnvironment >> prevResultEntry [

	currentEntryIndex := currentEntryIndex = 1
		                     ifTrue: [ resultEntries size ]
		                     ifFalse: [ currentEntryIndex - 1 ]
]

{ #category : #private }
DocSearchEnvironment >> resetResultEntries [
	resultEntries := OrderedCollection new.
	currentEntryIndex := 0
]

{ #category : #accessing }
DocSearchEnvironment >> resultEntries [

	^ resultEntries
]

{ #category : #'API - search' }
DocSearchEnvironment >> search: aString [
	[ 
	searchPattern := aString.
	self resetResultEntries.
	searchRange chaptersDo: [ :chapter :rangeInterval |
		(self search: searchPattern in: chapter restrictedBy: rangeInterval) ifNotNil: [ :sre | 
			resultEntries addAll: sre
		]
	].
	currentEntryIndex := resultEntries ifNotEmpty: [ 1 ] ifEmpty: [ 0 ]
	] on: MessageNotUnderstood do: [ Error signal: #environmentNotSet ]
	
]

{ #category : #private }
DocSearchEnvironment >> search: aSearchPattern in: aChapter restrictedBy: aRangeInterval [
	| entryOrNil  docResultEntries currentSearchPosition |
	
	docResultEntries := OrderedCollection new.
	currentSearchPosition := aRangeInterval first.
	[ 
		entryOrNil :=  aChapter findNextString: aSearchPattern startingAt: currentSearchPosition restrictedBy: aRangeInterval last.
		entryOrNil isNil
	] whileFalse: [ 
		docResultEntries add: entryOrNil.
		currentSearchPosition := entryOrNil endPosition + 1.
	].
	
	^ docResultEntries
	



]

{ #category : #accessing }
DocSearchEnvironment >> searchPattern [

	^ searchPattern
]