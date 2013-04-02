local awsSns = require('./lib/awssns')

-- currently supports http protocol and HmacSHA1 signature method
-- common.lua can be modified to handle https

local awsOptions = {
  accessKey = 'AWS KEY',
  secretKey = 'AWS SECRET',
  endPoint = 'sns.us-east-1.amazonaws.com',
  protocol = 'http'
}

awsSns.createTopic(awsOptions, 'Test-topic', function(err,message)
    p(message)
end)

awsSns.publishMessage(awsOptions, '[topic arn here]', 'subject', 'message body', function(err,message)
    p(message)
end)

awsSns.deleteTopic(awsOptions, '[topic arn here]', function(err,message)
    p(message)
end)

awsSns.getSubscriptionAttributes(awsOptions, '[subscription arn here]', function(err,message)
    p(message)
end)

awsSns.getTopicAttributes(awsOptions, '[topic arn here]', function(err,message)
    p(message)
end)

awsSns.listSubscriptions(awsOptions, function(err,message)
    p(message)
end)

awsSns.listSubscriptionsByTopic(awsOptions, '[topic arn here]', function(err,message)
    p(message)
end)

awsSns.listTopics(awsOptions, function(err,message)
    p(message)
end)

awsSns.subscribe(awsOptions, '[topic arn here]', 'email', 'test@abc.com', function(err,message)
    p(message)
end)

awsSns.unsubscribe(awsOptions, '[subscription arn here]', function(err,message)
    p(message)
end)





