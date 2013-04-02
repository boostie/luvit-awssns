local table = require('table')
local string = require('string')
local stringFormat = require('string').format
local url = require('url')
local common = require('./common')


local function commonRequestParams(params,action) 
    local _params = params
    _params['Action'] = action
    _params['SignatureVersion'] = '2'
    _params['SignatureMethod'] = 'HmacSHA1'
    _params['Timestamp'] = common.timestampAsISO8601()
    return _params
end

local function snsPublishMessage(awsOptions, topicArn, subject, message,callback) 
    local rParams = commonRequestParams({
        Subject = subject,
        TopicArn = topicArn, 
        Message = message
    }, 'Publish')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsCreateTopic(awsOptions,name,callback)
    local rParams = commonRequestParams({
        Name = name
    }, 'CreateTopic')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsDeleteTopic(awsOptions,topicArn,callback)
    local rParams = commonRequestParams({
        TopicArn = topicArn
    }, 'DeleteTopic')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsGetSubscriptionAttributes(awsOptions, subscriptionArn, callback) 
    local rParams = commonRequestParams({
        SubscriptionArn = subscriptionArn
    }, 'GetSubscriptionAttributes')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsGetTopicAttributes(awsOptions, topicArn, callback) 
    local rParams = commonRequestParams({
        TopicArn = topicArn
    }, 'GetTopicAttributes')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsListSubscriptions(awsOptions, callback) 
    local rParams = commonRequestParams({}, 'ListSubscriptions')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsListSubscriptionsByTopic(awsOptions, topicArn, callback) 
    local rParams = commonRequestParams({
        TopicArn = topicArn
    }, 'ListSubscriptionsByTopic')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end
  
local function snsListTopics(awsOptions, callback) 
    local rParams = commonRequestParams({}, 'ListTopics')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsSubscribe(awsOptions, topicArn, protocol, endpoint, callback) 
    local rParams = commonRequestParams({
        TopicArn = topicArn, 
        Protocol = protocol,
        Endpoint = endpoint
    }, 'Subscribe')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end

local function snsUnsubscribe(awsOptions, subscriptionArn, callback) 
    local rParams = commonRequestParams({
        SubscriptionArn = subscriptionArn
    }, 'Unsubscribe')
    local req = common.buildRequestUrl(awsOptions, rParams, callback)
    req:done()
end


local exports = {}
exports.publishMessage = snsPublishMessage
exports.createTopic = snsCreateTopic
exports.deleteTopic = snsDeleteTopic
exports.getSubscriptionAttributes = snsGetSubscriptionAttributes
exports.getTopicAttributes = snsGetTopicAttributes
exports.listSubscriptions = snsListSubscriptions
exports.listSubscriptionsByTopic = snsListSubscriptionsByTopic
exports.listTopics = snsListTopics
exports.subscribe = snsSubscribe
exports.unsubscribe = snsUnsubscribe
return exports

