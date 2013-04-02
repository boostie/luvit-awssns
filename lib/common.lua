local table = require('table')
local string = require('string')
local stringFormat = require('string').format
local os = require('os')
local http = require('http')
local https = require('https')
local enc = require('./enc')

local DEBUG = false
local function dbg(format, ...)
  if DEBUG == true then
    print(stringFormat(format, {...}))
  end
end


local function urlEncode(str)
    str = string.gsub (str, "\r?\n", "\n")
    str = string.gsub (str, "([^%w%-%.%_%~ ])",
      function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "%%20")
    return str
end

local function tsd(v) 
    if (tonumber(v) < 10) then
        return '0' .. tostring(v)
    end
    return v
end

local function timestampAsISO8601()
    local gmt = os.date("!*t",os.time())
    local iso8601 = stringFormat("%s-%s-%sT%s:%s:%s.000Z", gmt.year, tsd(gmt.month), tsd(gmt.day), tsd(gmt.hour), tsd(gmt.min), tsd(gmt.sec))
    return iso8601
end


local function sortedByKey(t) 
    local keys = {}
    for k, v in pairs(t) do
      table.insert(keys,k)
    end
    table.sort(keys)
    return keys
end


local function buildRequestUrl(aws,params,callback)
    
    local req = http.request({
        host = aws.endPoint,
        port = 80,
        path = "/",
        protocol = aws.protocol
      }, function (res)
            local data = {}
            res:on('data', function (chunk)
                table.insert(data, chunk)
            end)
            res:on('error', function(err)
                dbg(err)
                callback(err, nil)
            end)
            res:on('end', function ()
                res:destroy()
                if (callback) then
                    callback(nil, table.concat(data))
                end
            end)
    end)

    local signParams = {}
    table.insert(signParams, req.method .. '\n')
    table.insert(signParams, aws.endPoint  .. '\n')
    table.insert(signParams, req.path  .. '\n')
    table.insert(signParams, stringFormat("AWSAccessKeyId=%s", aws.accessKey))
   
    for i, k in ipairs(sortedByKey(params)) do
       table.insert(signParams, stringFormat("&%s=%s", k, urlEncode(params[k])))
    end
    local rawSignatureString = table.concat(signParams,"")
    local hmac = enc.hmac_sha1_binary(aws.secretKey,rawSignatureString)
    local base64 = enc.base64_encode(hmac)
    
    table.insert(signParams, stringFormat("&Signature=%s", urlEncode(base64)))
    local requestParams = {}
    for i,k in ipairs(signParams) do 
        if (i > 3) then
            table.insert(requestParams, signParams[i])
        end
    end
    req.path = "/?" .. table.concat(requestParams,"")
    return req
end


local exports = {}
exports.urlEncode = urlEncode
exports.timestampAsISO8601 = timestampAsISO8601
exports.buildRequestUrl = buildRequestUrl
return exports