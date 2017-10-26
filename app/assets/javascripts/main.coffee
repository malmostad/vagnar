$ ->
  $('body.login #username').focus()

  # Datepicker
  add_calendar = () ->
    $('input.date').datepicker
      weekStart: 1
      language: 'sv'
      autoclose: true
      todayHighlight: true
      todayBtn: true
      orientation: 'auto'
      keyboardNavigation: false

  add_calendar()
