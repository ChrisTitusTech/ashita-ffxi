addon.name      = 'allseeingeye';
addon.author    = 'christitustech';
addon.version   = '1.0';
addon.desc      = 'Mandatory Mythic addon for turns and Empy farms.';
addon.link      = 'https://ashitaxi.com/';

require('common');

ashita.events.register('packet_in', 'packet_in_cb', function (e)
	-- Check if this is packet ID 14
	if (e.id == 0x14) then
		local status = struct.unpack('B', e.data_modified, 0x21 + 1); -- +1 for Lua 1-based indexing
		
		-- Check if status matches our conditions (2, 6, or 7)
		if (status == 2 or status == 6 or status == 7) then
			-- Create modified packet by inserting '0' at specific positions
			local packet = e.data_modified:sub(1, 32) .. 
						  string.char(0) .. 
						  e.data_modified:sub(34, 34) .. 
						  string.char(0) .. 
						  e.data_modified:sub(36, 41) .. 
						  string.char(0) .. 
						  e.data_modified:sub(43);
			
			e.data_modified = packet;
			return true;
		end
	end
	
	return false;
end);