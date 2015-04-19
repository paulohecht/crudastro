Meteor.startup ->

  _.forEach crudastro.data, (collectionDefinition, collectionName) ->

    Meteor.publish collectionName + "Table", ->
      #TODO: Only fields from table definition
      crudastro.collections[collectionName].find()

    Meteor.publish collectionName + "Document", (documentId) ->
      #TODO: Only fields from object definition
      crudastro.collections[collectionName].find
        _id: documentId