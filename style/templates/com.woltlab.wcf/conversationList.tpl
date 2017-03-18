{include file='documentHeader'}

<head>
	<title>{lang}wcf.conversation.conversations{/lang} {if $pageNo > 1}- {lang}wcf.page.pageNo{/lang} {/if}- {PAGE_TITLE|language}</title>
	
	{include file='headInclude'}
	
	<link rel="alternate" type="application/rss+xml" title="{lang}wcf.global.button.rss{/lang}" href="{link controller='ConversationFeed' appendSession=false}at={@$__wcf->getUser()->userID}-{@$__wcf->getUser()->accessToken}{/link}" />
	<script data-relocate="true" src="{@$__wcf->getPath()}js/WCF.Conversation{if !ENABLE_DEBUG_MODE}.min{/if}.js?v={@LAST_UPDATE_TIME}"></script>
	<script data-relocate="true">
		//<![CDATA[
		$(function() {
			WCF.Language.addObject({
				'wcf.conversation.edit.addParticipants': '{lang}wcf.conversation.edit.addParticipants{/lang}',
				'wcf.conversation.edit.assignLabel': '{lang}wcf.conversation.edit.assignLabel{/lang}',
				'wcf.conversation.edit.close': '{lang}wcf.conversation.edit.close{/lang}',
				'wcf.conversation.edit.leave': '{lang}wcf.conversation.edit.leave{/lang}',
				'wcf.conversation.edit.open': '{lang}wcf.conversation.edit.open{/lang}',
				'wcf.conversation.label.management': '{lang}wcf.conversation.label.management{/lang}',
				'wcf.conversation.label.management.addLabel.success': '{lang}wcf.conversation.label.management.addLabel.success{/lang}',
				'wcf.conversation.label.management.deleteLabel.confirmMessage': '{lang}wcf.conversation.label.management.deleteLabel.confirmMessage{/lang}',
				'wcf.conversation.label.management.editLabel': '{lang}wcf.conversation.label.management.editLabel{/lang}',
				'wcf.conversation.label.placeholder': '{lang}wcf.conversation.label.placeholder{/lang}',
				'wcf.conversation.leave.title': '{lang}wcf.conversation.leave.title{/lang}',
				'wcf.global.state.closed': '{lang}wcf.global.state.closed{/lang}',
				'wcf.conversation.label.assignLabels': '{lang}wcf.conversation.label.assignLabels{/lang}'
			});
			
			WCF.Clipboard.init('wcf\\page\\ConversationListPage', {@$hasMarkedItems}, { });
			
			var $editorHandler = new WCF.Conversation.EditorHandler();
			var $inlineEditor = new WCF.Conversation.InlineEditor('.conversation');
			$inlineEditor.setEditorHandler($editorHandler, 'list');
			
			new WCF.Conversation.Clipboard($editorHandler);
			new WCF.Conversation.Label.Manager('{link controller='ConversationList' encode=false}{if $filter}filter={@$filter}{/if}&sortField={$sortField}&sortOrder={$sortOrder}&pageNo={@$pageNo}{/link}');
			new WCF.Conversation.Preview();
			new WCF.Conversation.MarkAsRead();
			new WCF.Conversation.MarkAllAsRead();
			
			// mobile safari hover workaround
			if ($(window).width() <= 800) {
				$('.sidebar').addClass('mobileSidebar').hover(function() { });
			}
		});
		//]]>
	</script>
</head>

<body id="tpl{$templateName|ucfirst}" data-template="{$templateName}" data-application="{$templateNameApplication}">

{capture assign='sidebar'}
	<fieldset>
		<legend>{lang}wcf.conversation.folders{/lang}</legend>
		
		<nav>
			<ul class="conversationFolderList">
				<li{if $filter == ''} class="active"{/if}><a href="{link controller='ConversationList'}{/link}">{lang}wcf.conversation.conversations{/lang}{if $conversationCount} <span class="badge">{#$conversationCount}</span>{/if}</a></li>
				<li{if $filter == 'draft'} class="active"{/if}><a href="{link controller='ConversationList'}filter=draft{/link}">{lang}wcf.conversation.folder.draft{/lang}{if $draftCount} <span class="badge">{#$draftCount}</span>{/if}</a></li>
				<li{if $filter == 'outbox'} class="active"{/if}><a href="{link controller='ConversationList'}filter=outbox{/link}">{lang}wcf.conversation.folder.outbox{/lang}{if $outboxCount} <span class="badge">{#$outboxCount}</span>{/if}</a></li>
				<li{if $filter == 'hidden'} class="active"{/if}><a href="{link controller='ConversationList'}filter=hidden{/link}">{lang}wcf.conversation.folder.hidden{/lang}{if $hiddenCount} <span class="badge">{#$hiddenCount}</span>{/if}</a></li>
			</ul>
		</nav>
	</fieldset>
	
	<fieldset class="jsOnly">
		<legend>{lang}wcf.conversation.label{/lang}</legend>
		
		<div id="conversationLabelFilter" class="dropdown">
			<div class="dropdownToggle" data-toggle="conversationLabelFilter">
				{if $labelID}
					{foreach from=$labelList item=label}
						{if $label->labelID == $labelID}
							<span class="badge label{if $label->cssClassName} {@$label->cssClassName}{/if}">{$label->label}</span>
						{/if}
					{/foreach}
				{else}
					<span class="badge">{lang}wcf.conversation.label.filter{/lang}</span>
				{/if}
			</div>
			
			<div class="dropdownMenu">
				<ul class="scrollableDropdownMenu">
					{foreach from=$labelList item=label}
						<li><a href="{link controller='ConversationList'}{if $filter}filter={@$filter}{/if}&sortField={$sortField}&sortOrder={$sortOrder}&pageNo={@$pageNo}&labelID={@$label->labelID}{/link}"><span class="badge label{if $label->cssClassName} {@$label->cssClassName}{/if}" data-css-class-name="{if $label->cssClassName}{@$label->cssClassName}{/if}" data-label-id="{@$label->labelID}">{$label->label}</span></a></li>
					{/foreach}
				</ul>
				<ul>
					<li class="dropdownDivider"{if !$labelList|count} style="display: none;"{/if}></li>
					<li><a href="{link controller='ConversationList'}{if $filter}filter={@$filter}{/if}&sortField={$sortField}&sortOrder={$sortOrder}&pageNo={@$pageNo}{/link}"><span class="badge label">{lang}wcf.conversation.label.disableFilter{/lang}</span></a></li>
				</ul>
			</div>
		</div>
		
		<button id="manageLabel" class="btn btn-3d">{lang}wcf.conversation.label.management{/lang}</button>
	</fieldset>
	
	{event name='beforeQuotaBox'}
	
	<fieldset class="conversationQuota">
		<legend>{lang}wcf.conversation.quota{/lang}</legend>
		
		<div>
			{assign var='conversationCount' value=$__wcf->getConversationHandler()->getConversationCount()}
			{assign var='maxConversationCount' value=$__wcf->session->getPermission('user.conversation.maxConversations')}
			<p class="conversationUsageBar{if $conversationCount/$maxConversationCount >= 1.0} red{elseif $conversationCount/$maxConversationCount > 0.9} yellow{/if}">
				<span style="width: {if $conversationCount/$maxConversationCount < 1.0}{@$conversationCount/$maxConversationCount*100|round:0}{else}100{/if}%">{#$conversationCount/$maxConversationCount*100}%</span>
			</p>
			<p><small>{lang}wcf.conversation.quota.description{/lang}</small></p>
		</div>
	</fieldset>
	
	{event name='boxes'}
{/capture}

{capture assign='headerNavigation'}
	<li><a rel="alternate" href="{link controller='ConversationFeed' appendSession=false}at={@$__wcf->getUser()->userID}-{@$__wcf->getUser()->accessToken}{/link}" title="{lang}wcf.global.button.rss{/lang}" class="jsTooltip"><span class="icon icon16 icon-rss"></span> <span class="invisible">{lang}wcf.global.button.rss{/lang}</span></a></li>
	<li class="jsOnly"><a href="#" title="{lang}wcf.conversation.markAllAsRead{/lang}" class="markAllAsReadButton jsTooltip"><span class="icon icon16 icon-ok"></span> <span class="invisible">{lang}wcf.conversation.markAllAsRead{/lang}</span></a></li>
{/capture}

{capture assign='__pageTitle'}
	{if $filter}{lang}wcf.conversation.folder.{$filter}{/lang}{else}{lang}wcf.conversation.conversations{/lang}{/if}
{/capture}
{include file='header' title=$__pageTitle skipBreadcrumbs=true}

<div class="container marginBottom-30">
	<div class="col-md-3 no-padding-left">
		{include file='leftSidebar'}
	</div>
	
	<div class="col-md-9 no-padding-right">
		{include file='userNotice'}

		<div class="contentNavigation">
			{assign var='labelIDParameter' value=''}
			{if $labelID}{assign var='labelIDParameter' value="&labelID=$labelID"}{/if}
			{pages print=true assign=pagesLinks controller='ConversationList' link="filter=$filter&pageNo=%d&sortField=$sortField&sortOrder=$sortOrder$labelIDParameter"}

			<nav>
				<ul>
					<li><a href="{link controller='ConversationAdd'}{/link}" title="{lang}wcf.conversation.add{/lang}" class="btn btn-secondary btn-3d"><span class="icon icon16 icon-asterisk"></span> <span>{lang}wcf.conversation.button.add{/lang}</span></a></li>
					{event name='contentNavigationButtonsTop'}
				</ul>
			</nav>
		</div>

		{if !$items}
			<p class="info">{lang}wcf.conversation.noConversations{/lang}</p>
		{else}
			<div class="marginTop tabularBox tabularBoxTitle messageGroupList conversationList jsClipboardContainer" data-type="com.woltlab.wcf.conversation.conversation">
				<header>
					<h2>{lang}wcf.conversation.conversations{/lang} <span class="badge badgeInverse">{#$items}</span></h2>
				</header>

				<table class="table">
					<thead>
						<tr>
							<th class="columnMark jsOnly"><label><input type="checkbox" class="jsClipboardMarkAll" /></label></th>
							<th colspan="2" class="columnTitle columnSubject{if $sortField == 'subject'} active {@$sortOrder}{/if}"><a href="{link controller='ConversationList'}{if $filter}filter={@$filter}&{/if}pageNo={@$pageNo}&sortField=subject&sortOrder={if $sortField == 'subject' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{if $labelID}&labelID={@$labelID}{/if}{/link}">{lang}wcf.global.subject{/lang}</a></th>
							<th class="columnDigits columnReplies{if $sortField == 'replies'} active {@$sortOrder}{/if}"><a href="{link controller='ConversationList'}{if $filter}filter={@$filter}&{/if}pageNo={@$pageNo}&sortField=replies&sortOrder={if $sortField == 'replies' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{if $labelID}&labelID={@$labelID}{/if}{/link}">{lang}wcf.conversation.replies{/lang}</a></th>
							<th class="columnDigits columnParticipants{if $sortField == 'participants'} active {@$sortOrder}{/if}"><a href="{link controller='ConversationList'}{if $filter}filter={@$filter}&{/if}pageNo={@$pageNo}&sortField=participants&sortOrder={if $sortField == 'participants' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{if $labelID}&labelID={@$labelID}{/if}{/link}">{lang}wcf.conversation.participants{/lang}</a></th>
							<th class="columnText columnLastPost{if $sortField == 'lastPostTime'} active {@$sortOrder}{/if}"><a href="{link controller='ConversationList'}{if $filter}filter={@$filter}&{/if}pageNo={@$pageNo}&sortField=lastPostTime&sortOrder={if $sortField == 'lastPostTime' && $sortOrder == 'ASC'}DESC{else}ASC{/if}{if $labelID}&labelID={@$labelID}{/if}{/link}">{lang}wcf.conversation.lastPostTime{/lang}</a></th>

							{event name='columnHeads'}
						</tr>
					</thead>

					<tbody>
						{foreach from=$objects item=conversation}
							<tr class="conversation jsClipboardObject{if $conversation->isNew()} new{/if}" data-conversation-id="{@$conversation->conversationID}" data-label-ids="[ {implode from=$conversation->getAssignedLabels() item=label}{@$label->labelID}{/implode} ]" data-is-closed="{@$conversation->isClosed}" data-can-close-conversation="{if $conversation->userID == $__wcf->getUser()->userID}1{else}0{/if}" data-can-add-participants="{if $conversation->canAddParticipants()}1{else}0{/if}">
								<td class="columnMark jsOnly">
									<label><input type="checkbox" class="jsClipboardItem" data-object-id="{@$conversation->conversationID}" /></label>
								</td>
								<td class="columnIcon columnAvatar">
									{if $conversation->getUserProfile()->getAvatar()}
										<div>
											<p class="framed"{if $conversation->isNew()} title="{lang}wcf.conversation.markAsRead.doubleClick{/lang}"{/if}>{@$conversation->getUserProfile()->getAvatar()->getImageTag(32)}</p>

											{if $conversation->ownPosts && $conversation->userID != $__wcf->user->userID}
												{if $__wcf->getUserProfileHandler()->getAvatar()}
													<small class="framed myAvatar" title="{lang}wcf.conversation.ownPosts{/lang}">{@$__wcf->getUserProfileHandler()->getAvatar()->getImageTag(16)}</small>
												{/if}
											{/if}
										</div>
									{/if}
								</td>
								<td class="columnText columnSubject">
									{hascontent}
										<ul class="labelList">
											{content}
												{foreach from=$conversation->getAssignedLabels() item=label}
													<li><a href="{link controller='ConversationList'}{if $filter}filter={@$filter}{/if}&sortField={$sortField}&sortOrder={$sortOrder}&pageNo={@$pageNo}&labelID={@$label->labelID}{/link}" class="badge label{if $label->cssClassName} {@$label->cssClassName}{/if}">{$label->label}</a></li>
												{/foreach}
											{/content}
										</ul>
									{/hascontent}

									<h3>
										<a href="{if $conversation->isNew()}{link controller='Conversation' object=$conversation}action=firstNew{/link}{else}{link controller='Conversation' object=$conversation}{/link}{/if}" class="conversationLink messageGroupLink" data-conversation-id="{@$conversation->conversationID}">{$conversation->subject|tableWordwrap}</a>
									</h3>

									<aside class="statusDisplay">
										{smallpages pages=$conversation->getPages() controller='Conversation' object=$conversation link='pageNo=%d'}
										<ul class="statusIcons">
											{if $conversation->isClosed}<li><span class="icon icon16 icon-lock jsIconLock jsTooltip" title="{lang}wcf.global.state.closed{/lang}"></span></li>{/if}
											{if $conversation->attachments}<li><span class="icon icon16 icon-paper-clip jsIconAttachment jsTooltip" title="{lang}wcf.conversation.attachments{/lang}"></span></li>{/if}
										</ul>
									</aside>

									<ul class="messageGroupInfo mobileOptimization">
										<li class="messageGroupAuthor">{if $conversation->userID}<a href="{link controller='User' object=$conversation->getUserProfile()->getDecoratedObject()}{/link}" class="userLink" data-user-id="{@$conversation->userID}">{$conversation->username}</a>{else}{$conversation->username}{/if}</li>
										<li class="messageGroupTime">{@$conversation->time|time}</li>
										<li class="messageGroupLastPoster">{if $conversation->lastPosterID}<a href="{link controller='User' object=$conversation->getLastPosterProfile()->getDecoratedObject()}{/link}" class="userLink" data-user-id="{@$conversation->getLastPosterProfile()->userID}">{$conversation->lastPoster}</a>{else}{$conversation->lastPoster}{/if}</li>
										<li class="messageGroupLastPostTime">{@$conversation->lastPostTime|time}</li>
										<li class="messageGroupEditLink jsOnly"><a class="jsConversationInlineEditor">{lang}wcf.global.button.edit{/lang}</a></li>
										{event name='messageGroupInfo'}
									</ul>

									{if $conversation->getParticipantSummary()|count}
										<small class="conversationParticipantSummary">
											{assign var='participantSummaryCount' value=$conversation->getParticipantSummary()|count}
											{lang}wcf.conversation.participants{/lang}: {implode from=$conversation->getParticipantSummary() item=participant}<a href="{link controller='User' object=$participant}{/link}" class="userLink{if $participant->hideConversation == 2} conversationLeft{/if}" data-user-id="{@$participant->userID}">{$participant->username}</a>{/implode}
											{if $participantSummaryCount < $conversation->participants}{lang}wcf.conversation.participants.other{/lang}{/if}
										</small>
									{/if}

									{event name='conversationData'}
								</td>
								<td class="columnDigits columnReplies">{#$conversation->replies}</td>
								<td class="columnDigits columnParticipants">{#$conversation->participants}</td>
								<td class="columnText columnLastPost">
									{if $conversation->replies != 0}
										<div class="box24">
											<a href="{link controller='Conversation' object=$conversation}action=lastPost{/link}" class="framed jsTooltip" title="{lang}wcf.conversation.gotoLastPost{/lang}">{@$conversation->getLastPosterProfile()->getAvatar()->getImageTag(24)}</a>

											<div>
												<p>
													{if $conversation->lastPosterID}
														<a href="{link controller='User' object=$conversation->getLastPosterProfile()->getDecoratedObject()}{/link}" class="userLink" data-user-id="{@$conversation->getLastPosterProfile()->userID}">{$conversation->lastPoster}</a>
													{else}
														{$conversation->lastPoster}
													{/if}
												</p>
												<small>{@$conversation->lastPostTime|time}</small>
											</div>
										</div>
									{/if}
								</td>

								{event name='columns'}
							</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		{/if}

		<div class="contentNavigation">
			{@$pagesLinks}

			<nav>
				<ul>
					<li><a href="{link controller='ConversationAdd'}{/link}" title="{lang}wcf.conversation.add{/lang}" class="btn btn-3d btn-secondary"><span class="icon icon16 icon-asterisk"></span> <span>{lang}wcf.conversation.button.add{/lang}</span></a></li>
					{event name='contentNavigationButtonsTop'}
				</ul>
			</nav>

			<nav class="jsClipboardEditor" data-types="[ 'com.woltlab.wcf.conversation.conversation' ]"></nav>
		</div>
	</div>
</div>

{include file='footer'}
</body>
</html>
