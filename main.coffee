crudastro
  posts:
    fields: [
      name: 'title'
      type: 'text'
      validations:
        required: true
    ,
      name: 'content'
      type: 'text'
      validations:
        required: true
    ]
    table: ['title']
  tags:
    fields: [
      name: 'title'
      type: 'text'
    ]
    table: ['title']