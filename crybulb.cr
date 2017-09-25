require "socket"

# message = %({"smartlife.iot.smartbulb.lightingservice":{"transition_light_state":{"ignore_default":1,"on_off":1,"transition_period":2}}})
message = %({"system": {"get_sysinfo": {}}})

send(message)

def send(msg : String)
	sock = Socket.udp(Socket::Family::INET)
	sock.connect("192.168.1.8", 9999)

	encmsg = encrypt(msg)
	
	sock.send(encmsg)

	response = Bytes.new(1500)
	sock.read(response)
	puts String.new(decrypt(response))
end

def encrypt(msg : String)
	data = IO::Memory.new(msg)

	mbytes = data.buffer.to_slice(data.bytesize)
	cbytes = Slice(UInt8).new(mbytes.bytesize)
	key = UInt8.new(171)

	mbytes.each_with_index do |value,index|
		ph = value
		cbytes[index] = ph ^ key
		key = cbytes[index]
	end
	return cbytes
end

def decrypt(msg : Slice(UInt8))
	dbytes = Slice(UInt8).new(msg.bytesize)
	key = UInt8.new(171)

	msg.each_with_index do |value,index|
		ph = value
		dbytes[index] = ph ^ key
		key = ph
	end
	return dbytes
end