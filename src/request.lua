local request,props,methods,mainModule = {},{},{},script.parent
local helper = require(mainModule.utility.helpers)
local HTTP = game:GetService("HttpService")
-- Do Not Change This Is the Main Copy Table !!!!
--RTTP = remote table transfer protocol
local RTTP = {
    requestline = {
        url = '',
        port = 1,
        method = ''
    },
    header = {
        contentType ='',
        cookie = '',
    },
    body = {} -- Is Just Basic Data
}


methods.sending = function(options)
    local IsMethod,IsPort,IsUrl,IsContentType,IsCookie;
    local req = helper.DeepCopy(RTTP,{}); --make Copy Of Table
    IsUrl = (options.url ~= nil and typeof(options.url) == 'string')
    IsMethod = (options.method ~= nil and typeof(options.method) == 'string')
    IsPort = (options.port ~= nil and typeof(options.port)== 'number')
    IsContentType = (options.contentType ~= nil and typeof(options.contentType) == 'string')
    IsCookie = (options.cookie ~= nil and typeof(options.cookie) == "string")
    
    if IsUrl and IsMethod and IsPort == true then
        req.requestline.url = options.url
        req.requestline.port = options.port
        req.requestline.method = options.method
    end

    if IsContentType then
        req.header.contentType = options.contentType
    end
    if IsCookie then
        req.header.cookie = options.cookie
    end

    return HTTP:JSONEncode(req)
end

methods.received = function(player,requestObject,ports)
    requestObject = HTTP:JSONDecode(requestObject)
    print(requestObject)
    local req = {}
    req.url = requestObject.requestline.url
    req.port = requestObject.requestline.port
    req.method = requestObject.requestline.method
    req.player = player
    req.contentType = requestObject.header.contentType
    req.cookie = requestObject.header.cookie
    req.params = {}
    print(req)
    return req
end



return setmetatable(request,{
    __index = function(tab,key)
        local method = methods[key];
        if method then
            return method;
        else
            error("["..key:upper().."]".. "is not a indexable method");
        end
    end
})