Meteor.startup ->

  _.forEach crudastro.data, (collectionDefinition, collectionName) ->

    Meteor.publish collectionName + "Table", ->
      #Meteor._sleepForMs(2000)
      #TODO: Only fields from table definition
      #TODO: Create pagination
      crudastro.collections[collectionName].find()

    Meteor.publish collectionName + "Document", (documentId) ->
      #Meteor._sleepForMs(2000)
      #TODO: Only fields from object definition
      crudastro.collections[collectionName].find
        _id: documentId
