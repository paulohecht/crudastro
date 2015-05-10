Template.registerHelper 'crudastroCollections', ->
	_.map crudastro.data, (value, key) -> _.defaults value, name: key
