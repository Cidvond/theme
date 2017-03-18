<li id="messageQuickReply" class="marginTop jsOnly{if $conversation->userID == $__wcf->getUser()->userID} messageGroupStarter{/if}" style="display: none;" data-conversation-id="{@$conversation->conversationID}" data-last-post-time="{@$conversation->lastPostTime}" data-page-no="{@$pageNo}">
	<article class="message messageSidebarOrientation{@$__wcf->getStyleHandler()->getStyle()->getVariable('messageSidebarOrientation')|ucfirst} dividers{if $__wcf->getUserProfileHandler()->userOnlineGroupID} userOnlineGroupMarking{@$__wcf->getUserProfileHandler()->userOnlineGroupID}{/if}">
		<div>
			{include file='messageSidebar' userProfile=$__wcf->getUserProfileHandler()}
			
			<section class="messageContent messageQuickReplyContent">
				<div>
					<header class="messageHeader">
					</header>
					
					<div class="messageBody">
						{if !$conversation->isDraft && !$conversation->hasOtherParticipants()}
							<p class="warning" style="margin-bottom: 14px">{lang}wcf.conversation.noParticipantsWarning{/lang}</p>
						{/if}
						
						<textarea id="text" name="text" rows="20" cols="40" data-autosave="com.woltlab.wcf.conversation.messageAdd-{@$conversation->conversationID}" style="width: 100%"></textarea>
						{include file='messageFormTabsInline' inConversationQuickReply=true}
					</div>
					
					<div class="formSubmit" style="padding-bottom: 15px;">
						<button class="btn btn-primary btn-3d" data-type="save" accesskey="s">{lang}wcf.global.button.submit{/lang}</button>
						<button class="btn btn-secondary btn-3d" data-type="extended">{lang}wcf.message.button.extendedReply{/lang}</button>
						<button class="btn btn-secondary btn-3d" data-type="cancel">{lang}wcf.global.button.cancel{/lang}</button>
					</div>
				</div>
			</section>
		</div>
	</article>
	
	<script data-relocate="true">
		//<![CDATA[
		$(function() {
			WCF.System.Dependency.Manager.register('Redactor_text', function() { new WCF.Message.UserMention('text'); });
		});
		//]]>
	</script>
	{include file='wysiwyg'}
</li>