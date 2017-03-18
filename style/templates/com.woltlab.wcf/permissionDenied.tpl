{include file="documentHeader"}

<head>
	<title>{lang}wcf.global.error.permissionDenied.title{/lang} - {lang}{PAGE_TITLE}{/lang}</title>
	
	{include file='headInclude'}
</head>

<body id="tpl{$templateName|ucfirst}" data-template="{$templateName}" data-application="{$templateNameApplication}">

{include file='header' __disableAds=true}

<div class="container" style="margin-bottom:15px;">
	<p class="alert alert-danger">{lang}wcf.global.error.permissionDenied{/lang}</p>
</div>

{event name='content'}

{if ENABLE_DEBUG_MODE}
	<!-- 
	{$name} thrown in {$file} ({@$line})
	Stacktrace:
	{$stacktrace}
	-->
{/if}

{include file='footer'}

</body>
</html>