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
	searchPattern := aString.
	self resetResultEntries.
	searchRange chaptersDo: [ :chapter :rangeInterval |
		(self search: searchPattern in: chapter restrictedBy: rangeInterval) ifNotNil: [ :sre | 
			resultEntries add: sre
		]
	].
	currentEntryIndex := resultEntries ifNotEmpty: [ 1 ] ifEmpty: [ 0 ]
	
]

{ #category : #private }
DocSearchEnvironment >> search: aSearchPattern in: aChapter restrictedBy: aRangeInterval [
	| chapterText startIndex |
	chapterText := aChapter source.
	startIndex := chapterText findString: aSearchPattern.
	startIndex = 0 ifTrue: [ ^ nil ].
	^ DocResultEntry 
		chapter: aChapter 
		startPosition: startIndex 
		endPosition: startIndex + aSearchPattern size - 1.
]

{ #category : #accessing }
DocSearchEnvironment >> searchPattern [

	^ searchPattern
]
