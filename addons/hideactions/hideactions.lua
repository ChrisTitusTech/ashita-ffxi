if AshitaCore then
    require('ashita4');
elseif ashita then
    print('Ashita 3 is not supported.');
elseif windower then
    require('windower4');
else
    print('Could not detect platform.');
end