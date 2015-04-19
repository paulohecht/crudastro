Meteor.methods

  crudCreate: (collectionName, data) ->
    collection = crudastro.collections[collectionName]
    #server side validations...
    collection.insert data

  crudUpdate: (collectionName, id, data) ->
    collection = crudastro.collections[collectionName]
    #server side validations...
    collection.update
      _id: id
    ,
      $set: data