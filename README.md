# crudastro
Magic CRUD on Meteor


define your crudastro in main.coffee...

---
```coffeescript
crudastro

  companies:
    icon: 'building-o'
    fields: [
      name: 'name'
      type: 'text'
      validations:
        required: true
    ,
      name: 'phone'
      type: 'text'
    ]
    table: ['name', 'phone']

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


```
---
and the magic will happen

## next steps
- [x] pagination
- [x] filter
- [x] sorting
- [ ] validations
- [ ] input types
  - [ ] select
  - [ ] checkbox
  - [ ] date
  - [ ] time
  - [ ] money
  - [ ] number
- [ ] associations
  - [ ] belongs to
  - [ ] has many
    - [ ] checkboxes
    - [ ] tags input
- [ ] mobile friendly
- [ ] user authorization
