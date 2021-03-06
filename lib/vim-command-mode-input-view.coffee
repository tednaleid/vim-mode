{View, EditorView} = require 'atom'

module.exports =

class VimCommandModeInputView extends View
  @content: ->
    @div class: 'command-mode-input', =>
      @div class: 'editor-container', outlet: 'editorContainer', =>
        @subview 'editor', new EditorView(mini: true)

  initialize: (@viewModel, opts = {})->
    @editor.setFontSize(atom.config.get('vim-mode.commandModeInputViewFontSize'))

    if opts.class?
      @editorContainer.addClass opts.class

    unless atom.workspaceView?
      # We're in test mode. Don't append to anything, just initialize.
      @focus()
      @handleEvents()
      return

    statusBar = atom.workspaceView.find('.status-bar')

    if statusBar.length > 0
      @.insertBefore(statusBar)
    else
      atom.workspace.getActivePane().append(@)

    @focus()
    @handleEvents()

  handleEvents: ->
    @editor.on 'core:confirm', @confirm
    @editor.on 'core:cancel', @remove
    @editor.find('input').on 'blur', @remove

  confirm: =>
    @value = @editor.getText()
    @viewModel.confirm(@)
    @remove()

  focus: =>
    @editorContainer.find('.editor').focus()

  remove: =>
    atom.workspaceView.focus() if atom.workspaceView?
    super()
