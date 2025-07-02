local status_table = {}

--[[
Some spell IDs do not match up with their status effect ID, or are not recorded as
inflicting a status effect normally. This map allows manual translation of certain
spells to their status effect.
]]
status_table.SPELL_TO_STATUS_MAP = T({
  -- Enfeebling Magic
  [230] = 135, -- Bio
  [231] = 135, -- Bio II
  [232] = 135, -- Bio III
  [23] = 134, -- Dia
  [24] = 134, -- Dia II
  [25] = 134, -- Dia III
  [33] = 134, -- Diaga
  [58] = 4, -- Paralyze
  [80] = 4, -- Paralyze II
  [56] = 13, -- Slow
  [79] = 13, -- Slow II
  [357] = 13, -- Slowga
  [216] = 12, -- Gravity
  [217] = 12, -- Gravity II
  [254] = 5, -- Blind
  [276] = 5, -- Blind II
  [361] = 5, -- Blindga
  [59] = 6, -- Silence
  [359] = 6, -- Silencega
  [253] = 2, -- Sleep
  [259] = 2, -- Sleep II
  [273] = 2, -- Sleepga
  [274] = 2, -- Sleepga II
  [258] = 11, -- Bind
  [362] = 11, -- Bindga
  [220] = 3, -- Poison
  [221] = 3, -- Poison II
  [222] = 3, -- Poison III
  [223] = 3, -- Poison IV
  [224] = 3, -- Poison V
  [225] = 3, -- Poisonga
  [226] = 3, -- Poisonga II
  [227] = 3, -- Poisonga III
  [228] = 3, -- Poisonga IV
  [229] = 3, -- Poisonga V
  [255] = 7, -- Break
  [365] = 7, -- Breakga
  [286] = 21, -- Addle
  [884] = 21, -- Addle II
  [841] = 148, -- Distract
  [842] = 148, -- Distract II
  [882] = 148, -- Distract III
  [843] = 404, -- Frazzle
  [844] = 404, -- Frazzle II
  [883] = 404, -- Frazzle III
  [879] = 597, -- Inundation
  -- Dark Magic
  [252] = 10, -- Stun
  -- Divine Magic
  [98] = 2, -- Repose
  [112] = 156, -- Flash
  -- Elemental Magic
  [239] = 132, -- Shock
  [238] = 131, -- Rasp
  [237] = 130, -- Choke
  [236] = 129, -- Frost
  [235] = 128, -- Burn
  [240] = 133, -- Drown
  [278] = 186, -- Geohelix
  [279] = 186, -- Hydrohelix
  [280] = 186, -- Anemohelix
  [281] = 186, -- Pyrohelix
  [282] = 186, -- Cryohelix
  [283] = 186, -- Ionohelix
  [284] = 186, -- Noctohelix
  [285] = 186, -- Luminohelix
  [502] = 23, -- Kaustra
  [503] = { 136, 137, 138, 139, 140, 141, 142 }, -- Impact
  [885] = 186, -- Geohelix II
  [886] = 186, -- Hydrohelix II
  [887] = 186, -- Anemohelix II
  [888] = 186, -- Pyrohelix II
  [889] = 186, -- Cryohelix II
  [890] = 186, -- Ionohelix II
  [891] = 186, -- Noctohelix II
  [892] = 186, -- Luminohelix II
  -- Enhancing Magic
  [43] = 40, -- Protect
  [44] = 40, -- Protect II
  [45] = 40, -- Protect III
  [46] = 40, -- Protect IV
  [47] = 40, -- Protect V
  [48] = 41, -- Shell
  [49] = 41, -- Shell II
  [50] = 41, -- Shell III
  [51] = 41, -- Shell IV
  [52] = 41, -- Shell V
  [53] = 36, -- Blink
  [54] = 37, -- Stoneskin
  [55] = 39, -- Aquaveil
  [57] = 33, -- Haste
  [60] = 100, -- Barfire
  [61] = 101, -- Barblizzard
  [62] = 102, -- Baraero
  [63] = 103, -- Barstone
  [64] = 104, -- Barthunder
  [65] = 105, -- Barwater
  [66] = 100, -- Barfira
  [67] = 101, -- Barblizzara
  [68] = 102, -- Baraera
  [69] = 103, -- Barstonra
  [70] = 104, -- Barthundra
  [71] = 105, -- Barwatera
  [72] = 106, -- Barsleep
  [73] = 107, -- Barpoison
  [74] = 108, -- Barparalyze
  [75] = 109, -- Barblind
  [76] = 110, -- Barsilence
  [77] = 111, -- Barpetrify
  [78] = 112, -- Barvirus
  [84] = 286, -- Baramnesia
  [85] = 286, -- Baramnesra
  [86] = 106, -- Barsleepra
  [87] = 107, -- Barpoisonra
  [88] = 108, -- Barparalyzra
  [89] = 109, -- Barblindra
  [90] = 110, -- Barsilencera
  [91] = 111, -- Barpetra
  [92] = 112, -- Barvira
  [96] = 275, -- Auspice
  [97] = 403, -- Reprisal
  [99] = 592, -- Sandstorm
  [100] = 94, -- Enfire
  [101] = 95, -- Enblizzard
  [102] = 96, -- Enaero
  [103] = 97, -- Enstone
  [104] = 98, -- Enthunder
  [105] = 99, -- Enwater
  [106] = 116, -- Phalanx
  [107] = 116, -- Phalanx II
  [108] = 42, -- Regen
  [109] = 43, -- Refresh
  [110] = 42, -- Regen II
  [111] = 42, -- Regen III
  [113] = 183, -- Rainstorm
  [114] = 180, -- Windstorm
  [115] = 178, -- Firestorm
  [116] = 179, -- Hailstorm
  [117] = 182, -- Thunderstorm
  [118] = 185, -- Voidstorm
  [119] = 184, -- Aurorastorm
  [125] = 40, -- Protectra
  [126] = 40, -- Protectra II
  [127] = 40, -- Protectra III
  [128] = 40, -- Protectra IV
  [129] = 40, -- Protectra V
  [130] = 41, -- Shellra
  [131] = 41, -- Shellra II
  [132] = 41, -- Shellra III
  [133] = 41, -- Shellra IV
  [134] = 41, -- Shellra V
  [136] = 69, -- Invisible
  [137] = 71, -- Sneak
  [138] = 70, -- Deodorize
  [249] = 34, -- Blaze Spikes
  [250] = 35, -- Ice Spikes
  [251] = 38, -- Shock Spikes
  [308] = 289, -- Animus Augeo
  [309] = 291, -- Animus Minuo
  [312] = 277, -- Enfire II
  [313] = 278, -- Enblizzard II
  [314] = 279, -- Enaero II
  [315] = 280, -- Enstone II
  [316] = 281, -- Enthunder II
  [317] = 282, -- Enwater II
  [473] = 43, -- Refresh II
  [476] = 289, -- Crusade
  [477] = 42, -- Regen IV
  [478] = 228, -- Embrava
  [479] = 119, -- Boost-STR
  [480] = 120, -- Boost-DEX
  [481] = 121, -- Boost-VIT
  [482] = 122, -- Boost-AGI
  [483] = 123, -- Boost-INT
  [484] = 124, -- Boost-MND
  [485] = 125, -- Boost-CHR
  [486] = 119, -- Gain-STR
  [487] = 120, -- Gain-DEX
  [488] = 121, -- Gain-VIT
  [489] = 122, -- Gain-AGI
  [490] = 123, -- Gain-INT
  [491] = 124, -- Gain-MND
  [492] = 125, -- Gain-CHR
  [493] = 432, -- Temper
  [495] = 170, -- Adloquium
  [504] = 42, -- Regen V
  [511] = 33, -- Haste II
  [840] = 568, -- Foil
  [845] = 265, -- Flurry
  [846] = 265, -- Flurry II
  [857] = 592, -- Sandstorm II
  [858] = 594, -- Rainstorm II
  [859] = 591, -- Windstorm II
  [860] = 589, -- Firestorm II
  [861] = 590, -- Hailstorm II
  [862] = 593, -- Thunderstorm II
  [863] = 596, -- Voidstorm II
  [864] = 595, -- Aurorastorm II
  [894] = 43, -- Refresh III
  [895] = 432, -- Temper II

  -- Blue Magic
  [517] = 37, -- Metallic Body
  [530] = 33, -- Refueling
  [538] = 190, -- Memento Mori
  [547] = 93, -- Cocoon
  [574] = 92, -- Feather Barrier
  [613] = 35, -- Reactor Cool
  [614] = 191, -- Saline Coat
  [615] = 38, -- Plasma Charge
  [632] = 37, -- Diamondhide
  [636] = 90, -- Warm-Up
  [642] = 190, -- Amplification
  [647] = 36, -- Zephyr Mantle
  [655] = 91, -- Triumphant Roar
  [658] = 91, -- Plenilune Embrace
  [661] = 33, -- Animating Wail
  [662] = 43, -- Battery Charge
  [664] = 42, -- Regeneration
  [668] = 152, -- Magic Barrier
  [674] = 45, -- Fantod
  [679] = 36, -- Occultation
  [685] = 116, -- Barrier Tusk
  [696] = 486, -- O. Counterstance
  [700] = 91, -- Nat. Meditation
  [710] = 33, -- Erratic Flutter
  [737] = 93, -- Harden Shell
  [741] = 150, -- Pyric Bulwark
  [745] = 91, -- Carcharian Verve
  [750] = 604, -- Mighty Guard
  -- Commented out because their exact status effects are unknown and there is
  -- no way to currently verify that a blue magic status has been inflicted
  -- through packet inspection (the server doesn't tell us).
  --[[
  [513] = 0,    -- Venom Shell
  [515] = 0,    -- Maelstrom
  [524] = 0,    -- Sandspin
  [531] = 0,    -- Ice Break
  [532] = 0,    -- Blitzstrahl
  [534] = 0,    -- Mysterious Light
  [535] = 0,    -- Cold Wave
  [536] = 0,    -- Poison Breath
  [537] = 0,    -- Stinking Gas
  [539] = 0,    -- Terror Touch
  [548] = 0,    -- Filamented Hold
  [555] = 0,    -- Magnetite Cloud
  [561] = 0,    -- Frightful Roar
  [563] = 0,    -- Hecatomb Wave
  [565] = 0,    -- Radiant Breath
  [572] = 0,    -- Sound Blast
  [573] = 0,    -- Feather Tickle
  [575] = 0,    -- Jettatura
  [576] = 0,    -- Yawn
  [582] = 0,    -- Chaotic Eye
  [584] = 0,    -- Sheep Song
  [588] = 0,    -- Lowing
  [596] = 0,    -- Pinecone Bomb
  [597] = 0,    -- Sprout Smack
  [598] = 0,    -- Soporific
  [599] = 0,    -- Queasyshroom
  [603] = 0,    -- Wild Oats
  [604] = 0,    -- Bad Breath
  [606] = 0,    -- Awful Eye
  [608] = 0,    -- Frost Breath
  [610] = 0,    -- Infrasonics
  [611] = 0,    -- Disseverment
  [612] = 0,    -- Actinic Burst
  [616] = 0,    -- Temporal Shift
  [618] = 0,    -- Blastbomb
  [620] = 0,    -- Battle Dance
  [621] = 0,    -- Sandspray
  [623] = 0,    -- Head Butt
  [628] = 0,    -- Frypan
  [631] = 0,    -- Hydro Shot
  [633] = 0,    -- Enervation
  [634] = 0,    -- Light of Penance
  [638] = 0,    -- Feather Storm
  [640] = 0,    -- Tail Slap
  [644] = 0,    -- Mind Blast
  [648] = 0,    -- Regurgitation
  [650] = 0,    -- Seedspray
  [651] = 0,    -- Corrosive Ooze
  [652] = 0,    -- Spiral Spin
  [654] = 0,    -- Sub-zero Smash
  [656] = 0,    -- Acrid Stream
  [659] = 0,    -- Demoralizing Roar
  [660] = 0,    -- Cimicine Discharge
  [669] = 0,    -- Whirl of Rage
  [670] = 0,    -- Benthic Typhoon
  [671] = 0,    -- Auroral Drape
  [675] = 0,    -- Thermal Pulse
  [678] = 0,    -- Dream Flower
  [682] = 0,    -- Delta Thrust
  [686] = 0,    -- Mortal Ray
  [687] = 0,    -- Water Bomb
  [692] = 0,    -- Sudden Lunge
  [699] = 0,    -- Barbed Crescent
  [703] = 0,    -- Embalming Earth
  [704] = 0,    -- Paralyzing Triad
  [705] = 0,    -- Foul Waters
  [707] = 0,    -- Retinal Glare
  [708] = 0,    -- Subduction
  [716] = 0,    -- Nectarous Deluge
  [717] = 0,    -- Sweeping Gouge
  [719] = 0,    -- Searing Tempest
  [720] = 0,    -- Spectral Floe
  [721] = 0,    -- Anvil Lightning
  [722] = 0,    -- Entomb
  [723] = 0,    -- Saurian Slide
  [724] = 0,    -- Palling Salvo
  [725] = 0,    -- Blinding Fulgor
  [726] = 0,    -- Scouring Spate
  [727] = 0,    -- Silent Storm
  [728] = 0,    -- Tenebral Crush
  [736] = 0,    -- Thunderbolt
  [738] = 0,    -- Absolute Terror
  [739] = 0,    -- Gates of Hades
  [740] = 0,    -- Tourbillion
  [742] = 0,    -- Bilgestorm
  [743] = 0,    -- Bloodrake
  [746] = 0,    -- Blistering Roar
  [749] = 0,    -- Polar Roar
  [751] = 0,    -- Cruel Joke
  [752] = 0,    -- Cesspool
  [753] = 0,    -- Tearing Gust
]]
  -- Songs
  [368] = 192, -- Foe Requiem
  [369] = 192, -- Foe Requiem II
  [370] = 192, -- Foe Requiem III
  [371] = 192, -- Foe Requiem IV
  [372] = 192, -- Foe Requiem V
  [373] = 192, -- Foe Requiem VI
  [374] = 192, -- Foe Requiem VII
  [376] = 2, -- Horde Lullaby
  [377] = 2, -- Horde Lullaby II
  [378] = 195, -- Army's Paeon
  [379] = 195, -- Army's Paeon II
  [380] = 195, -- Army's Paeon III
  [381] = 195, -- Army's Paeon IV
  [382] = 195, -- Army's Paeon V
  [383] = 195, -- Army's Paeon VI
  [384] = 195, -- Army's Paeon VII
  [385] = 195, -- Army's Paeon VIII
  [386] = 196, -- Mage's Ballad
  [387] = 196, -- Mage's Ballad II
  [388] = 196, -- Mage's Ballad III
  [389] = 197, -- Knight's Minne
  [390] = 197, -- Knight's Minne II
  [391] = 197, -- Knight's Minne III
  [392] = 197, -- Knight's Minne IV
  [393] = 197, -- Knight's Minne V
  [394] = 198, -- Valor Minuet
  [395] = 198, -- Valor Minuet II
  [396] = 198, -- Valor Minuet III
  [397] = 198, -- Valor Minuet IV
  [398] = 198, -- Valor Minuet V
  [399] = 199, -- Sword Madrigal
  [400] = 199, -- Blade Madrigal
  [401] = 200, -- Hunter's Prelude
  [402] = 200, -- Archer's Prelude
  [403] = 201, -- Sheepfoe Mambo
  [404] = 201, -- Dragonfoe Mambo
  [405] = 202, -- Fowl Aubade
  [406] = 203, -- Herb Pastoral
  [407] = 204, -- Chocobo Hum
  [408] = 205, -- Shining Fantasia
  [409] = 206, -- Scop's Operetta
  [410] = 206, -- Puppet's Operetta
  [411] = 206, -- Jester's Operetta
  [412] = 207, -- Gold Capriccio
  [413] = 208, -- Devotee Serenade
  [414] = 209, -- Warding Round
  [415] = 210, -- Goblin Gavotte
  [416] = 211, -- Cactuar Fugue
  [417] = 214, -- Honor March
  [418] = 213, -- Protected Aria
  [419] = 214, -- Advancing March
  [420] = 214, -- Victory March
  [421] = 194, -- Battlefield Elegy
  [422] = 194, -- Carnage Elegy
  [424] = 215, -- Sinewy Etude
  [425] = 215, -- Dextrous Etude
  [426] = 215, -- Vivacious Etude
  [427] = 215, -- Quick Etude
  [428] = 215, -- Learned Etude
  [429] = 215, -- Spirited Etude
  [430] = 215, -- Enchanting Etude
  [431] = 215, -- Herculean Etude
  [432] = 215, -- Uncanny Etude
  [433] = 215, -- Vital Etude
  [434] = 215, -- Swift Etude
  [435] = 215, -- Sage Etude
  [436] = 215, -- Logical Etude
  [437] = 215, -- Bewitching Etude
  [438] = 216, -- Fire Carol
  [439] = 216, -- Ice Carol
  [440] = 216, -- Wind Carol
  [441] = 216, -- Earth Carol
  [442] = 216, -- Lightning Carol
  [443] = 216, -- Water Carol
  [444] = 216, -- Light Carol
  [445] = 216, -- Dark Carol
  [446] = 216, -- Fire Carol II
  [447] = 216, -- Ice Carol II
  [448] = 216, -- Wind Carol II
  [449] = 216, -- Earth Carol II
  [450] = 216, -- Lightning Carol II
  [451] = 216, -- Water Carol II
  [452] = 216, -- Light Carol II
  [453] = 216, -- Dark Carol II
  [454] = 217, -- Fire Threnody
  [455] = 217, -- Ice Threnody
  [456] = 217, -- Wind Threnody
  [457] = 217, -- Earth Threnody
  [458] = 217, -- Ltng. Threnody
  [459] = 217, -- Water Threnody
  [460] = 217, -- Light Threnody
  [461] = 217, -- Dark Threnody
  [463] = 2, -- Foe Lullaby
  [464] = 218, -- Goddess's Hymnus
  [465] = 219, -- Chocobo Mazurka
  [466] = 17, -- Maiden's Virelai
  [467] = 219, -- Raptor Mazurka
  [468] = 220, -- Foe Sirvente
  [469] = 221, -- Adventurer's Dirge
  [470] = 222, -- Sentinel's Scherzo
  [471] = 2, -- Foe Lullaby II
  [472] = 223, -- Pining Nocturne
  [871] = 217, -- Fire Threnody II
  [872] = 217, -- Ice Threnody II
  [873] = 217, -- Wind Threnody II
  [874] = 217, -- Earth Threnody II
  [875] = 217, -- Ltng. Threnody II
  [876] = 217, -- Water Threnody II
  [877] = 217, -- Light Threnody II
  [878] = 217, -- Dark Threnody II
})

status_table.STATUS_FLAGS = T({
  [32] = { Dispellable = true }, -- Flee
  [33] = { Dispellable = true }, -- Haste
  [34] = { Dispellable = true }, -- Blaze Spikes
  [35] = { Dispellable = true }, -- Ice Spikes
  [36] = { Dispellable = true }, -- Blink
  [37] = { Dispellable = true }, -- Stoneskin
  [38] = { Dispellable = true }, -- Shock Spikes
  [39] = { Dispellable = true }, -- Aquaveil
  [40] = { Dispellable = true }, -- Protect
  [41] = { Dispellable = true }, -- Shell
  [42] = { Dispellable = true }, -- Regen
  [43] = { Dispellable = true }, -- Refresh
  [56] = { Dispellable = true }, -- Berserk
  [68] = { Dispellable = true }, -- Warcry
  [69] = { Dispellable = true }, -- Invisible
  [70] = { Dispellable = true }, -- Sneak
  [71] = { Dispellable = true }, -- Deodorize
  [80] = { Dispellable = true }, -- STR Boost
  [81] = { Dispellable = true }, -- DEX Boost
  [82] = { Dispellable = true }, -- VIT Boost
  [83] = { Dispellable = true }, -- AGI Boost
  [84] = { Dispellable = true }, -- INT Boost
  [85] = { Dispellable = true }, -- MND Boost
  [86] = { Dispellable = true }, -- CHR Boost
  [88] = { Dispellable = true }, -- Max HP Boost
  [89] = { Dispellable = true }, -- Max MP Boost
  [90] = { Dispellable = true }, -- Accuracy Boost
  [91] = { Dispellable = true }, -- Attack Boost
  [92] = { Dispellable = true }, -- Evasion Boost
  [93] = { Dispellable = true }, -- Defense Boost
  [94] = { Dispellable = true }, -- Enfire
  [95] = { Dispellable = true }, -- Enblizzard
  [96] = { Dispellable = true }, -- Enaero
  [97] = { Dispellable = true }, -- Enstone
  [98] = { Dispellable = true }, -- Enthunder
  [99] = { Dispellable = true }, -- Enwater
  [100] = { Dispellable = true }, -- Barfire
  [101] = { Dispellable = true }, -- Barblizzard
  [102] = { Dispellable = true }, -- Baraero
  [103] = { Dispellable = true }, -- Barstone
  [104] = { Dispellable = true }, -- Barthunder
  [105] = { Dispellable = true }, -- Barwater
  [106] = { Dispellable = true }, -- Barsleep
  [107] = { Dispellable = true }, -- Barpoison
  [108] = { Dispellable = true }, -- Barparalyze
  [109] = { Dispellable = true }, -- Barblind
  [110] = { Dispellable = true }, -- Barsilence
  [111] = { Dispellable = true }, -- Barpetrify
  [112] = { Dispellable = true }, -- Barvirus
  [116] = { Dispellable = true }, -- Phalanx
  [119] = { Dispellable = true }, -- STR Boost
  [120] = { Dispellable = true }, -- DEX Boost
  [121] = { Dispellable = true }, -- VIT Boost
  [122] = { Dispellable = true }, -- AGI Boost
  [123] = { Dispellable = true }, -- INT Boost
  [124] = { Dispellable = true }, -- MND Boost
  [125] = { Dispellable = true }, -- CHR Boost
  [178] = { Dispellable = true }, -- Firestorm
  [179] = { Dispellable = true }, -- Hailstorm
  [180] = { Dispellable = true }, -- Windstorm
  [181] = { Dispellable = true }, -- Sandstorm
  [182] = { Dispellable = true }, -- Thunderstorm
  [183] = { Dispellable = true }, -- Rainstorm
  [184] = { Dispellable = true }, -- Aurorastorm
  [185] = { Dispellable = true }, -- Voidstorm
  [190] = { Dispellable = true }, -- Magic Atk. Boost
  [191] = { Dispellable = true }, -- Magic Def. Boost
  [195] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Paeon
  [196] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Ballad
  [197] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Minne
  [198] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Minuet
  [199] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Madrigal
  [200] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Prelude
  [201] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Mambo
  [202] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Aubade
  [203] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Pastoral
  [204] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Hum
  [205] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Fantasia
  [206] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Operetta
  [207] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Capriccio
  [208] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Serenade
  [209] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Round
  [210] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Gavotte
  [211] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Fugue
  [212] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Rhapsody
  [213] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Aria
  [214] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- March
  [215] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Etude
  [218] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Hymnus
  [219] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Mazurka
  [220] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Sirvente
  [221] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Dirge
  [222] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Scherzo
  [223] = { MultipleInstance = true, Override = T({}), Dispellable = true }, -- Nocturne
  [227] = { Dispellable = true }, -- Store TP
  [274] = { Dispellable = true }, -- Enlight
  [275] = { Dispellable = true }, -- Auspice
  [277] = { Dispellable = true }, -- Enfire II
  [278] = { Dispellable = true }, -- Enblizzard II
  [279] = { Dispellable = true }, -- Enaero II
  [280] = { Dispellable = true }, -- Enstone II
  [281] = { Dispellable = true }, -- Enthunder II
  [282] = { Dispellable = true }, -- Enwater II
  [286] = { Dispellable = true }, -- Baramnesia
  [288] = { Dispellable = true }, -- Endark
  [289] = { Dispellable = true }, -- Enmity Boost
  [432] = { Dispellable = true }, -- Multi Strikes
  [471] = { Dispellable = true }, -- Migawari
})

return status_table
