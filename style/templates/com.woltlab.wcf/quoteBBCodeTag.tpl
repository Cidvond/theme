{if $quoteAuthorObject}
<div class="quoteBoxAuthor">
	<div class="quoteAuthorAvatar"><a href="{link controller='User' object=$quoteAuthorObject}{/link}" class="userLink framed" data-user-id="{@$quoteAuthorObject->userID}">{@$quoteAuthorObject->getAvatar()->getImageTag(64)}</a></div>
{/if}
	<blockquote class="quoteBox containerPadding{if !$quoteAuthorObject} quoteBoxSimple{/if}"{if $quoteLink} cite="{$quoteLink}"{/if}>
		{if $quoteAuthor}
			<header>
				<h3>
					{if $quoteLink}
						<a href="{@$quoteLink}"{if $isExternalQuoteLink} class="externalURL"{if EXTERNAL_LINK_REL_NOFOLLOW || EXTERNAL_LINK_TARGET_BLANK} rel="{if EXTERNAL_LINK_REL_NOFOLLOW}nofollow{/if}{if EXTERNAL_LINK_TARGET_BLANK}{if EXTERNAL_LINK_REL_NOFOLLOW} {/if}noopener noreferrer{/if}"{/if}{if EXTERNAL_LINK_TARGET_BLANK} target="_blank"{/if}{/if}>{lang}wcf.bbcode.quote.title{/lang}</a>
					{else}
						{lang}wcf.bbcode.quote.title{/lang}
					{/if}
				</h3>
			</header>
		{/if}
		
		<div>
			{@$content}
		</div>
	</blockquote>
{if $quoteAuthorObject}
</div>
{/if}
