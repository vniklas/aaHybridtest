    param ($message = "Alert Disk in dev Env Low",
		   $channel="#azure",
		   [object]$WebhookData)
	
	$token = Get-AutomationVariable -Name 'SlackTokenDevops'
	$user = Get-AutomationVariable -Name 'SlackUserDevops'
	
	if($webhookdata -ne $null){
		 # Collect properties of WebhookData
        $WebhookName    =   $WebhookData.WebhookName
        $WebhookHeaders =   $WebhookData.RequestHeader
        $WebhookBody    =   $WebhookData.RequestBody

        # Collect individual headers. VMList converted from JSON.
        $From = $WebhookHeaders.From
        $data = (ConvertFrom-Json -InputObject $WebhookBody)
        Write-Output "Runbook started from webhook $WebhookName by $From."
		
		$message = "Alert Disk in dev Env Low" #$data.Message
		$channel = "#azure" #$data.channel
	}else{
		Write-Output "Runnbook started within Azure Automation"
	}
	
	$postSlackMessage = @{token=$token;channel=$channel;text=$message;username=$user}
	Invoke-RestMethod -Uri "https://slack.com/api/chat.postMessage" -Body $postSlackMessage