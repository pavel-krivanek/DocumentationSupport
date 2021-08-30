"
An model with support of `DocAspectChanged` announcements
"
Class {
	#name : #DocModel,
	#superclass : #Model,
	#category : #'DocumentationSupport-Model'
}

{ #category : #events }
DocModel >> addMetadataTo: aDictionary [ 
]

{ #category : #events }
DocModel >> aspectChanged: aSymbol [ 

	self announcer announce: (DocAspectChanged new 
		aspect: aSymbol;
		origin: self;
		yourself)
]

{ #category : #serialization }
DocModel >> materializeFrom: aStream [
	
	| metadata |
	
	metadata := self readMetadataFromStream: aStream.
	self readMetadataFrom: metadata.
]

{ #category : #serialization }
DocModel >> readMetadataFromStream: aStream [
	
	| metadata key valueString |
	
	metadata := Dictionary new.

	[ aStream atEnd ] whileFalse: [ 
		| line aKey value | 
		line := aStream nextLine.
		line trimBoth isEmpty ifTrue: [ ^ metadata ].
		aKey := (line copyUpTo: $:) trimBoth.
		valueString := (line copyAfter: $:) trimBoth.
		value := valueString 
			ifNotEmpty: [ STON fromString: valueString ]
			ifEmpty: [ nil ].
		(aKey notEmpty and: [ value notNil ]) ifTrue: [ 
			metadata at: aKey put: value ].
		 ].
	
	^ metadata
]

{ #category : #serialization }
DocModel >> serializeTo: aStream [

	| metadata |
	
	metadata := Dictionary new.
	self addMetadataTo: metadata.
	
	self writeMetadata: metadata toStream: aStream.
	
]

{ #category : #events }
DocModel >> whenAspectChangedNotify: anObject [ 

	self announcer weak when: DocAspectChanged send: #whenAspectChanged: to: anObject.

]

{ #category : #serialization }
DocModel >> writeContentTo: aStream [

	"do nothing here"	
]

{ #category : #serialization }
DocModel >> writeMetadata: aDictionary toStream: aStream [.

	aDictionary keysAndValuesDo: [ :key :value |
		aStream nextPutAll: key asString.
		aStream nextPutAll: ': '.
		value ifNotNil: [ 
			STON put: value onStream: aStream ].
		aStream crlf ]
]
