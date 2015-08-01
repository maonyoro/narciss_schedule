$ ->
  $('#calendar').fullCalendar({
    events: '/json',
    firstDay: 1,
    timezone: "Asia/Tokyo",
    eventLimitText: "+2",
  })

  $(document).on 'click', '.open-modal', (e) ->
    console.log 'clicked'
    e.preventDefault()

    #console.log $(@)
    $.ajax
      type: 'GET',
      dataType: 'text',
      url: $(@).attr('href'),
    .done (results) ->
      console.log results
      #$(results).appendTo('body').modal()
      $('#modalwindow').append(results).modal({
      })
    .fail (jqXHR, textStatus, errorThrown) ->
      console.log 'ajax error.'

  # when modal-window is closed
  $(".modal").on $.modal.CLOSE, ->
    console.log 'close!'
    $('#modalwindow').empty()
