require 'net/https'

class Texter
	ACCOUNT_NUMBER = '7756575726'
	API_KEY = '049d2b1dd2d87936814325c80db9b9ee41363785'
  
	def self.add_contact(username, phone_number)
		data = {name: username, number: phone_number}
		uri = URI.parse("https://api.sendhub.com/v1/contacts/?username=#{ACCOUNT_NUMBER}\&api_key=#{API_KEY}")
		req = Net::HTTP::Post.new(uri.request_uri)
		req.add_field("Content-Type","application/json")
		req.body = data.to_json

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		res = http.request(req)

		return res
	end
	
  def self.edit_contact(username, phone_number, sendhub_id)
    data = {id: sendhub_id, name: username, number: phone_number}
    uri = URI.parse("https://api.sendhub.com/v1/contacts/#{sendhub_id}/?username=#{ACCOUNT_NUMBER}\&api_key=#{API_KEY}")
    req = Net::HTTP::Put.new(uri.request_uri)
    req.add_field("Content-Type","application/json")
    req.body = data.to_json
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    return res
  end
  
 
  def self.delete_contact(sendhub_id)
    #data = {id: sendhub_id, name: username, number: phone_number}
    uri = URI.parse("https://api.sendhub.com/v1/contacts/#{sendhub_id}/?username=#{ACCOUNT_NUMBER}\&api_key=#{API_KEY}")
    req = Net::HTTP::Delete.new(uri.request_uri)
    req.add_field("Content-Type","application/json")
    #req.body = data.to_json
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    return res
  end

	def self.send_text(sendhub_id, content)
		data = {contacts: [sendhub_id], text: content}

		uri = URI.parse("https://api.sendhub.com/v1/messages/?username=#{ACCOUNT_NUMBER}\&api_key=#{API_KEY}")
		req = Net::HTTP::Post.new(uri.request_uri)
		req.add_field("Content-Type","application/json")
		req.body = data.to_json

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		res = http.request(req)

		return res
	end

	def self.schedule_text(sendhub_id, content, time_ahead)
		timestamp = translate_to_UTC(time_ahead)
		data = {contacts: [sendhub_id], text: content, scheduled_at: timestamp}

		uri = URI.parse("https://api.sendhub.com/v1/messages/?username=#{ACCOUNT_NUMBER}\&api_key=#{API_KEY}")
		req = Net::HTTP::Post.new(uri.request_uri)
		req.add_field("Content-Type","application/json")
		req.body = data.to_json

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		res = http.request(req)

		return res
	end

	def self.translate_to_UTC(time_ahead)
		present = Time.now.gmtime
		future = present + time_ahead.to_i
		timestamp = future.strftime("%Y-%m-%dT%H:%M:%S-0000")
	end

end
