@crudastro = (data) ->
  crudastro.data = _.defaults data, crudastro.data

Meteor.startup ->

  crudastro.collections ||= {}
  _.forEach crudastro.data, (value, key) ->
    crudastro.collections[key] = new Mongo.Collection key