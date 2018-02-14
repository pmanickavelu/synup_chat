# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
save_to_chat_session_data = (msg)->
  s = read_from_chat_session_data()
  s.push(msg)
  localStorage["chat_session_data"] = JSON.stringify(s)
read_from_chat_session_data = ()->
  JSON.parse(localStorage["chat_session_data"])
ready = ()->
  if localStorage["chat_session_id"] is undefined
    localStorage["chat_session_id"] = Math.random().toString(36).substr(2);
  if localStorage["chat_session_data"] is undefined
    localStorage["chat_session_data"] = "[]"

  App.chatChannel = App.cable.subscriptions.create { channel: "ChatChannel", room: localStorage["chat_session_id"] },
  received: (data) ->
    if data.message
      $("#chat_body").append($("<p>").html("Bot:" + data.message))
      save_to_chat_session_data("Bot:"+data.message)
    if data.body
      $("#chat_body").append($("<p>").html("User:" + data.body))
      save_to_chat_session_data("User:"+data.body)
    return true
  $("#send_message_button").click ()->
    App.chatChannel.send({ body: $("#chat_msg").val() })
    $("#chat_msg").val("")
    return true
  for sentence in read_from_chat_session_data()
    $("#chat_body").append ($("<p>").html(sentence))
$(document).ready ready
