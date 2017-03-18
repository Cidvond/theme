<div class="containerHeadline">
	<h3><a href="{link controller='User' object=$user}{/link}">{$user->username}</a>{if $user->banned} <span class="icon icon16 fa-lock jsTooltip jsUserBanned" title="{lang}wcf.user.banned{/lang}"></span>{/if}{if MODULE_USER_RANK}
		{if $user->getRank() && $user->getRank()->rankImage}
			<span class="userRankImage">{@$user->getRank()->getImage()}</span>
		{/if}
	{/if}</h3>
	{if $user->getUserTitle()}
		<p style="font-size:11px;line-height:14px;" class="{if $user->getRank() && $user->getRank()->cssClassName} {@$user->getRank()->cssClassName}{/if}">{@$user->getUserTitle()}</p>
	{/if}
</div>
<ul class="dataList userFacts">
	{if $user->isAccessible('canViewProfile')}
		{if $user->isVisibleOption('gender') && $user->gender}<li>{lang}wcf.user.gender.{if $user->gender == 1}male{else}female{/if}{/lang}</li>{/if}
		{if $user->isVisibleOption('birthday') && $user->getAge()}<li>{@$user->getAge()}</li>{/if}
		{if $user->isVisibleOption('location') && $user->location}<li>{lang}wcf.user.membersList.location{/lang}</li>{/if}
	{/if}
</ul>
<ul class="userFacts">
	<li style="margin-top:5px;display:block;font-size:11px;line-height:14px;">{lang}wcf.user.membersList.enlistmentDate{/lang}</li>
	
	<li style="display:block;font-size:11px;line-height:14px;">{lang}wcf.user.membersList.registrationDate{/lang}</li>
	
	{event name='userData'}
</ul>