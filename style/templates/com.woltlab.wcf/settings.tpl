{include file='documentHeader'}

<head>
	<title>{lang}wcf.user.option.category.settings.{$category}{/lang} - {lang}wcf.user.menu.settings{/lang} - {PAGE_TITLE|language}</title>
	{include file='headInclude'}

	<script data-relocate="true">
		//<![CDATA[
		$(function() {
			new WCF.Option.Handler();
		});
		//]]>
	</script>
</head>

<body id="tpl{$templateName|ucfirst}" data-template="{$templateName}" data-application="{$templateNameApplication}">

{capture assign='__pageTitle'}
	{lang}wcf.user.menu.settings{/lang}: {lang}wcf.user.option.category.settings.{$category}{/lang}
{/capture}

{include file='userMenuSidebar'}
{include file='header' title=$__pageTitle}

<div class="container marginBottom-30 marginTop">
	<div class="col-md-3 no-padding-left">
		{include file='leftSidebar'}
	</div>
	
	<div class="col-md-9">
		{include file='userNotice'}

		{include file='formError'}

		{if $success|isset}
			<p class="alert alert-success">{lang}wcf.global.success.edit{/lang}</p>
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

		<form method="post" action="{link controller='Settings'}{/link}">
			<div>
				{if $category == 'general'}
					{if $availableLanguages|count > 1}
						<fieldset>
							<legend>{lang}wcf.user.language{/lang}</legend>

							<dl>
								<dt><label>{lang}wcf.user.language{/lang}</label></dt>
								<dd id="languageIDContainer">
									<script data-relocate="true">
										//<![CDATA[
										$(function() {
											var $languages = {
												{implode from=$availableLanguages item=language}
													'{@$language->languageID}': {
														iconPath: '{@$language->getIconPath()}',
														languageName: '{$language}'
													}
												{/implode}
											};

											new WCF.Language.Chooser('languageIDContainer', 'languageID', {@$languageID}, $languages);
										});
										//]]>
									</script>
									<noscript>
										<select name="languageID" id="languageID">
											{foreach from=$availableLanguages item=language}
												<option value="{@$language->languageID}"{if $language->languageID == $languageID} selected="selected"{/if}>{$language}</option>
											{/foreach}
										</select>
									</noscript>
								</dd>
							</dl>

							{hascontent}
								<dl>
									<dt><label>{lang}wcf.user.visibleLanguages{/lang}</label></dt>
									<dd class="floated">
									{content}
										{foreach from=$availableContentLanguages item=language}
											<label><input name="contentLanguageIDs[]" type="checkbox" value="{@$language->languageID}"{if $language->languageID|in_array:$contentLanguageIDs} checked="checked"{/if} /> {$language}</label>
										{/foreach}
									{/content}
									<small>{lang}wcf.user.visibleLanguages.description{/lang}</small></dd>
								</dl>
							{/hascontent}

							{event name='languageFields'}
						</fieldset>
					{/if}

					{if $availableStyles|count > 1}
						<fieldset>
							<legend>{lang}wcf.user.style{/lang}</legend>

							<dl>
								<dt><label for="styleID">{lang}wcf.user.style{/lang}</label></dt>
								<dd>
									<select id="styleID" name="styleID">
										<option value="0">{lang}wcf.global.defaultValue{/lang}</option>
										{foreach from=$availableStyles item=style}
											<option value="{@$style->styleID}"{if $style->styleID == $styleID} selected="selected"{/if}>{$style->styleName}</option>
										{/foreach}
									</select>
									<small>{lang}wcf.user.style.description{/lang}</small>
								</dd>
							</dl>

							{event name='styleFields'}
						</fieldset>
					{/if}
				{/if}

				{if !$optionTree|empty}
					{foreach from=$optionTree[0][categories][0][categories] item=optionCategory}
						<fieldset>
							<legend>{lang}wcf.user.option.category.{@$optionCategory[object]->categoryName}{/lang}</legend>

							{include file='userProfileOptionFieldList' options=$optionCategory[options] langPrefix='wcf.user.option.'}
						</fieldset>
					{/foreach}
				{/if}

				{event name='fieldsets'}
			</div>

			<div class="formSubmit">
				<button type="submit" class="btn btn-3d btn-primary">{lang}wcf.global.button.submit{/lang}</button>
				{if $category != 'general'}<input type="hidden" name="category" value="{$category}" />{/if}
				{@SECURITY_TOKEN_INPUT_TAG}
			</div>
		</form>
	</div>
</div>
{include file='footer'}

</body>
</html>
