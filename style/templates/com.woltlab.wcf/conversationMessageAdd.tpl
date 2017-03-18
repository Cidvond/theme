{include file='documentHeader'}

<head>
	<title>{lang}wcf.conversation.message.add{/lang} - {$conversation->subject} - {PAGE_TITLE|language}</title>
	
	{include file='headInclude'}
	
	<script data-relocate="true" src="{@$__wcf->getPath()}js/WCF.Conversation{if !ENABLE_DEBUG_MODE}.min{/if}.js?v={@LAST_UPDATE_TIME}"></script>
	<script data-relocate="true">
		//<![CDATA[
		$(function() {
			WCF.Language.addObject({
				'wcf.message.bbcode.code.copy': '{lang}wcf.message.bbcode.code.copy{/lang}'
			});
			
			{include file='__messageQuoteManager' wysiwygSelector='text' supportPaste=true}
			new WCF.Conversation.Message.QuoteHandler($quoteManager);
			
			WCF.Message.Submit.registerButton('text', $('#messageContainer > .formSubmit > input[type=submit]'));
			new WCF.Message.FormGuard();
			new WCF.Message.BBCode.CodeViewer();
			
			WCF.System.Dependency.Manager.register('CKEditor', function() { new WCF.Message.UserMention('text'); });
		});
		//]]>
	</script>
</head>

<body id="tpl{$templateName|ucfirst}" data-template="{$templateName}" data-application="{$templateNameApplication}">
{include file='header' title='wcf.conversation.message.add'|language light=true}

{include file='userNotice'}

<div class="container">
	{if !$conversation->isDraft && !$conversation->hasOtherParticipants()}
		<p class="alert alert-warning">{lang}wcf.conversation.noParticipantsWarning{/lang}</p>
	{/if}

	{include file='formError'}
</div>

<form id="messageContainer" class="jsFormGuard" method="post" action="{link controller='ConversationMessageAdd' id=$conversationID}{/link}">
	<div class="container containerPadding marginTop">
		<fieldset>
			<legend>{lang}wcf.conversation.message{/lang}</legend>
			
			<dl class="wide{if $errorField == 'text'} formError{/if}">
				<dt><label for="text">{lang}wcf.conversation.message{/lang}</label></dt>
				<dd>
					<textarea id="text" name="text" rows="20" cols="40" data-autosave="com.woltlab.wcf.conversation.messageAdd-{@$conversation->conversationID}">{$text}</textarea>
					{if $errorField == 'text'}
						<small class="innerError">
							{if $errorType == 'empty'}
								{lang}wcf.global.form.error.empty{/lang}
							{elseif $errorType == 'tooLong'}
								{lang}wcf.message.error.tooLong{/lang}
							{elseif $errorType == 'censoredWordsFound'}
								{lang}wcf.message.error.censoredWordsFound{/lang}
							{elseif $errorType == 'disallowedBBCodes'}
								{lang}wcf.message.error.disallowedBBCodes{/lang}
							{else}
								{lang}wcf.conversation.message.error.{@$errorType}{/lang}
							{/if}
						</small>
					{/if}
				</dd>
			</dl>
			
			{event name='messageFields'}
		</fieldset>
		
		{include file='messageFormTabs' wysiwygContainerID='text'}
		
		{event name='fieldsets'}
	
		<div class="text-center" style="padding-top: 15px;">
			<button class="btn btn-primary btn-3d" accesskey="s">{lang}wcf.global.button.submit{/lang}</button>
			{include file='messageFormPreviewButton'}
			{@SECURITY_TOKEN_INPUT_TAG}
		</div>
	</div>
</form>

<div class="container" style="padding-bottom:15px;">
	<header class="boxHeadline boxSubHeadline">
		<h2>{lang}wcf.conversation.message.add.previousPosts{/lang}{if $items != 1} <span class="badge">{#$items}</span>{/if}</h2>
	</header>

	<div>
		<ul class="messageList">
			{foreach from=$messages item=message}
				{assign var='objectID' value=$message->messageID}

				<li class="marginTop">
					<article class="message messageReduced{if $message->getUserProfile()->userOnlineGroupID} userOnlineGroupMarking{@$message->getUserProfile()->userOnlineGroupID}{/if}" data-object-id="{@$message->messageID}">
						<div>
							<section class="messageContent">
								<div>
									<header class="messageHeader">
										<div class="box32">
											<a href="{link controller='User' object=$message->getUserProfile()}{/link}" class="framed">{@$message->getUserProfile()->getAvatar()->getImageTag(32)}</a>

											<div class="messageHeadline">
												<p>
													<span class="username"><a href="{link controller='User' object=$message->getUserProfile()}{/link}" class="userLink" data-user-id="{@$message->userID}">{$message->username}</a></span>
													<a href="{link controller='Conversation' object=$conversation}messageID={@$message->messageID}{/link}#message{@$message->messageID}" class="permalink">{@$message->time|time}</a>
												</p>
											</div>
										</div>
									</header>

									<div class="messageBody">
										<div>
											<div class="messageText">
												{@$message->getFormattedMessage()}
											</div>
										</div>

										{include file='attachments'}

										<footer class="messageOptions">
											<nav class="jsMobileNavigation buttonGroupNavigation">
												<ul class="smallButtons buttonGroup"><li class="toTopLink"><a href="{$__wcf->getAnchor('top')}" title="{lang}wcf.global.scrollUp{/lang}" class="button jsTooltip"><span class="icon icon16 icon-arrow-up"></span> <span class="invisible">{lang}wcf.global.scrollUp{/lang}</span></a></li></ul>
											</nav>
										</footer>
									</div>
								</div>
							</section>
						</div>
					</article>
				</li>
			{/foreach}
		</ul>
	</div>
</div>

{include file='footer'}
{include file='wysiwyg'}

</body>
</html>