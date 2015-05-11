crudastro

  companies:
    icon: 'building-o'
    fields: [
      name: 'name'
      type: 'text'
      validations:
        required: true
    ,
      name: 'phon'
      type: 'text'
      validations:
        required: true
    ]
    table: ['name', 'phon']

  contacts:
    icon: 'users'
    fields: [
      name: 'name'
      type: 'text'
    ,
      name: 'phone'
      type: 'text'
    ]
    table: ['name']
