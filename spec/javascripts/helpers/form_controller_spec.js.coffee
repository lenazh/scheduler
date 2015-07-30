describe 'FormController', ->
  form = {}
  resource = {}
  fields = []

  beforeEach ->
    fields = ['name', 'age', 'price'] # Pets resource
    resource = {
      all: -> null
      remove: (resource) -> null
      saveNew: (params) -> null
      update: (resource, params) -> null
    }

    spyOn(resource, 'all')
    spyOn(resource, 'remove')
    spyOn(resource, 'saveNew')
    spyOn(resource, 'update')

    form = new schedulerApp.FormController(resource, fields)

  it "calls resource.all() while initializing", ->
    expect(resource.all).toHaveBeenCalled()

  it 'sets form.resource to the one provided when instantiated', ->
    expect(form.resource).toBe resource

  it 'initialized the fields to empty strings', ->
    for field in fields
      expect(form.fields[field]).toEqual ''

  describe 'remove(record)', ->
    it 'passes record to resource', ->
      record = { 'id': 3, 'name': 'Fluffy', 'age': 2, 'price': 20 }
      form.remove(record)
      expect(resource.remove).toHaveBeenCalledWith(record)

  describe 'update()', ->
    params = {}
    record = {}

    beforeEach ->
      params = { 'name': 'Bubbles', 'age': 8, 'price': 20}
      record = { 'id': 4, 'name': 'Beans', 'age': 7, 'price': 20 }
      form.resourceToUpdate = record
      form.fields.name = params.name
      form.fields.age = params.age
      form.fields.price = params.price

    it 'passes form.resourceToUpdate and form fields to resource', ->
      form.update()
      expect(resource.update).toHaveBeenCalledWith(record, params)

    it 'calls form.addForm()', ->
      spyOn(form, 'addForm')
      form.update()
      expect(form.addForm).toHaveBeenCalled()

  describe 'editForm(record)', ->
    record = {}

    beforeEach ->
      record = { 'id': 9, 'name': 'Mimimi', 'age': 1, 'price': 5000 }
    
    it 'sets form.resourceToUpdate = record', ->
      form.editForm(record)
      expect(form.resourceToUpdate).toBe record

    it 'populates the fields from record', ->
      form.editForm(record)
      for field in fields
        expect(form.fields[field]).toEqual record[field]

    it 'switches the form to Edit mode', ->
      form.hideAddButton = false
      form.hideUpdateButton = true
      form.disableEditingAndDeletion = false

      form.editForm(record)
      expect(form.hideAddButton).toEqual true
      expect(form.hideUpdateButton).toEqual false
      expect(form.disableEditingAndDeletion).toEqual true

  describe 'addForm()', ->
    it 'sets the fields to empty strings', ->
      for field in fields
        expect(form.fields[field]).toEqual ''

    it 'switches the form to Add mode', ->
      form.hideAddButton = true
      form.hideUpdateButton = false
      form.disableEditingAndDeletion = true

      form.addForm()
      expect(form.hideAddButton).toEqual false
      expect(form.hideUpdateButton).toEqual true
      expect(form.disableEditingAndDeletion).toEqual false