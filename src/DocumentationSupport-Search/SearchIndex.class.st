Class {
	#name : #SearchIndex,
	#superclass : #Object,
	#instVars : [
		'book',
		'chapter',
		'index'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #accessing }
SearchIndex class >> index: aBook in: aChapter at: anIndex [
	| index |
	index := self new.
	index book: aBook;
	chapter: aChapter;
	index: anIndex.
	^ index
]

{ #category : #accessing }
SearchIndex >> book [
	^ book
]

{ #category : #accessing }
SearchIndex >> book: aBook [
	book := aBook
]

{ #category : #accessing }
SearchIndex >> chapter [
	^ chapter
]

{ #category : #accessing }
SearchIndex >> chapter: aChapter [
	chapter := aChapter
]

{ #category : #accessing }
SearchIndex >> index [
	^ index
]

{ #category : #accessing }
SearchIndex >> index: anIndex [
	index := anIndex
]
