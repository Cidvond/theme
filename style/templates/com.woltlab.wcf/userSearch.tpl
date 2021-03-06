{include file='documentHeader'}

<head>
	<title>{lang}wcf.user.search{/lang} - {PAGE_TITLE|language}</title>
	
	{include file='headInclude'}
	
	<script data-relocate="true">
		//<![CDATA[
		$(function() {
			new WCF.Search.User('#searchUsername', null, false, [ ], false);
		});
		//]]>
	</script>
</head>

<body id="tpl{$templateName|ucfirst}" data-template="{$templateName}" data-application="{$templateNameApplication}">

	{capture assign='sidebar'}
		{@$__boxSidebar}
	{/capture}

	{include file='header' sidebarOrientation='right' title='wcf.user.search'|language}

	<div class="container">
		{include file='userNotice'}

		{if $errorField == 'search'}
			<p class="alert alert-error">{lang}wcf.user.search.error.noMatches{/lang}</p>
		{else}
			{include file='formError'}
		{/if}

		<div class="contentNavigation">
			{hascontent}
				<nav>
					<ul>
						{content}
							{event name='contentNavigationButtons'}
						{/content}
					</ul>
				</nav>
			{/hascontent}
		</div>

		<form method="post" action="{link controller='UserSearch'}{/link}">
			<div class="container containerPadding marginTop">
				<fieldset>
					<legend>{lang}wcf.acp.user.search.conditions.general{/lang}</legend>

					<dl>
						<dt><label for="searchUsername">{lang}wcf.user.username{/lang}</label></dt>
						<dd>
							<input type="text" id="searchUsername" name="username" value="{$username}" class="medium" />
						</dd>
					</dl>

					{event name='generalFields'}
				</fieldset>

				{if !$optionTree|empty}
					{foreach from=$optionTree[0][categories] item=category}
						<fieldset>
							<legend>{lang}wcf.user.option.category.{@$category[object]->categoryName}{/lang}</legend>
							{hascontent}<p>{content}{lang __optional=true}wcf.user.option.category.{@$category[object]->categoryName}.description{/lang}{/content}</p>{/hascontent}

							{include file='userOptionFieldList' options=$category[options] langPrefix='wcf.user.option.' isSearchMode=true}
						</fieldset>
					{/foreach}
				{/if}
			</div>

			{event name='fieldsets'}

			<div class="formSubmit">
				<input type="submit" value="{lang}wcf.global.button.submit{/lang}" accesskey="s" />
				{@SECURITY_TOKEN_INPUT_TAG}
			</div>
		</form>
	</div>

	{include file='footer'}
</body>
</html>
