@crudastro = (data) ->

  crudastro.documentsPerPage = 25
  crudastro.maxPagesShownInPaginator = 9

  crudastro.data = _.defaults data, crudastro.data

  crudastro.totalPages = (documentsCount) ->
    Math.ceil(documentsCount / crudastro.documentsPerPage)

  crudastro.collections ||= {}
  crudastro.pages ||= {}
  crudastro.counts ||= {}
  _.forEach crudastro.data, (value, key) ->
    crudastro.collections[key] = new Mongo.Collection key
    if Meteor.isClient
      crudastro.pages[key] = new Mongo.Collection key + 'Page'
      crudastro.counts[key] = new Mongo.Collection key + 'Count'
