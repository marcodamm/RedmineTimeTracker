###*
 The class for handling desktop notification.
 @class
###
class TimerNotification

  ###*
   Notification default options.
  ###
  DEFAULT_OPTION:
    type:        "list"
    iconUrl:     "/images/icon_notification.png"
    title:       "Tracking finished"
    isClickable: true

  # HTTP status on send success.
  STATUS_OK: 200
  STATUS_CREATED: 201


  ###*
   Constructor.
   @constructor
  ###
  constructor: (@_Platform) ->
    @_Platform.notifications.addOnClickedListener (notificationId) =>
      @_Platform.notifications.clear(notificationId)
      @_Platform.showAppWindow()


  ###*
   On time entry was send, show desktop notification.
   @param {Object} RTT - Interface to communicate with app.
   @param {Object} timeEntry - Send time entry.
   @param {Number} status - Send result.
   @param {Object} ticket - Tracked ticket.
   @param {String} mode - Tracking mode.
  ###
  onSendedTimeEntry: (RTT, timeEntry, status, ticket, mode) =>
    return if mode isnt "pomodoro"
    options = Object.merge(@DEFAULT_OPTION, {})
    options.message = "Pomodoro finished." # will be ignored by chrome

    if (status is @STATUS_OK) or (status is @STATUS_CREATED)
      options.items = [
        { title: "Ticket",   message: ticket.text }
        { title: "Hours",    message: util.formatMinutes(timeEntry.hours * 60) }
        { title: "Activity", message: timeEntry.activity.name }
      ]
    else
      options.title = "Sending failed..."
      options.items = [
        { title: "Ticket",      message: ticket.text }
        { title: "Hours",       message: util.formatMinutes(timeEntry.hours * 60) }
        { title: "HTTP STATUS", message: status }
      ]

    @_Platform.notifications.create(null, options)


if RTT?
  # Register this plugin.
  RTT.registerPlugin("TimerNotification", TimerNotification)
