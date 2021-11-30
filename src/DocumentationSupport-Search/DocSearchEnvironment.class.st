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
DocSearchEnvironment >> firstOccurence [
	^ resultEntries first
		ifAbsent: [ ^ DocResultEntry new ]
]

{ #category : #initialization }
DocSearchEnvironment >> initOn: aDocSearchRange [
	searchRange := aDocSearchRange
]

{ #category : #initialization }
DocSearchEnvironment >> initialize [
	super initialize.
	resultEntries := OrderedCollection new.
	currentEntryIndex := 0
]

{ #category : #accessing }
DocSearchEnvironment >> lastOccurence [
	^ resultEntries last 
		ifAbsent: [ ^ DocResultEntry new ]
]

{ #category : #accessing }
DocSearchEnvironment >> resultEntries [

	^ resultEntries
]

{ #category : #API }
DocSearchEnvironment >> search: aString [
	searchPattern := aString.
	searchRange chaptersDo: [ :chapter :rangeInterval |
		(self search: searchPattern in: chapter restrictedBy: rangeInterval) ifNotNil: [ :sre | 
			resultEntries add: sre
		]
	].
	currentEntryIndex := resultEntries ifNotEmpty: [ 1 ] ifEmpty: [ 0 ]
	
]

{ #category : #private }
DocSearchEnvironment >> search: aSearchPattern in: aChapter restrictedBy: aRangeInterval [
	| chapterText startIndex resultEntry |
	chapterText := aChapter source.
	startIndex := chapterText findString: aSearchPattern.
	startIndex = 0 ifTrue: [ ^ nil ].
	resultEntry := DocResultEntry new.
	^ resultEntry chapter: aChapter;
		startPosition: startIndex;
		endPosition: startIndex + aSearchPattern size - 1;
		markupSize: 0;
		yourself.
]

{ #category : #accessing }
DocSearchEnvironment >> searchPattern [

	^ searchPattern
]
