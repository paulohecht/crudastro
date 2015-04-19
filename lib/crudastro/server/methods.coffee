Meteor.methods

  crudCreate: (collectionName, data) ->
    collection = crudastro.collections[collectionName]
    #server side validations...
    collection.insert data

  crudUpdate: (collectionName, id) ->
    collection = crudastro.collections[collectionName]
    #server side validations...
    #collection.insert data