class FormController
  resource: {}
  fields: {}
  resourceToUpdate: {}
  all: {}

  hideAddButton: false
  hideUpdateButton: true
  disableEditingAndDeletion: false

  constructor: (resource, fields) ->
    @all = resource.all()
    @resource = resource
    for field in fields
      @fields[field] = ''

  form_is_valid: () ->
    true

  remove: (resourceToRemove) -> 
    @resource.remove resourceToRemove

  saveNew: () ->
    return unless @form_is_valid
    @resource.saveNew @params()
    @emptyFields()

  update: () ->
    return unless @form_is_valid
    @resource.update @resourceToUpdate, @params()
    @addForm()

  editForm: (resource) ->
    @resourceToUpdate = resource
    @populateFields(resource)
    @editMode()

  addForm: () ->
    @emptyFields()
    @addMode()

  # (imaginary) private methods

  params: () ->
    result = {}
    for field in Object.keys(@fields)
      result[field] = @fields[field]
    result

  emptyFields: () ->
    for field in Object.keys(@fields)
      @fields[field] = ''

  populateFields: (resource) ->
    for field in Object.keys(@fields)
      @fields[field] = resource[field]

  editMode: () ->
    @hideAddButton = true
    @hideUpdateButton = false
    @disableEditingAndDeletion = true

  addMode: () ->
    @hideAddButton = false
    @hideUpdateButton = true
    @disableEditingAndDeletion = false

schedulerApp.FormController = FormController