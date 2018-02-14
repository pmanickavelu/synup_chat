require 'uri'
require 'net/http'
require 'json'

class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"
  end
  def receive(data)
    ActionCable.server.broadcast("chat_#{params[:room]}", {body:data["body"]})
    url = URI("http://stage-chatbot-botservice.chatbot.internal.synup.com/locations/43/conversations/1")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request.body = "{\"query\": \"#{data["body"]}\"}"
    response = http.request(request)
    read_body = JSON.parse(response.read_body)
    ActionCable.server.broadcast("chat_#{params[:room]}", {message:read_body["result"]})
  end
end


