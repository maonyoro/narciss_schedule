$ ->
  $('#calendar').fullCalendar({
    events: '/json',
    firstDay: 1,
    timezone: "Asia/Tokyo",
    eventLimitText: "+2",
    eventTextColor: "#000000",
    eventBackgroundColor: "#ffdddd",
    eventBorderColor: "#ffcccc",
  })

  $(document).on 'click', '.open-modal', ->
    console.log 'clicked'
    $('#modalwindow').modal({
    })

