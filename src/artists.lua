local artists = {
  ["KingOfThe-X-Roads"] = { display_name = 'KingOfThe-X-Roads' }
}

local poke_get_artist_info_ref = poke_get_artist_info
poke_get_artist_info = function(name)
  return artists[name] or poke_get_artist_info_ref(name)
end
