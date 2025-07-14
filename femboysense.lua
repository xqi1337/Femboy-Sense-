_DEBUG = false

common.add_event("\aFFDFB2FF[Femboy.sense] \aFFFFFFFFwelcome \a288DFEFF"..common.get_username().."! \aFFFFFFFFcurrent build: \aFFDFB2FFdebug")

local ffi = require("ffi")
local shell = ffi.load("Shell32.dll")
local urlmon = ffi.load("UrlMon")
local wininet = ffi.load("WinInet")
local gdi = ffi.load("Gdi32")
local uint16_t_ptr = ffi.typeof("uint16_t*")
local charbuffer = ffi.typeof("unsigned char[?]")
local uintbuffer = ffi.typeof("unsigned int[?]")

ffi.cdef[[
    int ShellExecuteA(void* hwnd, const char* lpOperation, const char* lpFile, const char* lpParameters, const char* lpDirectory, int nShowCmd);

    typedef struct {
        unsigned short wYear;
        unsigned short wMonth;
        unsigned short wDayOfWeek;
        unsigned short wDay;
        unsigned short wHour;
        unsigned short wMinute;
        unsigned short wSecond;
        unsigned short wMilliseconds;
    } SYSTEMTIME, *LPSYSTEMTIME;
    
    void GetSystemTime(LPSYSTEMTIME lpSystemTime);
    void GetLocalTime(LPSYSTEMTIME lpSystemTime);

    typedef int(__thiscall* get_clipboard_text_length)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);

    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK); 
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

    typedef unsigned char BYTE;
    typedef void *PVOID;
    typedef PVOID HMODULE;
    typedef const char *LPCSTR;
    typedef int *FARPROC;

    HMODULE GetModuleHandleA(
        LPCSTR lpModuleName
    );
    
    FARPROC GetProcAddress(
        HMODULE hModule,
        LPCSTR  lpProcName
    );
    
    typedef struct{
        BYTE r, g, b, a;
    } Color;
    
    typedef void(__cdecl *ColorMsgFn)(Color&, const char*);

    typedef struct
    {
        void* steam_client;
        void* steam_user;
        void* steam_friends;
        void* steam_utils;
        void* steam_matchmaking;
        void* steam_user_stats;
        void* steam_apps;
        void* steam_matchmakingservers;
        void* steam_networking;
        void* steam_remotestorage;
        void* steam_screenshots;
        void* steam_http;
        void* steam_unidentifiedmessages;
        void* steam_controller;
        void* steam_ugc;
        void* steam_applist;
        void* steam_music;
        void* steam_musicremote;
        void* steam_htmlsurface;
        void* steam_inventory;
        void* steam_video;
    } S_steamApiCtx_t;

    typedef struct {
        float x;
        float y;
        float z;
    } vec3_struct;

    typedef void*(__thiscall* c_entity_list_get_client_entity_t)(void*, int);
    typedef void*(__thiscall* c_entity_list_get_client_entity_from_handle_t)(void*, uintptr_t);

    typedef int(__thiscall* c_weapon_get_muzzle_attachment_index_first_person_t)(void*, void*);
    typedef int(__thiscall* c_weapon_get_muzzle_attachment_index_third_person_t)(void*);
    typedef bool(__thiscall* c_entity_get_attachment_t)(void*, int, vec3_struct*);

    typedef struct {
        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
    } color_struct_t;

    typedef void (*console_color_print)(void*, const color_struct_t&, const char*, ...);

    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;
    
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    typedef struct
    {
        char    pad0[0x60]; // 0x00
        void* pEntity; // 0x60
        void* pActiveWeapon; // 0x64
        void* pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char         pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        Vector_t        vecOrigin; // 0xB0
        Vector_t        vecLastOrigin;// 0xBC
        Vector_t        vecVelocity; // 0xC8
        Vector_t        vecVelocityNormalized; // 0xD4
        Vector_t        vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool      	 bOnGround; // 0x108
        bool      	 bHitGroundAnimation; // 0x109
        char   		 pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char   		 pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char   		 pad4[0x208]; // 0x128
        float        flMinBodyYaw; // 0x330
        float        flMaxBodyYaw; // 0x334
        float        flMinPitch; //0x338
        float        flMaxPitch; // 0x33C
        int            iAnimsetVersion; // 0x340
    } CCSGOPlayerAnimationState_534535_t;

]]

local ffi_handler = {}
local renders = {}
local main = {}
ffi.cdef[[
    bool URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    bool CreateDirectoryA(
        const char*                lpPathName,
        void*                      lpSecurityAttributes
    );
]]
files.create_folder('nl\\opensource')

local file_downloader = {}
file_downloader.urlmon = ffi.load('UrlMon')
file_downloader.wininet = ffi.load('WinInet')
file_downloader.download_file_from_url = function(from, to)
    file_downloader.wininet.DeleteUrlCacheEntryA(from)
    file_downloader.urlmon.URLDownloadToFileA(nil, from, to, 0,0)
end

for i = 1, 9 do
    local read = files.read("nl\\opensource\\"..i..".png")
    if read == nil then
        file_downloader.download_file_from_url("https://cdn.bycat.one/smallest-pixel.ttf", "nl\\opensource\\smallest-pixel.ttf")
        file_downloader.download_file_from_url('https://cdn.discordapp.com/attachments/967383362241167420/988498559575941130/velocity_warning.png', 'nl\\opensource\\velocity_warning.png')
    end
end

ffi_helpers = {

    bind_argument = function(fn, arg)
        return function(...)
            return fn(arg, ...)
        end
    end,
    

    open_link = function (link)
        local steam_overlay_API = panorama.SteamOverlayAPI
        local open_external_browser_url = steam_overlay_API.OpenExternalBrowserURL
        open_external_browser_url(link)
    end,


}

local anti_aim = { }

local function bruh()
    if not globals.is_connected then return false end
    if not globals.is_in_game then return false end
    if not entity.get_local_player() then return false end
    if not entity.get_local_player():is_alive() then return false end
    return true
end

local references = {
    [1] = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    [2] = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    [3] = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
    [4] = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    [5] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    [6] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    [7] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    [8] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    [9] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    [10] = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    [11] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    [12] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    [13] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    [14] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    [15] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    [16] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    [17] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "On Shot"),
    [18] = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "LBY Mode"),
    [19] = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    [20] = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    [21] = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    [22] = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
    [23] = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
    [24] = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll")
}

local ref = {}
for i = 1, #references do table.insert(ref, references[i]:get()) end

function anti_aim:yaw(yaw)
    references[10]:override(yaw)
end

function anti_aim:limit(limit)
    references[13]:override(limit)
    references[14]:override(limit)
end

function anti_aim:revert()
    for i = 1, #references do
        references[i]:override(ref[i])
    end
end

local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end

-- sidebar, menu stuff
local texd = gradient_text(226,61,117,255,237,138,172,255,'Femboy.sense')
iconinfo = ui.get_icon("info")
iconlogo = ui.get_icon("terminal")
iconu = ui.get_icon("union")
ui.sidebar(texd, "terminal")
local tabgif = ui.create(iconinfo, " ")
local infotab = ui.create(iconinfo, iconinfo..  "  Information")

infotab:label("                                            \aFFDFB2FF "..iconlogo.."\n\aFFDFB2FF                            +  Femboy.sense  +\n \n\aD2D2D2FFWelcome \a288DFEFF"..common.get_username().."! \n\aD2D2D2FFCurrent build: \aFFDFB2FFFemboy.Debug \n\aD2D2D2FFLast update:\a00FF0CFF 7/9/2022 \n\n\aD2D2D2FFIf you have faced any issues let us know we have the cutest fembby supporters just creat a ticket on our UwU discord server.\n\n")
icondc = ui.get_icon("headset")
infotab:button(icondc..  "  Femboy Discord Server  ",function ()
    ffi_helpers.open_link('https://discord.gg/UsnJyVFM')
end)
iconcfg = ui.get_icon("cog")
infotab:button(iconcfg..  "  Cutest Config  ",function ()
    ffi_helpers.open_link('https://neverlose.cc/getitem?c=eX082v3ryaXb1jF0-hyBTkYP0Od')
end)
icon = ui.get_icon("crosshairs")
iconmanual = ui.get_icon("arrows-alt-h")
iconpreset = ui.get_icon("cogs")
iconcondition = ui.get_icon("running")
iconanim = ui.get_icon("street-view")
iconfs = ui.get_icon("people-arrows")
iconexport = ui.get_icon("file-export")
iconimport = ui.get_icon("file-import")
local antiaim = ui.create(icon, icon..  "  Anti-Aim")
local antiaimbot = {
    antiaim:combo(iconpreset..  "  Preset", { "Custom", "Preset 1", "Preset 2" }),
    antiaim:combo(iconcondition..  "  Condition", { "Global", "Standing", "Crouching", "Slowwalk", "Moving", "Air", "In air crouch" }),
    antiaim:combo(iconmanual..  "  Manual Yaw", {"Off", "Left", "Right" }),
    antiaim:selectable(iconanim..  "  Anim. breakers", {'Leg breaker', 'Static legs in air', 'Zero pitch on land'}, 0),
    antiaim:switch(iconfs..  "  Freestanding"),
    antiaim:button(iconexport..  "  Export"), antiaim:button(iconimport..  "  Import")
}

-- anim breaker
local function in_air()
    local localplayer = entity.get_local_player()
    local b = entity.get_local_player()
        if b == nil then
            return
        end
    local flags = localplayer["m_fFlags"]
    
    if bit.band(flags, 1) == 0 then
        return true
    end
    
    return false
end

entity_list_pointer = ffi.cast('void***', utils.create_interface('client.dll', 'VClientEntityList003'))
get_client_entity_fn = ffi.cast('GetClientEntity_4242425_t', entity_list_pointer[0][3])
function get_entity_address(ent_index)
	local addr = get_client_entity_fn(entity_list_pointer, ent_index)
	return addr
end

hook_helper = {
	copy = function(dst, src, len)
	return ffi.copy(ffi.cast('void*', dst), ffi.cast('const void*', src), len)
	end,

	virtual_protect = function(lpAddress, dwSize, flNewProtect, lpflOldProtect)
	return ffi.C.VirtualProtect(ffi.cast('void*', lpAddress), dwSize, flNewProtect, lpflOldProtect)
	end,

	virtual_alloc = function(lpAddress, dwSize, flAllocationType, flProtect, blFree)
	local alloc = ffi.C.VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
	if blFree then
		table.insert(buff.free, function()
		ffi.C.VirtualFree(alloc, 0, 0x8000)
		end)
	end
	return ffi.cast('intptr_t', alloc)
end
}

buff = {free = {}}
vmt_hook = {hooks = {}}

function vmt_hook.new(vt)
    local new_hook = {}
    local org_func = {}
    local old_prot = ffi.new('unsigned long[1]')
    local virtual_table = ffi.cast('intptr_t**', vt)[0]

    new_hook.this = virtual_table
    new_hook.hookMethod = function(cast, func, method)
    org_func[method] = virtual_table[method]
    hook_helper.virtual_protect(virtual_table + method, 4, 0x4, old_prot)

    virtual_table[method] = ffi.cast('intptr_t', ffi.cast(cast, func))
    hook_helper.virtual_protect(virtual_table + method, 4, old_prot[0], old_prot)

    return ffi.cast(cast, org_func[method])
end

new_hook.unHookMethod = function(method)
    hook_helper.virtual_protect(virtual_table + method, 4, 0x4, old_prot)
    local alloc_addr = hook_helper.virtual_alloc(nil, 5, 0x1000, 0x40, false)
    local trampoline_bytes = ffi.new('uint8_t[?]', 5, 0x90)

    trampoline_bytes[0] = 0xE9
    ffi.cast('int32_t*', trampoline_bytes + 1)[0] = org_func[method] - tonumber(alloc_addr) - 5

    hook_helper.copy(alloc_addr, trampoline_bytes, 5)
    virtual_table[method] = ffi.cast('intptr_t', alloc_addr)

    hook_helper.virtual_protect(virtual_table + method, 4, old_prot[0], old_prot)
    org_func[method] = nil
end

new_hook.unHookAll = function()
    for method, func in pairs(org_func) do
        new_hook.unHookMethod(method)
    end
end

table.insert(vmt_hook.hooks, new_hook.unHookAll) 
    return new_hook
end

events.shutdown:set(function()
    for _, reset_function in ipairs(vmt_hook.hooks) do
        reset_function()
    end
end)

local legmovement = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")

hooked_function = nil
ground_ticks, end_time = 1, 0
function updateCSA_hk(thisptr, edx)
    if entity.get_local_player() == nil or ffi.cast('uintptr_t', thisptr) == nil then return end
    local local_player = entity.get_local_player()
    local lp_ptr = get_entity_address(local_player:get_index())
    if antiaimbot[4]:get("Leg breaker") then
        ffi.cast('float*', lp_ptr+10104)[0] = 1
        legmovement:set('Sliding')
    end
    if antiaimbot[4]:get("Zero pitch on land") then
        ffi.cast('float*', lp_ptr+10104)[12] = 0
    end
    hooked_function(thisptr, edx)
    if antiaimbot[4]:get("Static legs in air") then
        ffi.cast('float*', lp_ptr+10104)[6] = 1
    end
    if antiaimbot[4]:get("Zero pitch on land") then
        if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime  + 1
        end
        if not in_air() and ground_ticks > 1 and end_time > globals.curtime then
            ffi.cast('float*', lp_ptr+10104)[12] = 0.5
        end
    end
end


function anim_state_hook()
    local local_player = entity.get_local_player()
    if not local_player then return end

    local local_player_ptr = get_entity_address(local_player:get_index())
    if not local_player_ptr or hooked_function then return end
    local C_CSPLAYER = vmt_hook.new(local_player_ptr)
    hooked_function = C_CSPLAYER.hookMethod('void(__fastcall*)(void*, void*)', updateCSA_hk, 224)
end

events.createmove_run:set(anim_state_hook)
--


local burfs_ref = antiaimbot[5]:create()
local fs_dym = burfs_ref:switch("Disable Yaw Modifiers")
local fs_body = burfs_ref:switch("Body Freestanding")

-- state icons
iconoverride = ui.get_icon("check")
iconleft = ui.get_icon("arrow-left")
iconright = ui.get_icon("arrow-right")
iconyawmodifier = ui.get_icon("wrench")
iconmodifieroffset = ui.get_icon("sliders-h")
iconleftlimit = ui.get_icon("angle-double-left")
iconrightlimit = ui.get_icon("angle-double-right")
iconoptions = ui.get_icon("cog")
icononshot = ui.get_icon("fire")
--

-- condition menu stuff
local shared, stand, duck, walk, move, air, air_duck = ui.create(icon, icon.."  Global"), ui.create(icon, icon.."  Standing"), ui.create(icon, icon.."  Crouching"), ui.create(icon, icon.."  Slowwalk"), ui.create(icon, icon.."  Moving"), ui.create(icon, icon.."  Air"), ui.create(icon, icon.."  In air crouch")
local cond = {
    shared = {
        shared:slider(iconleft.."  Yaw Add", -180, 180, 0, 1, ""),
        shared:combo(iconyawmodifier.."  Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }),
        shared:slider(iconmodifieroffset.."  Modifier Offset", -180, 180, 0, 1, ""),
        shared:slider(iconleftlimit.."  Left limit", 0, 60, 60, 1, ""),
        shared:slider(iconrightlimit.."  Right limit", 0, 60, 60, 1, ""),
        shared:selectable(iconoptions.."  Options", { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }),
        shared:combo(iconfs.."  Freestanding", { "Off", "Peek Fake", "Peek Real" }),
        shared:combo(icononshot.."  On Shot", { "Default", "Opposite", "Freestanding", "Switch" })
    },
    standing = {
        stand:switch(iconoverride.."  Override Standing", true),
        stand:slider(iconleft.."  Yaw Add", -180, 180, 0, 1, ""),
        stand:combo(iconyawmodifier.."  Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }),
        stand:slider(iconmodifieroffset.."  Modifier Offset", -180, 180, 0, 1, ""),
        stand:slider(iconleftlimit.."  Left limit", 0, 60, 60, 1, ""),
        stand:slider(iconrightlimit.."  Right limit", 0, 60, 60, 1, ""),
        stand:selectable(iconoptions.."  Options", { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }),
        stand:combo(iconfs.."  Freestanding", { "Off", "Peek Fake", "Peek Real" }),
        stand:combo(icononshot.."  On Shot", { "Default", "Opposite", "Freestanding", "Switch" })
    },
    duck = {
        duck:switch(iconoverride.."  Override Crouching", true),
        duck:slider(iconleft.."  Yaw Add", -180, 180, 0, 1, ""),
        duck:combo(iconyawmodifier.."  Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }),
        duck:slider(iconmodifieroffset.."  Modifier Offset", -180, 180, 0, 1, ""),
        duck:slider(iconleftlimit.."  Left limit", 0, 60, 60, 1, ""),
        duck:slider(iconrightlimit.."  Right limit", 0, 60, 60, 1, ""),
        duck:selectable(iconoptions.."  Options", { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }),
        duck:combo(iconfs.."  Freestanding", { "Off", "Peek Fake", "Peek Real" }),
        duck:combo(icononshot.."  On Shot", { "Default", "Opposite", "Freestanding", "Switch" })
    },
    walk = {
        walk:switch(iconoverride.."  Override Slowwalk", true),
        walk:slider(iconleft.."  Yaw Add", -180, 180, 0, 1, ""),
        walk:combo(iconyawmodifier.."  Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }),
        walk:slider(iconmodifieroffset.."  Modifier Offset", -180, 180, 0, 1, ""),
        walk:slider(iconleftlimit.."  Left limit", 0, 60, 60, 1, ""),
        walk:slider(iconrightlimit.."  Right limit", 0, 60, 60, 1, ""),
        walk:selectable(iconoptions.."  Options", { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }),
        walk:combo(iconfs.."  Freestanding", { "Off", "Peek Fake", "Peek Real" }),
        walk:combo(icononshot.."  On Shot", { "Default", "Opposite", "Freestanding", "Switch" })
    },
    move = {
        move:switch(iconoverride.."  Override Moving", true),
        move:slider(iconleft.."  Yaw Add", -180, 180, 0, 1, ""),
        move:combo(iconyawmodifier.."  Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }),
        move:slider(iconmodifieroffset.."  Modifier Offset", -180, 180, 0, 1, ""),
        move:slider(iconleftlimit.."  Left limit", 0, 60, 60, 1, ""),
        move:slider(iconrightlimit.."  Right limit", 0, 60, 60, 1, ""),
        move:selectable(iconoptions.."  Options", { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }),
        move:combo(iconfs.."  Freestanding", { "Off", "Peek Fake", "Peek Real" }),
        move:combo(icononshot.."  On Shot", { "Default", "Opposite", "Freestanding", "Switch" })
    },
    air = {
        air:switch(iconoverride.."  Override In Air", true),
        air:slider(iconleft.."  Yaw Add", -180, 180, 0, 1, ""),
        air:combo(iconyawmodifier.."  Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }),
        air:slider(iconmodifieroffset.."  Modifier Offset", -180, 180, 0, 1, ""),
        air:slider(iconleftlimit.."  Left limit", 0, 60, 60, 1, ""),
        air:slider(iconrightlimit.."  Right limit", 0, 60, 60, 1, ""),
        air:selectable(iconoptions.."  Options", { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }),
        air:combo(iconfs.."  Freestanding", { "Off", "Peek Fake", "Peek Real" }),
        air:combo(icononshot.."  On Shot", { "Default", "Opposite", "Freestanding", "Switch" })
    },
    air_duck = {
        air_duck:switch(iconoverride.."  Override In Air Crouch", true),
        air_duck:slider(iconleft.."  Yaw Add", -180, 180, 0, 1, ""),
        air_duck:combo(iconyawmodifier.."  Yaw Modifier", { "Disabled", "Center", "Offset", "Random", "Spin" }),
        air_duck:slider(iconmodifieroffset.."  Modifier Offset", -180, 180, 0, 1, ""),
        air_duck:slider(iconleftlimit.."  Left limit", 0, 60, 60, 1, ""),
        air_duck:slider(iconrightlimit.."  Right limit", 0, 60, 60, 1, ""),
        air_duck:selectable(iconoptions.."  Options", { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }),
        air_duck:combo(iconfs.."  Freestanding", { "Off", "Peek Fake", "Peek Real" }),
        air_duck:combo(icononshot.."  On Shot", { "Default", "Opposite", "Freestanding", "Switch" })
    },
}

function anti_aim:power()
    antiaimbot[2]:set_visible(antiaimbot[1]:get() == "Custom")
    antiaimbot[6]:set_visible(antiaimbot[1]:get() == "Custom")
    antiaimbot[7]:set_visible(antiaimbot[1]:get() == "Custom")
    for i = 1, #cond.shared do cond.shared[i]:set_visible(antiaimbot[1]:get() == "Custom" and antiaimbot[2]:get() == "Global") end
    for i = 1, #cond.standing do cond.standing[i]:set_visible(antiaimbot[1]:get() == "Custom" and antiaimbot[2]:get() == "Standing") end
    for i = 1, #cond.duck do cond.duck[i]:set_visible(antiaimbot[1]:get() == "Custom" and antiaimbot[2]:get() == "Crouching") end
    for i = 1, #cond.walk do cond.walk[i]:set_visible(antiaimbot[1]:get() == "Custom" and antiaimbot[2]:get() == "Slowwalk") end
    for i = 1, #cond.move do cond.move[i]:set_visible(antiaimbot[1]:get() == "Custom" and antiaimbot[2]:get() == "Moving") end
    for i = 1, #cond.air do cond.air[i]:set_visible(antiaimbot[1]:get() == "Custom" and antiaimbot[2]:get() == "Air") end
    for i = 1, #cond.air_duck do cond.air_duck[i]:set_visible(antiaimbot[1]:get() == "Custom" and antiaimbot[2]:get() == "In air crouch") end
end; anti_aim:power()

antiaimbot[1]:set_callback(function() anti_aim:power() end); antiaimbot[2]:set_callback(function() anti_aim:power() end); antiaimbot[2]:set_callback(function() anti_aim:power() end); antiaimbot[3]:set_callback(function() anti_aim:power() end)

events.pre_render:set(function()
    if not bruh() then anti_aim:revert(); return end

    local lp = entity.get_local_player()

    local height = lp.m_flDuckAmount
    local flags = lp.m_fFlags
    local vel = lp.m_vecVelocity:length2d()

    local anti = { 0, 0, "Disabled", 0, 60, 60, { }, "Off", "Default" }

    if antiaimbot[1]:get() == "Custom" then
        if cond.air_duck[1]:get() and flags == 262 then
            anti = { cond.air_duck[2]:get(), cond.air_duck[3]:get(), cond.air_duck[4]:get(), cond.air_duck[5]:get(), cond.air_duck[6]:get(), cond.air_duck[7]:get(), cond.air_duck[8]:get(), cond.air_duck[9]:get() }
        elseif cond.air[1]:get() and flags == 256 then
            anti = { cond.air[2]:get(), cond.air[3]:get(), cond.air[4]:get(), cond.air[5]:get(), cond.air[6]:get(), cond.air[7]:get(), cond.air[8]:get(), cond.air[9]:get() }
        elseif cond.duck[1]:get() and flags == 263 then
            anti = { cond.duck[2]:get(), cond.duck[3]:get(), cond.duck[4]:get(), cond.duck[5]:get(), cond.duck[6]:get(), cond.duck[7]:get(), cond.duck[8]:get(), cond.duck[9]:get() }
        elseif cond.walk[1]:get() and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
            anti = { cond.walk[2]:get(), cond.walk[3]:get(), cond.walk[4]:get(), cond.walk[5]:get(), cond.walk[6]:get(), cond.walk[7]:get(), cond.walk[8]:get(), cond.walk[9]:get() }
        elseif cond.move[1]:get() and vel > 60 then
            anti = { cond.move[2]:get(), cond.move[3]:get(), cond.move[4]:get(), cond.move[5]:get(), cond.move[6]:get(), cond.move[7]:get(), cond.move[8]:get(), cond.move[9]:get() }
        elseif cond.standing[1]:get() then
            anti = { cond.standing[2]:get(), cond.standing[3]:get(), cond.standing[4]:get(), cond.standing[5]:get(), cond.standing[6]:get(), cond.standing[7]:get(), cond.standing[8]:get(), cond.standing[9]:get() }
        else
            anti = { cond.shared[1]:get(), cond.shared[2]:get(), cond.shared[3]:get(), cond.shared[4]:get(), cond.shared[5]:get(), cond.shared[6]:get(), cond.shared[7]:get(), cond.shared[8]:get() }
        end
    end

    -- Presets
    -- Options usage: { "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce" }
    
    if antiaimbot[1]:get() == "Preset 1" then
        if cond.air_duck[1]:get() and flags == 262 then
            anti = { 0, "Center", -1, 60, 60, {"Jitter"}, "Off", "Freestanding" }
        elseif cond.air[1]:get() and flags == 256 then
            anti = { 0, "Center", -2, 60, 60, {"Avoid Overlap", "Jitter"}, "Off", "Freestanding" }
        elseif cond.duck[1]:get() and flags == 263 then
            anti = { 0, "Center", -3, 60, 60, {"Jitter"}, "Off", "Freestanding" }
        elseif cond.walk[1]:get() and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
            anti = { 0, "Center", -4, 60, 60, {"Jitter"}, "Off", "Switch" }
        elseif cond.move[1]:get() and vel > 60 then
            anti = { 0, "Center", -5, 60, 60, {"Jitter"}, "Off", "Switch" }
        elseif cond.standing[1]:get() then
            anti = { 0, "Center", -6, 60, 60, {"Jitter"}, "Off", "Freestanding" }
        else
            anti = { 0, "Center", -7, 60, 60, { }, "Off", "Freestanding" }
        end
    end

        if antiaimbot[1]:get() == "Preset 2" then
            if cond.air_duck[1]:get() and flags == 262 then
                anti = { -1, "Center", -30, 58, 58, {"Jitter"}, "Off", "Opposite" }
            elseif cond.air[1]:get() and flags == 256 then
                anti = { 1, "Center", -11, 58, 58, {"Jitter"}, "Off", "Opposite" }
            elseif cond.duck[1]:get() and flags == 263 then
                anti = { 1, "Center", -42, 60, 60, {"Jitter"}, "Off", "Opposite" }
            elseif cond.walk[1]:get() and ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
                anti = { 1, "Center", -50, 60, 60, {"Jitter"}, "Off", "Opposite" }
            elseif cond.move[1]:get() and vel > 60 then
                anti = { -1, "Center", -60, 60, 60, {"Jitter"}, "Off", "Opposite" }
            elseif cond.standing[1]:get() then
                anti = { 0, "Center", -32, 60, 60, { }, "Off", "Opposite" }
            else
                anti = { 0, "Center", -32, 60, 60, { }, "Off", "Opposite" }
            end
        end

    references[11]:override(true)
    if antiaimbot[3]:get() == "Left" then
        references[7]:override(-90)
    elseif antiaimbot[3]:get() == "Right" then
        references[7]:override(90)
    else
        references[7]:override(anti[1])
    end
    references[9]:override(anti[2])
    references[10]:override(anti[3])
    anti_aim:limit(rage.antiaim:get_rotation(true) < 0 and anti[4] or anti[5])
    references[15]:override(anti[6])
    references[16]:override(anti[7])
    references[17]:override(anti[8])

    local rnd_int = utils.random_int(0, 1)
    local TrueAndFalse = {true, false}
end)

-- import, export
local Clipboard, ffi_handler, Base64, cfg_data = {}, {}, {}, {}

ffi.cdef[[
    typedef int(__thiscall* get_clipboard_text_length)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

ffi_handler.VGUI_System = ffi.cast(ffi.typeof("void***"), utils.create_interface("vgui2.dll", "VGUI_System010"))
ffi_handler.get_clipboard_text_length = ffi.cast("get_clipboard_text_length", ffi_handler.VGUI_System[0][7])
ffi_handler.get_clipboard_text = ffi.cast("get_clipboard_text", ffi_handler.VGUI_System[0][11])
ffi_handler.set_clipboard_text = ffi.cast("set_clipboard_text", ffi_handler.VGUI_System[0][9])

function Clipboard.Get()
    local clipboard_text_length = ffi_handler.get_clipboard_text_length(ffi_handler.VGUI_System)

    if (clipboard_text_length > 0) then
        local buffer = ffi.new("char[?]", clipboard_text_length)

        ffi_handler.get_clipboard_text(ffi_handler.VGUI_System, 0, buffer, clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length))
        return ffi.string(buffer, clipboard_text_length - 1)
    end

    return ""
end

function Clipboard.Set(text)
    ffi_handler.set_clipboard_text(ffi_handler.VGUI_System, text, #text)
end

local JSON = panorama.loadstring([[
    return {
        stringify: JSON.stringify,
        parse: JSON.parse
    };
]])()

table.insert(cfg_data, antiaimbot[1])

table.insert(cfg_data, cond.shared[1])
table.insert(cfg_data, cond.shared[2])
table.insert(cfg_data, cond.shared[3])
table.insert(cfg_data, cond.shared[4])
table.insert(cfg_data, cond.shared[5])
table.insert(cfg_data, cond.shared[6])
table.insert(cfg_data, cond.shared[7])
table.insert(cfg_data, cond.shared[8])
table.insert(cfg_data, cond.shared[9])

table.insert(cfg_data, cond.standing[1])
table.insert(cfg_data, cond.standing[2])
table.insert(cfg_data, cond.standing[3])
table.insert(cfg_data, cond.standing[4])
table.insert(cfg_data, cond.standing[5])
table.insert(cfg_data, cond.standing[6])
table.insert(cfg_data, cond.standing[7])
table.insert(cfg_data, cond.standing[8])
table.insert(cfg_data, cond.standing[9])
table.insert(cfg_data, cond.standing[10])

table.insert(cfg_data, cond.duck[1])
table.insert(cfg_data, cond.duck[2])
table.insert(cfg_data, cond.duck[3])
table.insert(cfg_data, cond.duck[4])
table.insert(cfg_data, cond.duck[5])
table.insert(cfg_data, cond.duck[6])
table.insert(cfg_data, cond.duck[7])
table.insert(cfg_data, cond.duck[8])
table.insert(cfg_data, cond.duck[9])
table.insert(cfg_data, cond.duck[10])

table.insert(cfg_data, cond.walk[1])
table.insert(cfg_data, cond.walk[2])
table.insert(cfg_data, cond.walk[3])
table.insert(cfg_data, cond.walk[4])
table.insert(cfg_data, cond.walk[5])
table.insert(cfg_data, cond.walk[6])
table.insert(cfg_data, cond.walk[7])
table.insert(cfg_data, cond.walk[8])
table.insert(cfg_data, cond.walk[9])
table.insert(cfg_data, cond.walk[10])

table.insert(cfg_data, cond.move[1])
table.insert(cfg_data, cond.move[2])
table.insert(cfg_data, cond.move[3])
table.insert(cfg_data, cond.move[4])
table.insert(cfg_data, cond.move[5])
table.insert(cfg_data, cond.move[6])
table.insert(cfg_data, cond.move[7])
table.insert(cfg_data, cond.move[8])
table.insert(cfg_data, cond.move[9])
table.insert(cfg_data, cond.move[10])

table.insert(cfg_data, cond.air[1])
table.insert(cfg_data, cond.air[2])
table.insert(cfg_data, cond.air[3])
table.insert(cfg_data, cond.air[4])
table.insert(cfg_data, cond.air[5])
table.insert(cfg_data, cond.air[6])
table.insert(cfg_data, cond.air[7])
table.insert(cfg_data, cond.air[8])
table.insert(cfg_data, cond.air[9])
table.insert(cfg_data, cond.air[10])

table.insert(cfg_data, cond.air_duck[1])
table.insert(cfg_data, cond.air_duck[2])
table.insert(cfg_data, cond.air_duck[3])
table.insert(cfg_data, cond.air_duck[4])
table.insert(cfg_data, cond.air_duck[5])
table.insert(cfg_data, cond.air_duck[6])
table.insert(cfg_data, cond.air_duck[7])
table.insert(cfg_data, cond.air_duck[8])
table.insert(cfg_data, cond.air_duck[9])
table.insert(cfg_data, cond.air_duck[10])

local base64 = require("neverlose/base64")

antiaimbot[6]:set_callback(function()
    --export
    local Code = { }

    for _, val in pairs(cfg_data) do
        table.insert(Code, val:get())
    end

    local cat = base64.encode(JSON.stringify(Code))

    Clipboard.Set(cat)
    common.add_event("[Femboy.sense] Copied config to clipboard.")
end)

antiaimbot[7]:set_callback(function()
    --import
    local getv = base64.decode(Clipboard.Get())
    common.add_event("[Femboy.sense] Successfully imported config.")
    for k, v in pairs(JSON.parse(getv)) do

        cfg_data[k]:set(v)
    end
end)
--

-- Visuals

iconvis = ui.get_icon("palette")
iconmd = ui.get_icon("sort-numeric-up")
local ind1 = ui.create(iconvis, iconvis..  "  Femboy Visuals")
local enable1nd = ind1:combo(iconvis..  "  Indicators", {'Disabled', 'Classic'})
local colors_ref = enable1nd:create()
iconwidget = ui.get_icon("eye")
local solus_select = ind1:selectable(iconwidget..  "  Widgets", {'Watermark', 'Keybinds', 'Choke Indication'}, 0)
iconlogs = ui.get_icon("crosshairs")
local enablelogs = ind1:switch(iconlogs..  "  Femboy Logs")
local minindi = ind1:switch(iconmd..  "  Minimum Damage")
local mind_ref = minindi:create()
local dx_slider = mind_ref:slider("X ", 0, 110, 5, 1)
local dy_slider = mind_ref:slider("Y ", 0, 110, 5, 1)
local indcolor5 = colors_ref:color_picker('Version Color',color(255, 255, 255, 255))
local indcolor1 = colors_ref:color_picker('States Color',color(255, 255, 255, 255))
local indcolor2 = colors_ref:color_picker('Desync Color',color(143, 178, 255, 255))
local indcolor3 = colors_ref:color_picker('Name Color',color(143, 178, 255, 255))
local indcolor4 = colors_ref:color_picker('Keys Color',color(255, 255, 255, 255))

local ui_callback4 = function()
    local new_state4 = enable1nd:get() == "Classic"
    indcolor1:set_visible(new_state4)
    indcolor2:set_visible(new_state4)
    indcolor3:set_visible(new_state4)
    indcolor4:set_visible(new_state4)
    indcolor5:set_visible(new_state4)
end ui_callback4()
enable1nd:set_callback(ui_callback4) 

-- Indicator

local function bruh()
    if not globals.is_connected then return false end
    if not globals.is_in_game then return false end
    if not entity.get_local_player() then return false end
    if not entity.get_local_player():is_alive() then return false end
    return true
end

math.anim = function(name, value, speed)
    return name + (value - name) * globals.frametime * speed
end

math.clamp = function(v, min, max)
    if v > max then return max end
    if v < min then return min end
    return v
end

math.pulse = function()
    return math.clamp((math.floor(math.sin(globals.curtime * 2) * 220 + 221)) / 900 * 6.92, 0, 1) * 235 + 20
end

local screen_size, font, vsync = render.screen_size(), render.load_font("nl\\opensource\\smallest-pixel.ttf", 10, "o"), 0

local options = {
    yaw = "Femboy.sense",
    x = 0,
    y = 30,
    w = 60 / 2
}

local colors = {
    first = color(255, 255, 255),
    second = color(187, 172, 182),
    third = color(255, 255, 255),
    fourth = color(255, 255, 255)
}

local hotkeys = {
    ["Minimum Damage"] = {"DMG", false, 0, 0},
    ["Hide Shots"] = {"OS", false, 0, 0},
    ["Freestanding"] = {"FS", false, 0, 0},
    ["Safe Points"] = {"SP", false, 0, 0},
    ["Body Aim"] = {"BAIM", false, 0, 0},
    ["Double Tap"] = {"DT", false, 0, 0},
    ["Minimum Damage"] = {"DMG", false, 0, 0},
}

local fontkardo2 = render.load_font("nl\\opensource\\smallest-pixel.ttf", 10, "o")

events.render:set(function()
    if not bruh() then return end

    local add_y = dy_slider:get()
    local add_x = dx_slider:get()
        
    if minindi:get() then
        local current_damage = ui.find("Aimbot", "Ragebot", "Selection", "Minimum Damage"):get()
        render.text(fontkardo2, vector(screen_size.x / 2 - add_x, screen_size.y / 2 - add_y), color(255, 255, 255, 255), "r", current_damage)
    end
 
    if enable1nd:get() == "Classic" then

    local lp = entity.get_local_player()

    local height = lp.m_flDuckAmount
    local flags = lp.m_fFlags
    local vel = lp.m_vecVelocity:length2d()
    local state = "-"
    
    if flags == 262 then
        state = "AIR-C"
    elseif flags == 256 then
        state = "AIR"
    elseif flags == 263 then
        state = "CROUCH"
    elseif ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() then
        state = "WALK"
    elseif vel > 60 then
        state = "MOVE"
    else
        state = "STAND"
    end

    desync = math.clamp(math.abs(rage.antiaim:get_rotation(false) - rage.antiaim:get_rotation(true)), 0, options.w * 2)
    vsync = math.anim(vsync, desync, 10)
    fake = math.floor(vsync)
    local get_color1, get_color2 = indcolor1:get(), indcolor2:get()
    
    colors.first = indcolor1:get()
    colors.second = indcolor2:get()
    colors.third = indcolor3:get()
    colors.fourth = indcolor4:get()
    colors.fifth = indcolor5:get()

    render.text(font, vector(screen_size.x / 2 - options.w + options.x, screen_size.y / 2 + options.y + (0 * 12)), color(colors.fifth.r, colors.fifth.g, colors.fifth.b, math.pulse()), nil, "FEMBOY.SENSE")
    render.text(font, vector(screen_size.x / 2 + options.w + options.x, screen_size.y / 2 + options.y + (0 * 12)+1), color(colors.first.r, colors.first.g, colors.first.b, math.pulse()), "r", state)
    render.rect(vector(screen_size.x / 2 - options.w + options.x, screen_size.y / 2 + options.y + (1 * 12)), vector(screen_size.x / 2 + options.w + options.x, screen_size.y / 2 + options.y + (1 * 12) + 6), color(0))
    render.gradient(vector(screen_size.x / 2 - options.w + options.x + 1, screen_size.y / 2 + options.y + (1 * 12) + 1), vector(screen_size.x / 2 - options.w + fake + options.x - 1, screen_size.y / 2 + options.y + (1 * 12) + 6 - 1), colors.second, color(0), colors.second, color(0))
    render.text(font, vector(screen_size.x / 2 + options.x, screen_size.y / 2 + options.y + (2 * 12)), colors.third, "c", options.yaw)

    local binds = ui.get_binds()

    for i = 1, #binds do
        local bind = binds[i]
        if hotkeys[bind.name] ~= nil then
            hotkeys[bind.name][2] = bind.active
        end
    end

    local vec = vector(screen_size.x / 2 + options.x, screen_size.y / 2 + options.y + (2 * 12))

    local offset = 1
    
    for idx, hotkey in pairs(hotkeys) do
        if hotkey[2] then
            hotkey[3] = math.anim(hotkey[3], 255, 10)
        else
            hotkey[3] = math.anim(hotkey[3], 0, 10)
        end
        hotkey[4] = math.anim(hotkey[4], (offset * (hotkey[3] / 255) * 9), 10)
        render.text(font, vector(vec.x, vec.y + hotkey[4]), color(colors.fourth.r,colors.fourth.g,colors.fourth.b,math.floor(hotkey[3])), "c", hotkey[1])
        if hotkey[3] > 5 then offset = offset + 1 end
    end
end
end)

-- Misc
-- Ideal Tick
local misctab = ui.create(iconvis, iconoptions..  "  Misc")
iconideal = ui.get_icon("bolt")
local idealtick = misctab:switch(iconideal..  "  Ideal Tick")
local ideal_ref = idealtick:create()
local label = idealtick:set_tooltip("bind this (make sure dt is off)")
local enableind = ideal_ref:switch("Indicator", true)
local itcolor1 = ideal_ref:color_picker('Indicator color',color(255, 255, 255, 255))
local enablefs = ideal_ref:switch("Freestanding")
local enablefast = ideal_ref:switch("Ragebot tweaks")
local enablefast1 = ideal_ref:slider("Hitchance", 0, 100, 50, 1)
local enablefast2 = ideal_ref:slider("Minimum damage", 0, 110, 5, 1)
local dt_menu = ui.find("Aimbot", "Ragebot", "Main", "Double Tap")
local old_dt = dt_menu:get_override()
local qp_menu = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
local old_qp = qp_menu:get_override()
local fs_menu = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
local old_fs = fs_menu:get_override()
local fl_menu = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
local old_fl = fl_menu:get_override()
local md_menu = ui.find("Aimbot", "Ragebot", "Selection", "Minimum Damage")
local old_md = md_menu:get_override()
local hc_menu = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance")
local old_hc = hc_menu:get_override()

local ui_callback3 = function()
    local new_state3 = enableind:get()
    itcolor1:set_visible(new_state3)
end ui_callback3()
enableind:set_callback(ui_callback3) 

local idealtweak = function()
    local ideal_tweak = enablefast:get()
    enablefast1:set_visible(ideal_tweak)
    enablefast2:set_visible(ideal_tweak)
end idealtweak()
enablefast:set_callback(idealtweak) 

local indlocation = render.screen_size()

local fontkardo = render.load_font("nl\\opensource\\smallest-pixel.ttf", 10, "o")

local function indicatorler()
    if idealtick:get() and enableind:get() then
    local x, y, baykat, alpha, sebep = indlocation.x, indlocation.y, 40, math.min(math.floor(math.sin((globals.realtime % 3) * 4) * 175 + 50), 255), math.min(math.floor(math.sin((rage.exploit:get()%2) * 1) * 122), 100)
    local get_color3 = itcolor1:get()
    local xantis_baba = render.measure_text(fontkardo, "o", "+ UwU IDEAL TICK + ")
    local offset = 1
    local dt_size = render.measure_text(fontkardo, "o", "+/- CHARGED UwU IDEAL TICK (7%)")
    local crosshair = {
        offset = -10,
        scope = 0
    }

        offset = offset + 1
        render.text(fontkardo, vector(screen_size.x / 2 + crosshair.scope, screen_size.y / 2 + crosshair.offset + 2 + (offset * 10)), color(0, 0, 0, 0), "c", "+/- CHARGED IDEAL TICK (7%)")
        render.push_clip_rect(vector(screen_size.x / 2 - dt_size.x / 2 + crosshair.scope, screen_size.y / 2 + crosshair.offset + 2 + (offset * 10) - 10), vector(screen_size.x / 2 - dt_size.x / 2 + (rage.exploit:get() * dt_size.x) + crosshair.scope, screen_size.y / 2 + crosshair.offset + 12 + (offset * 10)))
        render.text(fontkardo, vector(screen_size.x / 2 + crosshair.scope, screen_size.y / 2 + crosshair.offset + 2 + (offset * 10)), get_color3, "c", "+/- CHARGED IDEAL TICK (7%)")
        render.pop_clip_rect()

    baykat = baykat + 10.5
    end
end


local function fenayim_babus()
    if not globals.is_connected then return end; if not globals.is_in_game then return end
    local lp = entity.get_local_player()
    if not lp then return end; if not lp:is_alive() then return end

    local idhc = enablefast1:get()
    local idmd = enablefast2:get()
    
    if idealtick:get() then
        ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):override(true)
        ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"):override(true)
        if enablefs:get() then ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):override(true) end
        if enablefast:get() then
            ui.find("Aimbot", "Ragebot", "Selection", "Minimum Damage"):override(idmd)
            ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"):override(idhc)
        end
    else
        dt_menu:override(old_dt)
        qp_menu:override(old_qp)
        fs_menu:override(old_fs)
        md_menu:override(old_md)
        hc_menu:override(old_hc)
    end

    if antiaimbot[5]:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"):override(true)
    elseif antiaimbot[5]:get() and fs_dym:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"):override(true)
    elseif antiaimbot[5]:get() and fs_body:get() then
        ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"):override(true)
    else
        return
    end
end

events.createmove:set(function()
    fenayim_babus()
end)

events.render:set(function()
    if not globals.is_connected then return end; if not globals.is_in_game then return end
    local lp = entity.get_local_player()
    if not lp then return end; if not lp:is_alive() then return end
    indicatorler()
end)

-- Killsay

local phrases = {
    "UwU Daddy",
    "A-ah shit... Y-your cock is big and in my ass -- already~?!",
    "All I did was crossplay cause I felt like it might be fun... But now Im just a little girl that cums from big dicks!",
    "B-Baka, please let me be your femboy sissy cum slut!",
    "Lets take this swimsuit off already <3 ill drink your unknown melty juice",
    "Oh my god, I hate you so much, Senpai, but please, k-keep fucking me harder! ahhh~",
    "It-Its not gay if youre wearing thigh highs, M-Master",
    "M-Master, d-dont spank my petite butt so hard ahhhH~",
    "M-Master, if you keep thrusting that hard, my boobs will fall off!",
    "Ara-Ara~, who is ther! Come get me, senpai~ <3",
    "Ill swallow your sticky essence along with you~!",
    "Fill my throat pussy with your semen, kun",
    "Hey kun, Can I have some semen?",
    "M-Master, does it feel good when I slide by tits up and down on your cute manly part?",
    "O-Oniichan, my t-toes are so warm with your cum all over them uwu~",
    "F-Fuck me harder, onii-chan!",
    "Ahhhh... Its like a dream come true... I get to stick my dick inside your ass...!",
    "Give me all your semen, Senpai, ahhhhh~",
    "Youre such a pervert for filling me up with your baby batter, Senpai~~",
    "M-Master, d-dont spank my petite butt so hard ahhhH~~~ youre getting me so w-wet~",
    "Hey, who wants a piece of this plump 19-year-old boy-pussy? Single file, boys, come get it while its hot!",
    "1NN dog",
    "GetOwned by Femboy.sense",
    "Femboy.sense on Top",
    "Get Good Get Femboy.sense",}

iconkillsay = ui.get_icon("comment-dots")
local enablekillsay = misctab:switch(iconkillsay..  "  Femboy Killsay")

local function get_phrase()
    if not enablekillsay:get()  then return end
return phrases[utils.random_int(1, #phrases)]:gsub('"', '')
end

events.player_death:set(function(e)
local me = entity.get_local_player()
local attacker = entity.get(e.attacker, true)

if me == attacker then
    if enablekillsay:get() then
utils.console_exec('say "' .. get_phrase() .. '"')
end
end
end)

-- Ragebot logs menu stuff here to keep menu layering clean
local logs_ref = enablelogs:create()
local logs_select = logs_ref:selectable("Print", {'Dev', 'Screen', 'Console'}, 0)

-- Solus UI Menu

local solus_ref = solus_select:create()
local color_picker = solus_ref:color_picker("Accent color", color(107, 139, 255, 255))
local slider_ref = solus_ref:slider("Roundness", 0, 10, 7)
local custom_name = solus_ref:input("Username", ""..common.get_username().."") 

local ui_callback6 = function()
    local new_state6 = solus_select:get('Watermark')
    custom_name:set_visible(new_state6)
end ui_callback6()
solus_select:set_callback(ui_callback6)

--locals
local tween=(function()local a={}local b,c,d,e,f,g,h=math.pow,math.sin,math.cos,math.pi,math.sqrt,math.abs,math.asin;local function i(j,k,l,m)return l*j/m+k end;local function n(j,k,l,m)return l*b(j/m,2)+k end;local function o(j,k,l,m)j=j/m;return-l*j*(j-2)+k end;local function p(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,2)+k end;return-l/2*((j-1)*(j-3)-1)+k end;local function q(j,k,l,m)if j<m/2 then return o(j*2,k,l/2,m)end;return n(j*2-m,k+l/2,l/2,m)end;local function r(j,k,l,m)return l*b(j/m,3)+k end;local function s(j,k,l,m)return l*(b(j/m-1,3)+1)+k end;local function t(j,k,l,m)j=j/m*2;if j<1 then return l/2*j*j*j+k end;j=j-2;return l/2*(j*j*j+2)+k end;local function u(j,k,l,m)if j<m/2 then return s(j*2,k,l/2,m)end;return r(j*2-m,k+l/2,l/2,m)end;local function v(j,k,l,m)return l*b(j/m,4)+k end;local function w(j,k,l,m)return-l*(b(j/m-1,4)-1)+k end;local function x(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,4)+k end;return-l/2*(b(j-2,4)-2)+k end;local function y(j,k,l,m)if j<m/2 then return w(j*2,k,l/2,m)end;return v(j*2-m,k+l/2,l/2,m)end;local function z(j,k,l,m)return l*b(j/m,5)+k end;local function A(j,k,l,m)return l*(b(j/m-1,5)+1)+k end;local function B(j,k,l,m)j=j/m*2;if j<1 then return l/2*b(j,5)+k end;return l/2*(b(j-2,5)+2)+k end;local function C(j,k,l,m)if j<m/2 then return A(j*2,k,l/2,m)end;return z(j*2-m,k+l/2,l/2,m)end;local function D(j,k,l,m)return-l*d(j/m*e/2)+l+k end;local function E(j,k,l,m)return l*c(j/m*e/2)+k end;local function F(j,k,l,m)return-l/2*(d(e*j/m)-1)+k end;local function G(j,k,l,m)if j<m/2 then return E(j*2,k,l/2,m)end;return D(j*2-m,k+l/2,l/2,m)end;local function H(j,k,l,m)if j==0 then return k end;return l*b(2,10*(j/m-1))+k-l*0.001 end;local function I(j,k,l,m)if j==m then return k+l end;return l*1.001*(-b(2,-10*j/m)+1)+k end;local function J(j,k,l,m)if j==0 then return k end;if j==m then return k+l end;j=j/m*2;if j<1 then return l/2*b(2,10*(j-1))+k-l*0.0005 end;return l/2*1.0005*(-b(2,-10*(j-1))+2)+k end;local function K(j,k,l,m)if j<m/2 then return I(j*2,k,l/2,m)end;return H(j*2-m,k+l/2,l/2,m)end;local function L(j,k,l,m)return-l*(f(1-b(j/m,2))-1)+k end;local function M(j,k,l,m)return l*f(1-b(j/m-1,2))+k end;local function N(j,k,l,m)j=j/m*2;if j<1 then return-l/2*(f(1-j*j)-1)+k end;j=j-2;return l/2*(f(1-j*j)+1)+k end;local function O(j,k,l,m)if j<m/2 then return M(j*2,k,l/2,m)end;return L(j*2-m,k+l/2,l/2,m)end;local function P(Q,R,l,m)Q,R=Q or m*0.3,R or 0;if R<g(l)then return Q,l,Q/4 end;return Q,R,Q/(2*e)*h(l/R)end;local function S(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;return-(R*b(2,10*j)*c((j*m-T)*2*e/Q))+k end;local function U(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m;if j==1 then return k+l end;Q,R,T=P(Q,R,l,m)return R*b(2,-10*j)*c((j*m-T)*2*e/Q)+l+k end;local function V(j,k,l,m,R,Q)local T;if j==0 then return k end;j=j/m*2;if j==2 then return k+l end;Q,R,T=P(Q,R,l,m)j=j-1;if j<0 then return-0.5*R*b(2,10*j)*c((j*m-T)*2*e/Q)+k end;return R*b(2,-10*j)*c((j*m-T)*2*e/Q)*0.5+l+k end;local function W(j,k,l,m,R,Q)if j<m/2 then return U(j*2,k,l/2,m,R,Q)end;return S(j*2-m,k+l/2,l/2,m,R,Q)end;local function X(j,k,l,m,T)T=T or 1.70158;j=j/m;return l*j*j*((T+1)*j-T)+k end;local function Y(j,k,l,m,T)T=T or 1.70158;j=j/m-1;return l*(j*j*((T+1)*j+T)+1)+k end;local function Z(j,k,l,m,T)T=(T or 1.70158)*1.525;j=j/m*2;if j<1 then return l/2*j*j*((T+1)*j-T)+k end;j=j-2;return l/2*(j*j*((T+1)*j+T)+2)+k end;local function _(j,k,l,m,T)if j<m/2 then return Y(j*2,k,l/2,m,T)end;return X(j*2-m,k+l/2,l/2,m,T)end;local function a0(j,k,l,m)j=j/m;if j<1/2.75 then return l*7.5625*j*j+k end;if j<2/2.75 then j=j-1.5/2.75;return l*(7.5625*j*j+0.75)+k elseif j<2.5/2.75 then j=j-2.25/2.75;return l*(7.5625*j*j+0.9375)+k end;j=j-2.625/2.75;return l*(7.5625*j*j+0.984375)+k end;local function a1(j,k,l,m)return l-a0(m-j,0,l,m)+k end;local function a2(j,k,l,m)if j<m/2 then return a1(j*2,0,l,m)*0.5+k end;return a0(j*2-m,0,l,m)*0.5+l*.5+k end;local function a3(j,k,l,m)if j<m/2 then return a0(j*2,k,l/2,m)end;return a1(j*2-m,k+l/2,l/2,m)end;a.easing={linear=i,inQuad=n,outQuad=o,inOutQuad=p,outInQuad=q,inCubic=r,outCubic=s,inOutCubic=t,outInCubic=u,inQuart=v,outQuart=w,inOutQuart=x,outInQuart=y,inQuint=z,outQuint=A,inOutQuint=B,outInQuint=C,inSine=D,outSine=E,inOutSine=F,outInSine=G,inExpo=H,outExpo=I,inOutExpo=J,outInExpo=K,inCirc=L,outCirc=M,inOutCirc=N,outInCirc=O,inElastic=S,outElastic=U,inOutElastic=V,outInElastic=W,inBack=X,outBack=Y,inOutBack=Z,outInBack=_,inBounce=a1,outBounce=a0,inOutBounce=a2,outInBounce=a3}local function a4(a5,a6,a7)a7=a7 or a6;local a8=getmetatable(a6)if a8 and getmetatable(a5)==nil then setmetatable(a5,a8)end;for a9,aa in pairs(a6)do if type(aa)=="table"then a5[a9]=a4({},aa,a7[a9])else a5[a9]=a7[a9]end end;return a5 end;local function ab(ac,ad,ae)ae=ae or{}local af,ag;for a9,ah in pairs(ad)do af,ag=type(ah),a4({},ae)table.insert(ag,tostring(a9))if af=="number"then assert(type(ac[a9])=="number","Parameter '"..table.concat(ag,"/").."' is missing from subject or isn't a number")elseif af=="table"then ab(ac[a9],ah,ag)else assert(af=="number","Parameter '"..table.concat(ag,"/").."' must be a number or table of numbers")end end end;local function ai(aj,ac,ad,ak)assert(type(aj)=="number"and aj>0,"duration must be a positive number. Was "..tostring(aj))local al=type(ac)assert(al=="table"or al=="userdata","subject must be a table or userdata. Was "..tostring(ac))assert(type(ad)=="table","target must be a table. Was "..tostring(ad))assert(type(ak)=="function","easing must be a function. Was "..tostring(ak))ab(ac,ad)end;local function am(ak)ak=ak or"linear"if type(ak)=="string"then local an=ak;ak=a.easing[an]if type(ak)~="function"then error("The easing function name '"..an.."' is invalid")end end;return ak end;local function ao(ac,ad,ap,aq,aj,ak)local j,k,l,m;for a9,aa in pairs(ad)do if type(aa)=="table"then ao(ac[a9],aa,ap[a9],aq,aj,ak)else j,k,l,m=aq,ap[a9],aa-ap[a9],aj;ac[a9]=ak(j,k,l,m)end end end;local ar={}local as={__index=ar}function ar:set(aq)assert(type(aq)=="number","clock must be a positive number or 0")self.initial=self.initial or a4({},self.target,self.subject)self.clock=aq;if self.clock<=0 then self.clock=0;a4(self.subject,self.initial)elseif self.clock>=self.duration then self.clock=self.duration;a4(self.subject,self.target)else ao(self.subject,self.target,self.initial,self.clock,self.duration,self.easing)end;return self.clock>=self.duration end;function ar:reset()return self:set(0)end;function ar:update(at)assert(type(at)=="number","dt must be a number")return self:set(self.clock+at)end;function a.new(aj,ac,ad,ak)ak=am(ak)ai(aj,ac,ad,ak)return setmetatable({duration=aj,subject=ac,target=ad,easing=ak,clock=0},as)end;return a end)()
local tween_table = {}
local tween_data = {
    kb_alpha = 0,
    wm_alpha = 0
}
local refs = {
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    fl = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
}

--main
function tween_updater()
    for _, t in pairs(tween_table) do
        t:update(globals.frametime)
    end
end
events.render:set(tween_updater)

--watermark
function watermark()
    if solus_select:get('Watermark') then
    local x,y = render.screen_size().x, render.screen_size().y
    local lp = entity.get_local_player()

    local net = utils.net_channel()
    local time = common.get_system_time()
    local time_text = string.format('%02d:%02d', time.hours, time.minutes)
    if lp == nil then return end
    local ping = net.avg_latency[0]
    local ping = math.floor(net.avg_latency[0] * 1000)
    
    local maximum_off = 28
    local text_w = render.measure_text(1, nil, "Femboy.sense  "..custom_name:get().."  "..time_text.."").x - 30
    maximum_off = maximum_off < text_w and text_w or maximum_off
    local w = 108 - maximum_off

    render.gradient(vector(x - 257 - 2 + w, y/60 - 6 - 2), vector(x - 7 + 1, y/60 + 12 + 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(0, 0, 0, 0), color(0, 0, 0, 0), slider_ref:get())
    render.gradient(vector(x - 257 - 2 + w, y/60 - 6 - 2), vector(x - 7 + 1, y/60 + 12 + 2), color(0, 0, 0, 0), color(0, 0, 0, 0), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), slider_ref:get())
    render.blur(vector(x - 257 + w, y/60 - 6), vector(x - 7, y/52 + 12), 10, 1, slider_ref:get())

    --render.rect(vector(x - 257 + w, y/2 1005 - 6), vector(x - 7, y/2 1002 + 16), color(0, 0, 0, 190), slider_ref:get())

    --render.rect(vector(x/1.09 - 5, y/60 - 6), vector(x/1.09 + 153, y/60 + 16), color(0, 0, 0, 190), slider_ref:get())
    --render.rect(vector(x - 18, y - 35), vector(x + 18, y + 35), color(0, 0, 0, 255), slider_ref:get())

    render.text(1, vector(x - 237 - 5 + w, y/60 - 4), color(255, 255, 255, 255), nil, "Femboy.sense")
    render.text(1, vector(x - 219 + w, y/60 - 4), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), nil, "Femboy.sense")
    render.text(1, vector(x - 176 + w, y/60 - 4), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, math.pulse()), nil, "[debug]")
    render.text(1, vector(x - 130 + w, y/60 - 4), color(255, 255, 255, 255), nil, ""..custom_name:get().." ")
    render.text(1, vector(x - 183 - 5 + w + render.measure_text(1, nil, "Femboy.sense  "..custom_name:get().."").x, y/60 - 4), color(255, 255, 255, 255), "nil", ""..ping.."ms")
    render.text(1, vector(x - 153 - 5 + w + render.measure_text(1, nil, "Femboy.sense  "..custom_name:get().."").x, y/60 - 4), color(255, 255, 255, 255), nil, "  "..time_text.."")
end
end
events.render:set(watermark)

--choke indication
current_choke = 0
function choke()
    local lp = entity.get_local_player()
    if lp == nil then return end
    current_choke = globals.choked_commands
    utils.execute_after(0.4, choke)
end
utils.execute_after(0.4, choke)


function statepanel()
    if solus_select:get('Watermark') and solus_select:get('Choke Indication') then
    local x,y = render.screen_size().x, render.screen_size().y
    local lp = entity.get_local_player()
    if lp == nil then return end
    local maximum_off = 0
    local net = utils.net_channel()
    local maximum_off = 28
    local fake_delta = desync_delta()
    current_fl = current_choke

    if refs.dt:get() or refs.hs:get() then
        text = '  FL: '..current_fl..' | SHIFTING'
        maximum_off = 60
    else
        text = 'FL: '..current_fl..''
        maximum_off = 115
    end

    local text_w = render.measure_text(1, "c", ""..text.."").x - 30
    maximum_off = maximum_off < text_w and text_w or maximum_off
    local w = 108 - maximum_off

    --render.rect(vector(x - 165 + w, y/60 - 6), vector(x - 7, y/60 + 16), color(0, 0, 0, 190), 7)

    tween_table.wm_alpha = tween.new(0.25, tween_data, {wm_alpha = w}, 'outCubic');w = tween_data.wm_alpha
    
    if solus_select:get('Watermark') and solus_select:get('Choke Indication') then
        render.gradient(vector(x - 60 - 2 - w, y/22 - 6 - 2), vector(x - 7 + 2, y/22 + 12 + 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(0, 0, 0, 0), color(0, 0, 0, 0), slider_ref:get())
        render.gradient(vector(x - 60 - 2 - w, y/22 - 6 - 2), vector(x - 7 + 2, y/22 + 12 + 2), color(0, 0, 0, 0), color(0, 0, 0, 0), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, 255), slider_ref:get())
    end
    
    render.blur(vector(x - 60 - w, y/22 - 6), vector(x - 6, y/20 + 10), 10, 1, slider_ref:get())

   if refs.dt:get() or refs.hs:get() then
        render.text(1, vector(x - 52 - 8, y/22 + 2), color(255, 255, 255, 255), "c", ""..text.."")
    else
        render.text(1, vector(x - 52 + 23, y/22 + 2), color(255, 255, 255, 255), "c", ""..text.."")
    end
end
end
events.render:set(statepanel)
--
function desync_delta()
    local desync_rotation = rage.antiaim:get_rotation()
    local delta_to_draw = math.min(math.abs(desync_rotation) / 2, 60)
    return string.format("%.1f", delta_to_draw)
end
--
jmp_ecx = utils.opcode_scan('engine.dll', 'FF E1')
fnGetModuleHandle = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)', jmp_ecx)
fnGetProcAddress = ffi.cast('uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)', jmp_ecx)
pGetProcAddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', utils.opcode_scan('engine.dll', 'FF 15 ? ? ? ? A3 ? ? ? ? EB 05')) + 2)[0][0]
pGetModuleHandle = ffi.cast('uint32_t**', ffi.cast('uint32_t', utils.opcode_scan('engine.dll', 'FF 15 ? ? ? ? 85 C0 74 0B')) + 2)[0][0]
function BindExports(sModuleName, sFunctionName, sTypeOf)
    local ctype = ffi.typeof(sTypeOf)
    return function(...)
        return ffi.cast(ctype, jmp_ecx)(fnGetProcAddress(pGetProcAddress, 0, fnGetModuleHandle(pGetModuleHandle, 0, sModuleName), sFunctionName), 0, ...)
    end
end
fnEnumDisplaySettingsA = BindExports('user32.dll', 'EnumDisplaySettingsA', 'int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)');
pLpDevMode = ffi.new('struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]')
fnEnumDisplaySettingsA(0, 4294967295, pLpDevMode[0])

--keybinds
local animations = {
	
	speed = 9.2,
	stored_values = {},
	active_this_frame = {},
	prev_realtime = globals.realtime,
    realtime = globals.realtime,
    multiplier = 0.0,

	
    clamp = function(v, min, max)
		return ((v > max) and max) or ((v < min) and min or v)
	end,

	
    new_frame = function(self)
    	self.prev_realtime = self.realtime
        self.realtime = globals.realtime
        self.multiplier = (self.realtime - self.prev_realtime) * self.speed
        
        for k, v in pairs(self.stored_values) do
            if self.active_this_frame[k] ~= nil then goto continue end
			self.stored_values[k] = nil
			::continue::
        end

        self.active_this_frame = {}
    end,
    reset = function(self, name)
        self.stored_values[name] = nil
    end,
    
    
    animate = function (self, name, decrement, max_value)
        max_value = max_value or 1.0
		decrement = decrement or false

        local frames = self.multiplier * (decrement and -1 or 1)

		local v = self.clamp(self.stored_values[name] and self.stored_values[name] or 0.0, 0.0, max_value) 
        v = self.clamp(v + frames, 0.0, max_value)

        self.stored_values[name] = v
        self.active_this_frame[name] = true

        return v
    end
}

local memory = { x, y }
local drag_items = {
    x_slider = ind1:slider("X position", 0, 2560, 50.0, 0.01),
    y_slider= ind1:slider("Y position", 0, 1440, 50.0, 0.01)
}
drag_items.x_slider:set_visible(false)
drag_items.y_slider:set_visible(false)

local drag_window = function(x, y, w, h, val1, val2)
    local key_pressed  = common.is_button_down(0x01);
    local mouse_pos    = ui.get_mouse_position()

    if mouse_pos.x >= x and mouse_pos.x <= x + w and mouse_pos.y >= y and mouse_pos.y <= y + h then
        if key_pressed and drag == false then
            drag = true;
            memory.x = x - mouse_pos.x;
            memory.y = y - mouse_pos.y;
        end
    end

    if not key_pressed then
        drag = false;
    end

    if drag == true and ui.get_alpha() == 1 then
        val1:set(mouse_pos.x + memory.x);
        val2:set(mouse_pos.y + memory.y);
    end
end

local function render_conteiner(x, y, w, h, name, font_size, font, alpha)
    if solus_select:get('Keybinds') then
    local alpha2 = (alpha/350)
    local name_size = render.measure_text(1, nil, name)
    
    render.gradient(vector(x + 1 - 2, y - 4 - 2), vector(x + w + 1 + 2, y + h - 2), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(0, 0, 0, alpha*0), color(0, 0, 0, alpha*0), slider_ref:get())
    render.gradient(vector(x + 1 - 2, y - 4 - 2), vector(x + w + 1 + 2, y + h - 2), color(0, 0, 0, alpha*0), color(0, 0, 0, alpha*0), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), color(color_picker:get().r, color_picker:get().g, color_picker:get().b, alpha), slider_ref:get())
    render.blur(vector(x + 1, y - 4), vector(x + w + 2, y + h - 3), 10, alpha*1, slider_ref:get())

    render.text(1, vector(x-1 + w / 2 + 1 - name_size.x / 2, y - 1.5), color(255, 255, 255, alpha), nil, name)
    end
end


local function keybinds()
    if solus_select:get('Keybinds') then
    animations:new_frame()
    local binds = ui.get_binds()
    local j = 0
    local m_alpha = 0
    local maximum_offset = 28
    local kb_shown = false

    for i = 1, #binds do
        local c_name = binds[i].name
        if c_name == 'Peek Assist' then c_name = 'Quick peek' end
        if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
        if c_name == 'Hide Shots' then c_name = 'On shot anti-aim' end
        if c_name == 'Minimum Damage' then c_name = 'Damage override' end
        if c_name == 'Fake Latency' then c_name = 'Ping spike' end
        if c_name == 'Fake Duck' then c_name = 'Duck peek assist' end
        if c_name == 'Safe Points' then c_name = 'Safe point' end
        if c_name == 'Body Aim' then c_name = 'Body aim' end
        if c_name == 'Yaw Base' then c_name = 'Manual override' end
        if c_name == 'Slow Walk' then c_name = 'Slow motion' end
        
        local text_width = render.measure_text(1, nil, c_name).x - 30

        if binds[i].active then
            kb_shown = true
            maximum_offset = maximum_offset < text_width and text_width or maximum_offset
        end 
    end

    local w = 90 + maximum_offset
    local x,y = drag_items.x_slider:get(), drag_items.y_slider:get()

    m_alpha = animations:animate('state', not (kb_shown or ui.get_alpha() == 1))
    tween_table.kb_alpha = tween.new(0.25, tween_data, {kb_alpha = w}, 'outCubic');w = tween_data.kb_alpha

    render_conteiner(x-1, y, w, 17, 'keybinds', 11, 1, math.floor(tonumber(m_alpha*255)))
    --Render.BoxFilled(vector(x, y), vector(x + w, y + 18), Color.new(0,0,0,1*m_alpha))
    --Render.BoxFilled(vector(x, y), vector(x + w, y + 2), Color.new(173/255, 249/255, 1,1*m_alpha))

    --Render.Text(' ' .. 'keybinds', vector(x - Render.CalcTextSize('keybinds', 11, font).x / 2 + w/2, y + 4), Color.new(1.0, 1.0, 1.0, 1*m_alpha), 11, 1, false)

    for i=1, #binds do
        local alpha = animations:animate(binds[i].name, not binds[i].active)
        local get_mode = binds[i].mode == 1 and '[holding]' or (binds[i].mode == 2 and '[toggled]') or '[?]'

        local c_name = binds[i].name
        if c_name == 'Peek Assist' then c_name = 'Quick peek' end
        if c_name == 'Edge Jump' then c_name = 'Jump at edge' end
        if c_name == 'Hide Shots' then c_name = 'On shot anti-aim' end
        if c_name == 'Minimum Damage' then c_name = 'Damage override' end
        if c_name == 'Fake Latency' then c_name = 'Ping spike' end
        if c_name == 'Fake Duck' then c_name = 'Duck peek assist' end
        if c_name == 'Safe Points' then c_name = 'Safe point' end
        if c_name == 'Body Aim' then c_name = 'Body aim' end
        if c_name == 'Double Tap' then c_name = 'Double tap' end
        if c_name == 'Yaw Base' then c_name = 'Manual override' end
        if c_name == 'Slow Walk' then c_name = 'Slow motion' end


        local get_value = binds[i].value
        if c_name == 'Damage override' or c_name == 'Ping spike' or c_name == 'Manual Yaw' then
            render.text(1, vector(x + 2, y + 20 + j), color(255, 255, 255, alpha*255), nil, c_name)
            render.text(1, vector(x - 12 + w - render.measure_text(1, nil, get_value).x , y + 20 + j), color(255, 255, 255, alpha*255), nil, "["..get_value.."]")
        else
            render.text(1, vector(x + 2, y + 20 + j), color(255, 255, 255, alpha*255), nil, c_name)
            render.text(1, vector(x - 2 + w - render.measure_text(1, nil, get_mode).x , y + 20 + j), color(255, 255, 255, alpha*255), nil, '' .. get_mode)
        end

        j = j + 15*alpha
        ::skip::
    end

    drag_window(x, y, 150, 25, drag_items.x_slider, drag_items.y_slider)
end
end
events.render:set(keybinds)


-- Ragebot logs


math.lerp = function(name, value, speed)
    return name + (value - name) * globals.frametime * speed
end

local logs, font, screen_size = {}, render.load_font("nl\\opensource\\smallest-pixel.ttf", 10, "o"), render.screen_size()

events.render:set(function()
    local offset, x, y = 0, screen_size.x / 2, screen_size.y / 1.4

    for idx, data in ipairs(logs) do
        if not globals.is_connected and not globals.is_in_game then return false end
        if globals.curtime - data[3] < 7.0 and not (#logs > 10 and idx < #logs - 10) then
            data[2] = math.lerp(data[2], 255, 4)
        else
            data[2] = math.lerp(data[2], 0, 4)
        end

        offset = offset - 21 * (data[2] / 255)

        text_size = render.measure_text(font, s, data[1])
        left, middle, right = color(0, 200, 255, data[2]), color(255, 0, 238, data[2]), color(255, 234, 0, data[2])
        render.push_clip_rect(vector(x - 3 - text_size.x / 2, y - offset + 1), vector((x + 3 + text_size.x / 2) - ((globals.curtime - data[3]) / 7) * (text_size.x + 3), y - offset + 2))
        render.gradient(vector(x - 3 - text_size.x / 2, y - offset + 1), vector(x, y - offset + 2), left, middle, left, middle)
        render.gradient(vector(x, y - offset + 1), vector(x + 3 + text_size.x / 2, y - offset + 2), middle, right, middle, right)
        render.pop_clip_rect()

        render.rect(vector(x - 4 - text_size.x / 2, y - offset), vector(x + 4 + text_size.x / 2, y - offset + 15), color(17, 17, 17, (data[2] / 255) * 175))
        render.text(font, vector(x - text_size.x / 2, y - offset + 2), color(255, 255, 255, (data[2] / 255) * 255), nil, data[1])

        if data[2] < 0.1 then table.remove(logs, idx) end
    end
end)

render.log = function(text, size)
    table.insert(logs, { text, 0, globals.curtime, size })
end

local hitgroup_str = {
    [0] = 'generic',
    'head', 'chest', 'stomach',
    'left arm', 'right arm',
    'left leg', 'right leg',
    'neck', 'generic', 'gear'
}

events.aim_ack:set(function(e)
    local me = entity.get_local_player()
    local target = entity.get(e.target)
    local damage = e.damage
    local wanted_damage = e.wanted_damage
    local wanted_hitgroup = hitgroup_str[e.wanted_hitgroup]
    local hitchance = e.hitchance
    local state = e.state
    local bt = e.backtrack
    if not target then return end
    if target == nil then return end
    local health = target["m_iHealth"]


    local hitgroup = hitgroup_str[e.hitgroup]

    if enablelogs:get() and state == nil then
    if not globals.is_connected and not globals.is_in_game then return false end
    if logs_select:get('Screen') then
        render.log(("Hit \a8FB9FFFF%s's \aFFFFFFFF%s for \aA1FF8FFF%d\aFFFFFFFF ("..string.format("%.f", wanted_damage)..") [bt: \aA1FF8FFF%s \aFFFFFFFF| hp: \aA1FF8FFF"..health.."\aFFFFFFFF]"):format(target:get_name(), hitgroup, e.damage, bt))
    end
    if logs_select:get('Console') then
        print_raw(("\a4562FF[Femboy.sense] » \aA0FB87Registered \aD5D5D5shot at %s's %s for \aA0FB87%d("..string.format("%.f", wanted_damage)..") \aD5D5D5damage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
    end
    if logs_select:get('Dev') then
        print_dev(("[Femboy.sense] Registered shot at %s's %s for %d("..string.format("%.f", wanted_damage)..") damage (hp: "..health..") (aimed: "..wanted_hitgroup..") (bt: %s)"):format(target:get_name(), hitgroup, e.damage, bt))
    end
    elseif enablelogs:get() then
    if logs_select:get('Screen') then
        render.log(('Missed \a8FB9FFFF%s \aFFFFFFFFin the %s due to \aE94B4BFF'..state..' \aFFFFFFFF(hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
    end
    if logs_select:get('Console') then
        print_raw(('\a4562FF[Femboy.sense] » \aE94B4BMissed \aFFFFFFshot in %s in the %s due to \aE94B4B'..state..' \aFFFFFF(hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
    end
    if logs_select:get('Dev') then
        print_dev(('[Femboy.sense] Missed shot in %s in the %s due to '..state..' (hc: '..string.format("%.f", hitchance)..') (damage: '..string.format("%.f", wanted_damage)..')'):format(target:get_name(), wanted_hitgroup, state1))
    end
end
end)

events.player_hurt:set(function(e)
    local me = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)
    local weapon = e.weapon
    local type_hit = 'Hit'

    if weapon == 'hegrenade' then 
        type_hit = 'Naded'
    end

    if weapon == 'inferno' then
        type_hit = 'Burned'
    end

    if weapon == 'knife' then 
        type_hit = 'Knifed'
    end

    if weapon == 'hegrenade' or weapon == 'inferno' or weapon == 'knife' then

    if me == attacker then
        local user = entity.get(e.userid, true)
        if enablelogs:get() then
        print_raw(('\a4562FF[Femboy.sense] \aD5D5D5'..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
        render.log((''..type_hit..' %s for %d damage (%d health remaining)'):format(user:get_name(), e.dmg_health, e.health))
    end

    end--]]
end
end)

-- Misc (clantag, viewmodel, aspect ratio)
iconctag = ui.get_icon("user-tag")
local ctagenable = misctab:switch(iconctag..  "  UwU Clantag")
iconvm = ui.get_icon("hand-paper")
viewmodel_enable = misctab:switch(iconvm..  "  UwU Viewmodel")
iconaspect = ui.get_icon("desktop")
aspect_ratio_enable = misctab:switch(iconaspect..  "  Aspect ratio")

local tag = {
    "F",
    "Fe",
    "Fem",
    "Femb",
    "Fembo",
    "Femboy",
    "Femboy.s",
    "Femboy.se",
    "Femboy.sen",
    "Femboy.sens",
    "Femboy.sense",
    "Femboy.sens",
    "Femboy.sen",
    "Femboy.se",
    "Femboy.s",
    "Femboy",
    "Fembo",
    "Femb",
    "Fem",
    "Fe",
    "F",
    " "
  }
  local function getClantag()
      local net = utils.net_channel()
      if net == nil then return end
    local latency = net.latency[0] / globals.tickinterval
    local tickcount_pred = globals.tickcount + latency
    local iter = math.floor(math.fmod(tickcount_pred / 16, #tag + 1) + 1)
    return tag[iter]
  end
  
  local _last_clantag = nil
  local function set_tag(tag)
      if tag == _last_clantag then return end
    if tag == nil then return end
    common.set_clan_tag(tag)
    _last_clantag = tag
  end
  
  events.render:set(function()
    if ctagenable:get() then
    set_tag(getClantag())
    else
        set_tag(" Femboy.sense ")
    end
end)

viewmodel_ref = viewmodel_enable:create()
viewmodel_fov = viewmodel_ref:slider("FOV", -100, 100, 68)
viewmodel_x = viewmodel_ref:slider("X", -10, 10, 2.5)
viewmodel_y = viewmodel_ref:slider("Y", -10, 10, 0)
viewmodel_z = viewmodel_ref:slider("Z", -10, 10, -1.5)

aspectratio_ref = aspect_ratio_enable:create()
aspect_ratio_slider = aspectratio_ref:slider("Value", 0, 20, 0, 0.1)

events.createmove:set(function()
    if aspect_ratio_enable:get() then
        cvar.r_aspectratio:float(aspect_ratio_slider:get()/10)
    else
        cvar.r_aspectratio:float(0)
    end
end)

events.createmove:set(function()
    if viewmodel_enable:get() then
        cvar.viewmodel_fov:int(viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(viewmodel_x:get(), true)
		cvar.viewmodel_offset_y:float(viewmodel_y:get(), true)
		cvar.viewmodel_offset_z:float(viewmodel_z:get(), true)
    else
        cvar.viewmodel_fov:int(68)
        cvar.viewmodel_offset_x:float(2.5)
        cvar.viewmodel_offset_y:float(0)
        cvar.viewmodel_offset_z:float(-1.5)
    end
end)

events.shutdown:set(function()
    cvar.viewmodel_fov:int(68)
    cvar.viewmodel_offset_x:float(2.5)
    cvar.viewmodel_offset_y:float(0)
    cvar.viewmodel_offset_z:float(-1.5)
end)

-- Velocity indicator
iconvelo = ui.get_icon("exclamation-triangle")
velocity_indicator_enable = ind1:switch(iconvelo..  "  UwU Velocity Warning")
velocity_indicator_gear = velocity_indicator_enable:create("UwU Velocity Warning")
velocity_enable_image = velocity_indicator_gear:switch("Warning Icon", true)
velocity_indicator_color_1 = velocity_indicator_gear:color_picker("Color First", color(255, 255, 255, 255))
velocity_indicator_color_2 = velocity_indicator_gear:color_picker("Color Second", color(120, 120, 255, 255))
velocity_color = velocity_indicator_gear:color_picker("Velocity Color", color(255, 255, 255, 255))
velocity_image_color = velocity_indicator_gear:color_picker("Icon Color", color(255, 255, 255, 255))

-- main funcs
function renders.shadowtext(font, position, colorr, text)
    render.text(font, position + 1, color(0, 0, 0, colorr.a), nil, text)
    render.text(font, position, colorr, nil, text)
end

function math.lerpp(from, to, time)
    return from + (to - from) * time
end

function main.is_menu_opened()
    if ui.get_alpha() > 0 then
        return true
    else
        return false
    end
end
    


-- drag system
function class()
local class = {}
local mClass = {__index = class}
function class.instance() return setmetatable({}, mClass) end
    return class
end

local velocity_indicator_t = class()

function velocity_indicator_t:new(x, y, w)
    local self = velocity_indicator_t.instance()
    self.x, self.y, self.w, self.h = x or 200, y or 400, w or 160, 20
    self.drag_x, self.drag_y = 0, 0
    self.is_dragging = false
    return self
end

function velocity_indicator_t:drag()
local m = ui.get_mouse_position()
local is_hovered = (m.x > (self.x) and m.x < (self.x + self.w) and m.y > (self.y) and m.y < (self.y + self.h))

if is_hovered then
    if common.is_button_down(1) and not self.is_dragging then
        self.is_dragging = true
   
        self.drag_x = self.x - m.x
        self.drag_y = self.y - m.y
    end
end
if not common.is_button_down(1) then
    self.is_dragging = false
end
if self.is_dragging and main.is_menu_opened() then
    self.x = (self.drag_x + m.x)
    self.y = (self.drag_y + m.y)
end
end

function velocity_indicator_t:paint() end
function velocity_indicator_t:draw()self:paint()self:drag()end

local velocity_indicator_pos = {}

velocity_indicator_pos.x = ind1:slider("vel_pos_x", -1, render.screen_size().x, 870)
velocity_indicator_pos.y = ind1:slider("vel_pos_y", -1, render.screen_size().y, 275)
local velocity_indicator_p = velocity_indicator_t:new(
velocity_indicator_pos.x:get(),
velocity_indicator_pos.y:get(),
160

)

velocity_indicator_pos.x:set_visible(false)
velocity_indicator_pos.y:set_visible(false)

--  main vars
main.font = render.load_font("nl\\opensource\\smallest-pixel.ttf", 10, "a")
main.gamedir = string.sub(common.get_game_directory() , 0 , -5)
main.size = 0
main.vel_alpha = 0
main.vector = 0
-- render
velocity_warning = render.load_image_from_file('nl\\opensource\\velocity_warning.png', vector(75, 61))
function velocity_indicator_p:paint()
    if velocity_indicator_enable:get() and entity.get_local_player() then
        
        local vel_mod = entity.get_local_player().m_flVelocityModifier
        
        if main.is_menu_opened() or vel_mod < 1 then
            main.vel_alpha = math.lerpp(main.vel_alpha, 1, globals.frametime * 12)
        else
            main.vel_alpha = math.lerpp(main.vel_alpha, 0, globals.frametime * 12)
        end

        main.size = vel_mod * 160 == 160 and math.lerpp(vel_mod * 160, main.size, globals.frametime * 4) or math.lerpp(main.size, vel_mod * 160, globals.frametime * 4)
        local x,y,w = self.x, self.y, self.w
        -- gradient
        local gc1, gc2 = velocity_indicator_color_1:get(), velocity_indicator_color_2:get()
        local gradient1, gradient2 = color(gc1.r, gc1.g, gc1.b, math.floor(main.vel_alpha * 255)), color(gc2.r, gc2.g, gc2.b, math.floor(main.vel_alpha * 255))
        -- velocity color
        local vc = velocity_color:get()
        local vcc = color(vc.r, vc.g, vc.b, math.floor(main.vel_alpha * 255))
        -- image color
        local vic = velocity_image_color:get()
        local vicc = color(vic.r, vic.g, vic.b, math.floor(main.vel_alpha * 255))
        if not entity.get_local_player():is_alive() then return false end
        if velocity_enable_image:get() then
        render.texture(velocity_warning, vector(x + w / 2  - 21, y - 57), vector(75, 61), vicc)
        end
        render.rect(vector(x+35, y), vector(x + w, y + 18), color(16, 16, 16, math.floor(main.vel_alpha * 255)), 6)
        render.gradient(vector(x+35, y), vector(x + main.size, y + 18), gradient1, gradient2, gradient1, gradient2, 6)
        renders.shadowtext(main.font, vector(x + w / 2  - 21, y + 3), vcc, "Slowed Down " ..math.floor(vel_mod * 100).."%")


    end

    velocity_indicator_pos.x:set(self.x)
    velocity_indicator_pos.y:set(self.y)

end

events.render:set(function(ctx)
    velocity_indicator_p:paint(); velocity_indicator_p:drag()
end)

esp.enemy:new_text("Lethal Indicator (only scout)", "lethal", function(player)
	local health = player.m_iHealth

	if health <= 93 then
		return "lethal"
	end
end)

--######
--######
--######


local world_main_ref = ui.find("visuals", 'world', 'main')
local main_in_game_ref = ui.find('miscellaneous', 'main', 'in-game')

local aspect_ratio_switch_ref = world_main_ref:switch("Aspect Ratio", false)
local aspect_ratio_switch_group_ref = aspect_ratio_switch_ref:create()
local aspect_ratio_combo_ref = aspect_ratio_switch_group_ref:slider("Value", 0, 20, 0, 0.1)

--local viewmodel_switch_ref = group_ref:switch("Viewmodel", false)
local viewmodel_switch_ref = ui.find('visuals', 'world', 'main', 'field of view')
local viewmodel_switch_group_ref = viewmodel_switch_ref:create()
local viewmodel_fov_combo_ref = viewmodel_switch_group_ref:slider("FOV", 0, 100, cvar.viewmodel_fov:float())
local viewmodel_x_combo_ref = viewmodel_switch_group_ref:slider("X", -10, 10, cvar.viewmodel_offset_x:float())
local viewmodel_y_combo_ref = viewmodel_switch_group_ref:slider("Y", -10, 10, cvar.viewmodel_offset_y:float())
local viewmodel_z_combo_ref = viewmodel_switch_group_ref:slider("Z", -10, 10, cvar.viewmodel_offset_z:float())

local clantag_switch_ref = main_in_game_ref:label("Static Clantag")
local clantag_switch_group_ref = clantag_switch_ref:create()
local clantag_input_combo_ref = clantag_switch_group_ref:input("Clantag")
local clantag_button_combo_ref = clantag_switch_group_ref:button("Update")

local name_switch_ref = main_in_game_ref:label("Name")
local name_switch_group_ref = name_switch_ref:create()
local name_input_combo_ref = name_switch_group_ref:input("Name")
local name_button_combo_ref = name_switch_group_ref:button("Update")

-- On load

if aspect_ratio_switch_ref:get() then
	cvar.r_aspectratio:float(aspect_ratio_combo_ref:get()/10)
end

local updateViewmodel = function()
	if viewmodel_switch_ref:get() then
		cvar.viewmodel_fov:int(viewmodel_fov_combo_ref:get(), true)
		cvar.viewmodel_offset_x:float(viewmodel_x_combo_ref:get(), true)
		cvar.viewmodel_offset_y:float(viewmodel_y_combo_ref:get(), true)
		cvar.viewmodel_offset_z:float(viewmodel_z_combo_ref:get(), true)
	end
end

updateViewmodel()

-- End on load

aspect_ratio_switch_ref:set_callback(function(ref)
	local enabled = ref:get()
	if enabled then
		cvar.r_aspectratio:float(aspect_ratio_combo_ref:get()/10)
	else
		cvar.r_aspectratio:float(0)
	end
end)

aspect_ratio_combo_ref:set_callback(function(ref)
	local enabled = aspect_ratio_switch_ref:get()
	if enabled then
		cvar.r_aspectratio:float(ref:get()/10)
	end
end)

viewmodel_switch_ref:set_callback(updateViewmodel)
viewmodel_fov_combo_ref:set_callback(updateViewmodel)
viewmodel_x_combo_ref:set_callback(updateViewmodel)
viewmodel_y_combo_ref:set_callback(updateViewmodel)
viewmodel_z_combo_ref:set_callback(updateViewmodel)

clantag_button_combo_ref:set_callback(function(ref)
	common.set_clan_tag(clantag_input_combo_ref:get())
end)

name_button_combo_ref:set_callback(function(ref)
	common.set_name(name_input_combo_ref:get())
end)

-- Shutdown

events.shutdown:set(function()
	cvar.r_aspectratio:float(0)
end)							




local clipboard = require "neverlose/clipboard"
local base64 = require("neverlose/base64")
 
local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end
 
    return output
end
 
local ffi_helpers = {
 
    bind_argument = function(fn, arg)
        return function(...)
            return fn(arg, ...)
        end
    end,
 
 
    open_link = function (link)
        local steam_overlay_API = panorama.SteamOverlayAPI
        local open_external_browser_url = steam_overlay_API.OpenExternalBrowserURL
        open_external_browser_url(link)
    end,
 
 
}
 
local ffi = require('ffi')
local ffi_handler = {}
local renders = {}
local main = {}
ffi.cdef[[
    bool URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    bool CreateDirectoryA(
        const char*                lpPathName,
        void*                      lpSecurityAttributes
    );
]]
local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
ffi_handler.download_file = function(url, path)
    wininet.DeleteUrlCacheEntryA(url)
    urlmon.URLDownloadToFileA(nil, url, path, 0,0)
end  
 
 
 
 
 
local texd = gradient_text(50,245,215,255,75,85,240,255,'Config manager by RelentlessHvH')
 
 
 
local cheat_username = common.get_username()
local hellouser = "Welcome "..cheat_username.."!"
 
local logo = ui.create("Media", hellouser)
main.gamedir = string.sub(common.get_game_directory() , 0 , -5)
 
ffi.C.CreateDirectoryA("nl\\NdrsCfgs", nil)
 
local menu = ui.create("Home","Media")
menu:button("  NDR hvh king                ",function ()
    ffi_helpers.open_link('https://cardemitdeiner.cc/')
end)
 
 
 
local tab = ui.create("Configs","Rage")
local tab2 = ui.create("Configs","Players")
local tab3 = ui.create("Configs","World")
local tab4 = ui.create("Configs", "Misc")
 
local weapon_groups = {"Global" , "Pistols" , "Autosnipers" , "Rifles" , "SMGs" , "Shotguns" , "AWP" , "SSG-08" , "AK-47" , "Desert Eagle" , "R8 Revolver" , "Taser"}
 
tab:label("From here you export rage settings")
tab:label("")
tab2:label("From here you export player visuals")
tab2:label("Be careful, it won't export flags                    ")
tab3:label("From here you export world visuals")
tab3:label("")
tab4:label("From here you can export misc")
tab4:label("")
 
local settings = {}
 
for k , v in ipairs(weapon_groups) do 
     settings[v] =
     {
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Scope"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Options"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Double Tap"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Dynamic Mode"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Force Accuracy"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Hitboxes"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint", "Head Scale"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint", "Body Scale"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Minimum Damage"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Minimum Damage", "Delay Shot"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Hit Chance"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Hit Chance", "Strict Hit Chance"),
        ui.find("Aimbot", "Ragebot", "Safety", v, "Body Aim") ,
        ui.find("Aimbot", "Ragebot", "Safety", v, "Body Aim", "Disablers"),
        ui.find("Aimbot", "Ragebot", "Safety", v, "Safe Points"),
        ui.find("Aimbot", "Ragebot", "Safety", v, "Ensure Hitbox Safety"),
        ui.find("Aimbot", "Ragebot", "Selection", v , "Penetrate Walls")
     }
end
 
function export_weapons()
    local cfg = {}
 
    for k , v in ipairs(weapon_groups) do 
        cfg[v] = {}
        for _ , i in pairs(settings[v]) do 
            cfg[v][i:get_name()] = i:get()
        end
    end
 
    local encode_rage = base64.encode(json.stringify(cfg))
 
    clipboard.set(encode_rage)
 
    common.add_notify("Exported rage settings!","Done!")
 
end
 
function import_weapons()
    local decode_rage = base64.decode(clipboard.get())
 
    local cfg = json.parse(decode_rage)
 
    for k , v in ipairs(weapon_groups) do 
        for _ , i in pairs(settings[v]) do
            i:set(cfg[v][i:get_name()])
        end
    end
 
    common.add_notify("Imported rage settings!","Done!")
 
end
 
tab:button("Export" , function ()
    export_weapons()
end)
 
tab:button("Import" , function ()
    import_weapons()
end)
 
local allVisualsUnpack = {}
local allVisuals = {
    -- players enemies
    ui.find("visuals","players","enemies","esp","behind walls"),
    ui.find("visuals","players","enemies","esp","dormant"),
    ui.find("visuals","players","enemies","esp","shared esp"),
    ui.find("visuals","players","enemies","esp","shared esp","share with enemies"),
    ui.find("visuals","players","enemies","esp","in-game radar"),
    ui.find("visuals","players","enemies","esp","bullet tracer"),
    ui.find("visuals","players","enemies","esp","bullet tracer","style"),
    ui.find("visuals","players","enemies","esp","bullet tracer","color"), 
    ui.find("visuals","players","enemies","esp","offscreen ESP"),   
    ui.find("visuals","players","enemies","esp","offscreen ESP","radius"),
    ui.find("visuals","players","enemies","esp","offscreen ESP","size"),
    ui.find("visuals","players","enemies","esp","offscreen ESP","color"),
    ui.find("visuals","players","enemies","esp","offscreen ESP","pulsing"),
    {ui.find("visuals","players","enemies","esp","sounds")},
    ui.find("visuals","players","enemies","chams","model"),
    {ui.find("visuals","players","enemies","chams","model","visible")},
    {ui.find("visuals","players","enemies","chams","model","invisible")},
    {ui.find("visuals","players","enemies","chams","model","style")},
    ui.find("visuals","players","enemies","chams","model","no occlusion"),
    ui.find("visuals","players","enemies","chams","model","outline"),
    ui.find("visuals","players","enemies","chams","model","brightness"),
    ui.find("visuals","players","enemies","chams","model","fill"),
    ui.find("visuals","players","enemies","chams","model","reflectivity"),
    ui.find("visuals","players","enemies","chams","model","pearlescent"),
    ui.find("visuals","players","enemies","chams","model","shine"),
    ui.find("visuals","players","enemies","chams","model","rim"),
    ui.find("visuals","players","enemies","chams","glow"),
    {ui.find("visuals","players","enemies","chams","glow","default")},
    {ui.find("visuals","players","enemies","chams","glow","rim")},
    {ui.find("visuals","players","enemies","chams","glow","edge highlight")},
    {ui.find("visuals","players","enemies","chams","glow","edge highlight pulse")},
    ui.find("visuals","players","enemies","chams","weapon"),
    ui.find("visuals","players","enemies","chams","weapon","color"),
    ui.find("visuals","players","enemies","chams","weapon","reflectivity"),
    ui.find("visuals","players","enemies","chams","weapon","pearlescent"),
    ui.find("visuals","players","enemies","chams","weapon","shine"),
    ui.find("visuals","players","enemies","chams","weapon","rim"),
    ui.find("visuals","players","enemies","chams","weapon","outline"),
    ui.find("visuals","players","enemies","chams","weapon","brightness"),
    ui.find("visuals","players","enemies","chams","history"),
    ui.find("visuals","players","enemies","chams","history","color"),
    {ui.find("visuals","players","enemies","chams","history","style")},
    ui.find("visuals","players","enemies","chams","history","behind walls"),
    ui.find("visuals","players","enemies","chams","history","reflectivity"),
    ui.find("visuals","players","enemies","chams","history","pearlescent"),
    ui.find("visuals","players","enemies","chams","history","shine"),
    ui.find("visuals","players","enemies","chams","history","rim"),
    ui.find("visuals","players","enemies","chams","history","outline"),
    ui.find("visuals","players","enemies","chams","history","brightness"),
    ui.find("visuals","players","enemies","chams","history","fill"),
    ui.find("visuals","players","enemies","chams","history","animate"),
    ui.find("visuals","players","enemies","chams","on shot"),
    ui.find("visuals","players","enemies","chams","on shot","color"),
    {ui.find("visuals","players","enemies","chams","on shot","style")},
    ui.find("visuals","players","enemies","chams","on shot","behind walls"),
    ui.find("visuals","players","enemies","chams","on shot","reflectivity"),
    ui.find("visuals","players","enemies","chams","on shot","pearlescent"),
    ui.find("visuals","players","enemies","chams","on shot","shine"),
    ui.find("visuals","players","enemies","chams","on shot","rim"),
    ui.find("visuals","players","enemies","chams","on shot","last shot only"),
    ui.find("visuals","players","enemies","chams","on shot","duration"),
    ui.find("visuals","players","enemies","chams","on shot", "outline"),
    ui.find("visuals","players","enemies","chams","on shot","brightness"),
    ui.find("visuals","players","enemies","chams","on shot","fill"),
    ui.find("visuals","players","enemies","chams","ragdolls"),
    {ui.find("visuals","players","enemies","chams","ragdolls", "visible")},
    {ui.find("visuals","players","enemies","chams","ragdolls", "invisible")},
    {ui.find("visuals","players","enemies","chams","ragdolls", "style")},
    ui.find("visuals","players","enemies","chams","ragdolls", "reflectivity"),
    ui.find("visuals","players","enemies","chams","ragdolls", "pearlescent"),
    ui.find("visuals","players","enemies","chams","ragdolls", "shine"),
    ui.find("visuals","players","enemies","chams","ragdolls", "rim"),
    ui.find("visuals","players","enemies","chams","ragdolls", "no occlusion"),
    ui.find("visuals","players","enemies","chams","ragdolls", "outline"),
    ui.find("visuals","players","enemies","chams","ragdolls", "brightness"),
    ui.find("visuals","players","enemies","chams","ragdolls", "fill"),
 
    -- players teammate
    ui.find("visuals","players","teammates","esp","behind walls"),
    ui.find("visuals","players","teammates","esp","bullet tracer"),
    ui.find("visuals","players","teammates","esp","bullet tracer","style"),
    ui.find("visuals","players","teammates","esp","bullet tracer","color"), 
    {ui.find("visuals","players","teammates","esp","sounds")},
    ui.find("visuals","players","teammates","chams","model"),
    {ui.find("visuals","players","teammates","chams","model","visible")},
    {ui.find("visuals","players","teammates","chams","model","invisible")},
    {ui.find("visuals","players","teammates","chams","model","style")},
    ui.find("visuals","players","teammates","chams","model","no occlusion"),
    ui.find("visuals","players","teammates","chams","model","outline"),
    ui.find("visuals","players","teammates","chams","model","brightness"),
    ui.find("visuals","players","teammates","chams","model","fill"),
    ui.find("visuals","players","teammates","chams","model","reflectivity"),
    ui.find("visuals","players","teammates","chams","model","pearlescent"),
    ui.find("visuals","players","teammates","chams","model","shine"),
    ui.find("visuals","players","teammates","chams","model","rim"),
    ui.find("visuals","players","teammates","chams","glow"),
    {ui.find("visuals","players","teammates","chams","glow","default")},
    {ui.find("visuals","players","teammates","chams","glow","rim")},
    {ui.find("visuals","players","teammates","chams","glow","edge highlight")},
    {ui.find("visuals","players","teammates","chams","glow","edge highlight pulse")},
    ui.find("visuals","players","teammates","chams","weapon"),
    ui.find("visuals","players","teammates","chams","weapon","color"),
    ui.find("visuals","players","teammates","chams","weapon","reflectivity"),
    ui.find("visuals","players","teammates","chams","weapon","pearlescent"),
    ui.find("visuals","players","teammates","chams","weapon","shine"),
    ui.find("visuals","players","teammates","chams","weapon","rim"),
    ui.find("visuals","players","teammates","chams","weapon","outline"),
    ui.find("visuals","players","teammates","chams","weapon","brightness"),
    {ui.find("visuals","players","teammates","chams","ragdolls", "visible")},
    {ui.find("visuals","players","teammates","chams","ragdolls", "invisible")},
    {ui.find("visuals","players","teammates","chams","ragdolls", "style")},
    ui.find("visuals","players","teammates","chams","ragdolls", "reflectivity"),
    ui.find("visuals","players","teammates","chams","ragdolls", "pearlescent"),
    ui.find("visuals","players","teammates","chams","ragdolls", "shine"),
    ui.find("visuals","players","teammates","chams","ragdolls", "rim"),
    ui.find("visuals","players","teammates","chams","ragdolls", "no occlusion"),
    ui.find("visuals","players","teammates","chams","ragdolls", "outline"),
    ui.find("visuals","players","teammates","chams","ragdolls", "brightness"),
    ui.find("visuals","players","teammates","chams","ragdolls", "fill"),
 
    -- players self
    ui.find("visuals","players","self","esp","bullet tracer"),
    ui.find("visuals","players","self","esp","bullet tracer","style"),
    ui.find("visuals","players","self","esp","bullet tracer","color"), 
    {ui.find("visuals","players","self","esp","sounds")},
    ui.find("visuals","players","self","chams","model"),
    {ui.find("visuals","players","self","chams","model","visible")},
    {ui.find("visuals","players","self","chams","model","invisible")},
    {ui.find("visuals","players","self","chams","model","style")},
    ui.find("visuals","players","self","chams","model","no occlusion"),
    ui.find("visuals","players","self","chams","model","outline"),
    ui.find("visuals","players","self","chams","model","brightness"),
    ui.find("visuals","players","self","chams","model","fill"),
    ui.find("visuals","players","self","chams","model","reflectivity"),
    ui.find("visuals","players","self","chams","model","pearlescent"),
    ui.find("visuals","players","self","chams","model","shine"),
    ui.find("visuals","players","self","chams","model","rim"),
    ui.find("visuals","players","self","chams","glow"),
    {ui.find("visuals","players","self","chams","glow","default")},
    {ui.find("visuals","players","self","chams","glow","rim")},
    {ui.find("visuals","players","self","chams","glow","edge highlight")},
    {ui.find("visuals","players","self","chams","glow","edge highlight pulse")},
    ui.find("visuals","players","self","chams","weapon"),
    ui.find("visuals","players","self","chams","weapon","color"),
    ui.find("visuals","players","self","chams","weapon","reflectivity"),
    ui.find("visuals","players","self","chams","weapon","pearlescent"),
    ui.find("visuals","players","self","chams","weapon","shine"),
    ui.find("visuals","players","self","chams","weapon","rim"),
    ui.find("visuals","players","self","chams","weapon","outline"),
    ui.find("visuals","players","self","chams","weapon","brightness"),
    ui.find("visuals","players","self","chams","weapon","fill"),
    ui.find("visuals","players","self","chams","viewmodel"),
    {ui.find("visuals","players","self","chams","viewmodel","style")},
    ui.find("visuals","players","self","chams","viewmodel","reflectivity"),
    ui.find("visuals","players","self","chams","viewmodel","pearlescent"),
    ui.find("visuals","players","self","chams","viewmodel","shine"),
    ui.find("visuals","players","self","chams","viewmodel","rim"),
    ui.find("visuals","players","self","chams","viewmodel","outline"),
    ui.find("visuals","players","self","chams","viewmodel","brightness"),
    ui.find("visuals","players","self","chams","viewmodel","fill"),
    ui.find("visuals","players","self","chams","fake"),
    ui.find("visuals","players","self","chams","fake","color"),
    ui.find("visuals","players","self","chams","fake","style")
}
 
function unpack()
    for _, i in ipairs(allVisuals) do
        if (type(i) == 'table') then
            local sizeTable = #allVisuals
            for j , k in ipairs(i) do
                table.insert(allVisualsUnpack, k)
            end
        else
            table.insert(allVisualsUnpack, i)
        end 
    end
end
 
unpack()
 
function export()
    local cfg = {}
    local cfgJson_notencoded
    local cfgJson
    for index , i in ipairs(allVisualsUnpack) do
        local prop = nil
        if(string.find(tostring(i:get()),'color')) then
            prop = i:get():to_hex()
        else 
            prop = i:get()
        end
        cfg[index] = prop
    end
 
    cfgJson_notencoded = json.stringify(cfg)
 
    cfgJson = base64.encode(cfgJson_notencoded)
 
    clipboard.set(cfgJson)
 
    common.add_notify("Exported player visuals!","Done!")
 
end
 
function import()
    local cfg_decode = base64.decode(clipboard.get())
 
    local cfg = json.parse(cfg_decode)
 
    for index, i in ipairs(allVisualsUnpack) do 
        i:set(cfg[index])
    end
 
    common.add_notify("Imported player visuals!","Done!")
 
end
 
tab2:button("Export" , function ()
    export()
end)
 
tab2:button("Import" , function ()
    import()
end)
 
 
local allVisualsUnpack1 = {}
local allVisuals1 = {
    ui.find("visuals","world","other", "hit marker"),
    {ui.find("visuals","world","other", "hit marker", "3d marker")},
    {ui.find("visuals","world","other", "hit marker", "damage marker")},
    ui.find("visuals","world","other", "hit marker sound"),
    {ui.find("visuals","world","other", "hit marker sound", "head shot")},
    {ui.find("visuals","world","other", "hit marker sound", "body shot")},
    ui.find("visuals","world","other", "hit marker sound", "volume"),
    ui.find("visuals","world","other", "bullet impacts"),
    {ui.find("visuals","world","other", "bullet impacts","client-side impacts")},
    {ui.find("visuals","world","other", "bullet impacts","server-side impacts")},
    ui.find("visuals","world","other", "bullet impacts","glow amount"),
    ui.find("visuals","world","other", "bullet impacts","duration"),
    ui.find("visuals","world","other", "grenade prediction"),
    ui.find("visuals","world","other", "grenade prediction","color"),
    {ui.find("visuals","world","other", "grenade prediction", "color hit")},
    ui.find("visuals","world","other", "grenade prediction", "behind walls"),
    ui.find("visuals","world","other", "grenade prediction", "visualize"),
    ui.find("visuals","world","other", "grenade prediction", "particles"),
    {ui.find("visuals","world","other", "grenade proximity warning")},
    ui.find("visuals","world","other", "asus walls"),
    ui.find("visuals","world","other", "asus props"),
 
    -- world world esp // need attention
 
    -- world ambient
    {ui.find("visuals","world","ambient", "night mode")},
    {ui.find("visuals","world","ambient", "static props")},
    {ui.find("visuals","world","ambient", "post processing")},
    ui.find("visuals","world","ambient", "fog changer"),
    ui.find("visuals","world","ambient", "fog changer", "color"),
    ui.find("visuals","world","ambient", "fog changer", "start"),
    ui.find("visuals","world","ambient", "fog changer", "distance"),
    ui.find("visuals","world","ambient", "illumination"),
    ui.find("visuals","world","ambient", "illumination","pitch"),
    ui.find("visuals","world","ambient", "illumination","yaw"),
    ui.find("visuals","world","ambient", "illumination","distance"),
    {ui.find("visuals","world","ambient", "illumination","color")},
    ui.find("visuals","world","ambient", "illumination","draw 3d position"),
 
    -- world main
    ui.find("visuals","world","main", "field of view"),
    ui.find("visuals","world","main", "override zoom"),
    ui.find("visuals","world","main", "force thirdperson"),
    ui.find("visuals","world","main", "force thirdperson", "distance"),
    ui.find("visuals","world","main", "force thirdperson", "ignore props"),
    ui.find("visuals","world","main", "force thirdperson", "enable animation"),
    ui.find("visuals","world","main", "force thirdperson", "force in spectators"),
    ui.find("visuals","world","main", "visual recoil"),
    ui.find("visuals","world","main", "removals")
}   
 
 
function unpack1()
    for _, i in ipairs(allVisuals1) do
        if (type(i) == 'table') then
            local sizeTable = #allVisuals1
            for j , k in ipairs(i) do
                table.insert(allVisualsUnpack1, k)
            end
        else
            table.insert(allVisualsUnpack1, i)
        end 
    end
end
 
unpack1()
 
function export1()
    local cfg = {}
    local cfgJson1_notencoded
    local cfgJson1
    for index , i in ipairs(allVisualsUnpack1) do
        local prop1 = nil
        if(string.find(tostring(i:get()),'color')) then
            prop1 = i:get():to_hex()
        else 
            prop1 = i:get()
        end
        cfg[index] = prop1
    end
 
    cfgJson1_notencoded = json.stringify(cfg)
 
    cfgJson1 = base64.encode(cfgJson1_notencoded)
 
    clipboard.set(cfgJson1)
 
    common.add_notify("Exported world visuals!","Done!")
 
end
 
function import1()
    local cfg_decode = base64.decode(clipboard.get())
 
    local cfg = json.parse(cfg_decode)
 
    for index, i in ipairs(allVisualsUnpack1) do 
        i:set(cfg[index])
    end
 
    common.add_notify("Imported world visuals!","Done!")
 
end
 
tab3:button("Export" , function ()
    export1()
end)
 
tab3:button("Import" , function ()
    import1()
end)
 
 
local allVisualsUnpack11 = {}
local allVisuals11 ={
    ui.find("Miscellaneous", "Main", "Movement", "Bunny Hop"),
    ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "Smoothing"),
    ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "WASD Strafe"),
    ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "Circle Strafe"),
    ui.find("Miscellaneous", "Main", "Movement", "Air Duck"),
    ui.find("Miscellaneous", "Main", "Movement", "Air Duck", "Mode"),
    ui.find("Miscellaneous", "Main", "Movement", "Quick Stop"),
    ui.find("Miscellaneous", "Main", "Movement", "Strafe Assist"),
    ui.find("Miscellaneous", "Main", "Movement", "Infinite Duck"),
    ui.find("Miscellaneous", "Main", "Movement", "Edge Jump"),
    ui.find("Miscellaneous", "Main", "Other", "Anti Untrusted"),
    ui.find("Miscellaneous", "Main", "Other", "Unlock Hidden Cvars"),
    ui.find("Miscellaneous", "Main", "Other", "Filters"),
    ui.find("Miscellaneous", "Main", "Other", "Windows"),
    ui.find("Miscellaneous", "Main", "Other", "Log Events"),
    ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
    ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    ui.find("Miscellaneous", "Main", "In-Game", "Preserve Kill Feed"),
    ui.find("Miscellaneous", "Main", "In-Game", "Reveals"),
    ui.find("Miscellaneous", "Main", "BuyBot", "Enabled"),
    ui.find("Miscellaneous", "Main", "BuyBot", "Primary"),
    ui.find("Miscellaneous", "Main", "BuyBot", "Secondary"),
    ui.find("Miscellaneous", "Main", "BuyBot", "Equipment")
}
 
function unpack_misc()
    for _, i in ipairs(allVisuals11) do
        if (type(i) == 'table') then
            local sizeTable = #allVisuals11
            for j , k in ipairs(i) do
                table.insert(allVisualsUnpack11, k)
            end
        else
            table.insert(allVisualsUnpack11, i)
        end 
    end
end
 
unpack_misc()
 
function export_misc()
    local cfg11 = {}
    local cfgJson1_notencoded11
    local cfgJson11
    for index , i in ipairs(allVisualsUnpack11) do
        local prop11 = nil
        if(string.find(tostring(i:get()),'color')) then
            prop11 = i:get():to_hex()
        else 
            prop11 = i:get()
        end
        cfg11[index] = prop11
    end
 
    cfgJson1_notencoded11 = json.stringify(cfg11)
 
    cfgJson11 = base64.encode(cfgJson1_notencoded11)
 
    clipboard.set(cfgJson11)
 
    common.add_notify("Exported Misc","Done!")
 
end
 
function import_misc()
    local cfg_decode11 = base64.decode(clipboard.get())
 
    local cfg11 = json.parse(cfg_decode11)
 
    for index, i in ipairs(allVisualsUnpack11) do 
        i:set(cfg11[index])
    end
 
    common.add_notify("Imported Misc!","Done!")
 
end
 
tab4:button("Export" , function ()
    export_misc()
end)
 
tab4:button("Import" , function ()
    import_misc()
end)
 
 --######
 --######
 --######
 --######
 
local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ''
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end

    return output
end

local function logsclr(color)
    local output = ''
    output = output .. ('\a%02x%02x%02x'):format(color.r, color.g, color.b)
    return output
end



ui.sidebar(gradient_text(0, 40, 255, 255, 200, 100, 200, 255, "Rage external system"), "pray")
common.add_notify("Welcom dear", "Hope u have an nice experience, "..common.get_username())






local clipboard = require "neverlose/clipboard"
local info = ui.create("Information", "\aFFD95CFFExternal links")
local tab = ui.create("Config File", "\aFFD95CFF")

local weapon_groups = {"Global" , "Pistols" , "Autosnipers" , "Rifles" , "SMGs" , "Shotguns" , "AWP" , "SSG-08" , "AK-47" , "Desert Eagle" , "R8 Revolver" , "Taser"}

info:label("Any issue contact me on discord mateusx#1337")



local settings = {}

for k , v in ipairs(weapon_groups) do 
     settings[v] =
     {
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Scope"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Options"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Double Tap"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Dynamic Mode"),
        ui.find("Aimbot", "Ragebot", "Accuracy", v, "Auto Stop", "Force Accuracy"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Hitboxes"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint", "Head Scale"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Multipoint", "Body Scale"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Minimum Damage"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Minimum Damage", "Delay Shot"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Hit Chance"),
        ui.find("Aimbot", "Ragebot", "Selection", v, "Hit Chance", "Strict Hit Chance"),
        ui.find("Aimbot", "Ragebot", "Safety", v, "Body Aim") ,
        ui.find("Aimbot", "Ragebot", "Safety", v, "Body Aim", "Disablers"),
        ui.find("Aimbot", "Ragebot", "Safety", v, "Safe Points"),
        ui.find("Aimbot", "Ragebot", "Safety", v, "Ensure Hitbox Safety"),
        ui.find("Aimbot", "Ragebot", "Selection", v , "Penetrate Walls")
     }
end

function  export()

    print_dev("Exporting Config")

    local cfg = {}

    for k , v in ipairs(weapon_groups) do 
        cfg[v] = {}
        for _ , i in pairs(settings[v]) do 
            cfg[v][i:get_name()] = i:get()
        end
    end

    clipboard.set(json.stringify(cfg))

end

function  import()
    local cfg = json.parse(clipboard.get())

    for k , v in ipairs(weapon_groups) do 
        for _ , i in pairs(settings[v]) do
            i:set(cfg[v][i:get_name()])
        end
    end

    clipboard.set(json.stringify(cfg))

end

tab:button("Export" , function ()
    export()
end)

tab:button("Import" , function ()
    import()
end)

