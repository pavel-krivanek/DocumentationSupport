"
I perform serialization of document libraries.
"
Class {
	#name : #DocSerializerMicrodown,
	#superclass : #Object,
	#instVars : [
		'currentPath'
	],
	#category : #'DocumentationSupport-Serialization'
}

{ #category : #accessing }
DocSerializerMicrodown >> currentPath [ 

	^ currentPath
]

{ #category : #accessing }
DocSerializerMicrodown >> currentPath: anObject [

	currentPath := anObject
]

{ #category : #exporting }
DocSerializerMicrodown >> export: aLibrary to: direcotoryFileReference [

	self currentPath: direcotoryFileReference asFileReference.
	self visitLibrary: aLibrary.

]

{ #category : #visiting }
DocSerializerMicrodown >> visitBook: aBook [

	| ref | 
		
	ref := self currentPath / aBook key.
	ref ensureCreateDirectory.
	(ref / 'description', 'md') writeStreamDo: [ :aStream |
		aBook serializeTo: aStream  ].
	aBook chapters do: [ :aChapter |
		currentPath := ref.
		aChapter acceptVisitor: self ].

]

{ #category : #visiting }
DocSerializerMicrodown >> visitChapter: aChapter [

	| ref | 
	
	ref := self currentPath / aChapter key, 'md'.
	
	ref writeStreamDo: [ :aStream | 
		aChapter serializeTo: aStream ]

]

{ #category : #visiting }
DocSerializerMicrodown >> visitLibrary: aLibrary [ 

	| ref | 
	
	ref := self currentPath / aLibrary name.
	ref ensureDeleteAll.
	ref ensureCreateDirectory.
	aLibrary books do: [ :aBook |
		currentPath := ref.
		aBook acceptVisitor: self ].
	


]
