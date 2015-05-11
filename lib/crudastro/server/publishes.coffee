Meteor.publish "crudastroTable", (collectionName, pagination) ->
  #Meteor._sleepForMs(2000)
  pagination ||= {}
  pagination = _.defaults pagination,
    page: 0
    limit: crudastro.documentsPerPage

  queryBase = {}

  if pagination.sort
    sort = {}
    sort[pagination.sort] = if pagination.dir == 'desc' then -1 else 1

  countCursor = crudastro.collections[collectionName].find queryBase,
    fields:
      _id: 1
  count = 0
  @added collectionName + 'Count', 1,
    count: count
  countHandle = countCursor.observeChanges
    added: (id, fields) =>
      @changed collectionName + 'Count', 1,
        count: ++count
    removed: (id, fields) =>
      @changed collectionName + 'Count', 1, fields
        count: --count

  fields = {}
  fields[field] = 1 for field in crudastro.data[collectionName].table
  cursor = crudastro.collections[collectionName].find queryBase,
    fields: fields
    limit: pagination.limit
    skip: (pagination.page) * pagination.limit
    sort: sort
  handle = cursor.observeChanges
    added: (id, fields) =>
      @added collectionName + 'Page', id, fields
    changed: (id, fields) =>
      @changed collectionName + 'Page', id, fields
    removed: (id, fields) =>
      @removed collectionName + 'Page', id, fields
  @ready()
  @onStop =>
    handle.stop()
    countHandle.stop()

Meteor.publish "crudastroDocument", (collectionName, documentId) ->
  #Meteor._sleepForMs(2000)
  #TODO: Only fields from object definition
  crudastro.collections[collectionName].find
    _id: documentId
