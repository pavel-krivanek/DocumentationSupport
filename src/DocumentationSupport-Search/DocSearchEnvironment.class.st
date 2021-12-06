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

{ #category : #accessing }
DocSearchEnvironment >> decCurrentEntryIndex [

	currentEntryIndex := currentEntryIndex - 1
]

{ #category : #accessing }
DocSearchEnvironment >> incCurrentEntryIndex [

	currentEntryIndex := currentEntryIndex + 1
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

{ #category : #private }
DocSearchEnvironment >> resetResultEntries [
	resultEntries := OrderedCollection new.
	currentEntryIndex := 0
]

{ #category : #accessing }
DocSearchEnvironment >> resultEntries [

	^ resultEntries
]

{ #category : #private }
DocSearchEnvironment >> search2: aSearchPattern in: aChapter restrictedBy: aRangeInterval [
	| entryOrNil  docResultEntries currentSearchPosition |
	
	docResultEntries := OrderedCollection new.
	currentSearchPosition := aRangeInterval first.
	[ 
		entryOrNil := aChapter findNextString: aSearchPattern startingAt: currentSearchPosition.
		entryOrNil isNil 
	] whileFalse: [ 
		docResultEntries add: entryOrNil.
		currentSearchPosition := entryOrNil endPosition + 1.
	].
	
	^ docResultEntries
	



]

{ #category : #private }
DocSearchEnvironment >> search3: aSearchPattern in: aChapter restrictedBy: aRangeInterval [
	| chapterText startIndex docResultEntryCol |
	chapterText := aChapter source.
	startIndex := chapterText findString: aSearchPattern startingAt: aRangeInterval first.
	"startIndex := chapterText findString: aSearchPattern."
	startIndex <= 0 ifTrue: [ ^ nil ].
	docResultEntryCol := OrderedCollection new.
	[startIndex ~= 0] whileTrue: [ 
		docResultEntryCol add: (DocResultEntry 
			chapter: aChapter 
			startPosition: startIndex 
			endPosition: startIndex + aSearchPattern size - 1).
		startIndex := chapterText findString: aSearchPattern startingAt: startIndex + 1.
		 ].
	^ docResultEntryCol
]

{ #category : #'API - search' }
DocSearchEnvironment >> search: aString [
	searchPattern := aString.
	self resetResultEntries.
	searchRange chaptersDo: [ :chapter :rangeInterval |
		(self search2: searchPattern in: chapter restrictedBy: rangeInterval) ifNotNil: [ :sre | 
			resultEntries addAll: sre
		]
	].
	currentEntryIndex := resultEntries ifNotEmpty: [ 1 ] ifEmpty: [ 0 ]
	
]

{ #category : #private }
DocSearchEnvironment >> search: aSearchPattern in: aChapter restrictedBy: aRangeInterval [
	| entryOrNil  docResultEntries currentSearchPosition |
	
	docResultEntries := OrderedCollection new.
	currentSearchPosition := aRangeInterval first.
	[ 
		entryOrNil := aChapter findNextString: aSearchPattern startingAt: currentSearchPosition.
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
