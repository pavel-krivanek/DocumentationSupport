"
I'm a DocSearchIndex which store the book, the chapter and the index of an occurrence.
"
Class {
	#name : #DocResultEntry,
	#superclass : #Object,
	#instVars : [
		'chapter',
		'startPosition',
		'endPosition',
		'scrollValue'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #initialization }
DocResultEntry class >> chapter: aChapter startPosition: aStartPosition endPosition: anEndPosition [

	^ self new initializeOnChapter: aChapter startPosition: aStartPosition endPosition: anEndPosition
]

{ #category : #initialization }
DocResultEntry class >> chapter: aChapter startPosition: aStartPosition endPosition: anEndPosition scrollValue: aScrollValue [

	^ self new initializeOnChapter: aChapter startPosition: aStartPosition endPosition: anEndPosition scrollValue: aScrollValue
]

{ #category : #accessing }
DocResultEntry >> chapter [
	^ chapter
]

{ #category : #accessing }
DocResultEntry >> chapter: aChapter [
	chapter := aChapter
]

{ #category : #accessing }
DocResultEntry >> endPosition [

	^ endPosition
]

{ #category : #accessing }
DocResultEntry >> endPosition: anObject [

	endPosition := anObject
]

{ #category : #initialization }
DocResultEntry >> initializeOnChapter: aChapter startPosition: aStartPosition endPosition: anEndPosition [

	chapter := aChapter.
	startPosition := aStartPosition.
	endPosition := anEndPosition
]

{ #category : #initialization }
DocResultEntry >> initializeOnChapter: aChapter startPosition: aStartPosition endPosition: anEndPosition scrollValue: aScrollValue [

	chapter := aChapter.
	startPosition := aStartPosition.
	endPosition := anEndPosition.
	scrollValue := aScrollValue 
]

{ #category : #accessing }
DocResultEntry >> scrollValue [

	^ scrollValue
]

{ #category : #accessing }
DocResultEntry >> scrollValue: anObject [

	scrollValue := anObject
]

{ #category : #accessing }
DocResultEntry >> startPosition [

	^ startPosition
]

{ #category : #accessing }
DocResultEntry >> startPosition: anObject [

	startPosition := anObject
]
