@crudastro = (data) ->
  crudastro.data = data
  crudastro.collections ||= {}
  _.forEach data, (value, key) ->
    crudastro.collections[key] = new Mongo.Collection key

