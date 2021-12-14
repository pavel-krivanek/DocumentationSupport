Class {
	#name : #DocSearchRange,
	#superclass : #Object,
	#instVars : [
		'chaptersToSearch',
		'posInterval'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #'instance creation' }
DocSearchRange class >> chapters: aChaptersToSearch posInterval: aPosInterval [
	^ self new initChapters: aChaptersToSearch posInterval: aPosInterval
]

{ #category : #API }
DocSearchRange >> chaptersDo: aBlock [
	| |
	chaptersToSearch doWithIndex: [ :chapter :index | 
		aBlock value: chapter value: (index = 1 ifTrue: [ posInterval ] ifFalse: [ 1 to: chapter source size ]).
	]

]

{ #category : #accessing }
DocSearchRange >> chaptersToSearch [
	^ chaptersToSearch
]

{ #category : #accessing }
DocSearchRange >> chaptersToSearch: aChapter [
	chaptersToSearch := aChapter
]

{ #category : #initialize }
DocSearchRange >> initChapters: aChapterToSearch posInterval: aPosInterval [
	chaptersToSearch := aChapterToSearch.
	posInterval := aPosInterval
]

{ #category : #accessing }
DocSearchRange >> posInterval [
	^ posInterval
]

{ #category : #accessing }
DocSearchRange >> posInterval: anInterval [
	posInterval := anInterval
]
